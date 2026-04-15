import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../core/navigation/app_router.dart';
import '../model/auth_session.dart';
import '../model/user_model.dart';
import 'secure_storage_service.dart';

class ApiService {
  ApiService._internal() {
    _dio = Dio(_baseOptions);
    _refreshDio = Dio(_baseOptions);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _handleRequest,
        onError: _handleError,
      ),
    );
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final SecureStorageService _storage = SecureStorageService.instance;
  final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  late final Dio _dio;
  late final Dio _refreshDio;

  AuthSession? _session;
  Future<AuthSession?>? _sessionLoader;
  Future<bool>? _refreshFuture;

  String? get accessToken => _session?.accessToken;
  UserModel? get storedUser => _session?.user;

  Future<AuthSession?> getStoredSession() async {
    return _loadSession();
  }

  Future<UserModel?> getStoredUser() async {
    return (await _loadSession())?.user;
  }

  Future<bool> hasStoredSession() async {
    final session = await _loadSession();
    return session != null && session.accessToken.isNotEmpty;
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    UserModel? user,
  }) async {
    _session = AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
    await _storage.saveSession(_session!);
  }

  Future<void> saveUser(UserModel? user) async {
    final current = await _loadSession();
    if (current == null) {
      return;
    }

    _session = current.copyWith(user: user);
    await _storage.saveSession(_session!);
  }

  Future<void> clearSession({bool redirectToLogin = false}) async {
    _session = null;
    _sessionLoader = null;
    _refreshFuture = null;
    await _storage.clearSession();

    if (redirectToLogin) {
      scheduleMicrotask(AppRouter.redirectToLogin);
    }
  }

  Future<bool> validateOrRefreshSession() async {
    final session = await _loadSession();
    if (session == null) {
      return false;
    }

    if (!_isTokenExpired(session.accessToken)) {
      return true;
    }

    return _refreshAccessToken();
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.patch(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkipAuth(options)) {
      handler.next(options);
      return;
    }

    try {
      final session = await _loadSession();
      if (session == null) {
        handler.next(options);
        return;
      }

      if (_isTokenExpired(session.accessToken, gracePeriod: const Duration(seconds: 30))) {
        final refreshed = await _refreshAccessToken();
        if (!refreshed) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: UnauthorizedException('Session expired'),
            ),
          );
          return;
        }
      }

      final latestSession = await _loadSession();
      if (latestSession?.accessToken.isNotEmpty == true) {
        options.headers['Authorization'] = 'Bearer ${latestSession!.accessToken}';
      }

      handler.next(options);
    } catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
        ),
      );
    }
  }

  Future<void> _handleError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final isUnauthorized = error.response?.statusCode == 401;
    final alreadyRetried = request.extra['retried'] == true;

    if (
        isUnauthorized &&
        !_shouldSkipAuth(request) &&
        !alreadyRetried &&
        await hasStoredSession()) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        try {
          final response = await _retryRequest(request);
          handler.resolve(response);
          return;
        } on DioException catch (retryError) {
          handler.next(retryError);
          return;
        }
      }
    }

    handler.next(error);
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions request) async {
    final session = await _loadSession();
    final headers = Map<String, dynamic>.from(request.headers);
    if (session?.accessToken.isNotEmpty == true) {
      headers['Authorization'] = 'Bearer ${session!.accessToken}';
    }

    return _dio.fetch<dynamic>(
      request.copyWith(
        headers: headers,
        extra: {
          ...request.extra,
          'retried': true,
        },
      ),
    );
  }

  Future<AuthSession?> _loadSession() async {
    if (_session != null) {
      return _session;
    }

    if (_sessionLoader != null) {
      return _sessionLoader!;
    }

    _sessionLoader = _storage.readSession();
    final loaded = await _sessionLoader!;
    _session = loaded;
    _sessionLoader = null;
    return loaded;
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    final completer = Completer<bool>();
    _refreshFuture = completer.future;

    try {
      final session = await _loadSession();
      if (session == null || session.refreshToken.isEmpty) {
        await clearSession(redirectToLogin: true);
        completer.complete(false);
        return completer.future;
      }

      final response = await _refreshDio.post(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': session.refreshToken,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final newAccessToken = data['accessToken'] as String?;
      final newRefreshToken =
          (data['refreshToken'] as String?) ?? session.refreshToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await clearSession(redirectToLogin: true);
        completer.complete(false);
        return completer.future;
      }

      _session = session.copyWith(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
      await _storage.saveSession(_session!);
      completer.complete(true);
      return completer.future;
    } on DioException {
      await clearSession(redirectToLogin: true);
      completer.complete(false);
      return completer.future;
    } finally {
      _refreshFuture = null;
    }
  }

  bool _shouldSkipAuth(RequestOptions options) {
    final path = options.path;
    return path == ApiConstants.sendOtp ||
        path == ApiConstants.verifyOtp ||
        path == ApiConstants.refreshToken ||
        path == ApiConstants.googleLogin;
  }

  bool _isTokenExpired(String token, {Duration gracePeriod = Duration.zero}) {
    final expiry = _getTokenExpiry(token);
    if (expiry == null) {
      return true;
    }

    return DateTime.now().add(gracePeriod).isAfter(expiry);
  }

  DateTime? _getTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      ) as Map<String, dynamic>;

      final exp = payload['exp'];
      if (exp is! num) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
    } catch (_) {
      return null;
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return FetchDataException('Connection Timed Out');
    }

    if (e.error is SocketException) {
      return FetchDataException('No Internet connection');
    }

    final response = e.response;
    if (response != null) {
      final data = response.data;
      final message = _parseMessage(
        data is Map<String, dynamic> ? data['message'] : null,
        'Error occurred',
      );

      switch (response.statusCode) {
        case 400:
          return BadRequestException(message);
        case 401:
        case 403:
          return UnauthorizedException(message);
        case 500:
          return ServerException(message);
        default:
          return FetchDataException(
            'Error occurred with code: ${response.statusCode} - $message',
          );
      }
    }

    return FetchDataException('Unexpected error occurred: ${e.message}');
  }

  String _parseMessage(dynamic msg, String defaultMsg) {
    if (msg == null) return defaultMsg;
    if (msg is List) return msg.join(', ');
    return msg.toString();
  }
}
