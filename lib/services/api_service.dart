import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../core/errors/app_exceptions.dart';

class ApiService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  String? _cachedToken;
  String? get accessToken => _cachedToken;

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_accessTokenKey);
        _cachedToken = token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Handle token refresh logic here if needed
        if (e.response?.statusCode == 401) {
          // Token expired, handle refresh if implemented
        }
        return handler.next(e);
      },
    ));

    _initCachedToken();
  }

  Future<void> _initCachedToken() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_accessTokenKey);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    _cachedToken = accessToken;
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    _cachedToken = null;
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

  AppException _handleDioError(DioException e) {
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
      final message = _parseMessage(data != null ? data['message'] : null, 'Error occurred');
      
      switch (response.statusCode) {
        case 400:
          return BadRequestException(message);
        case 401:
        case 403:
          return UnauthorizedException(message);
        case 500:
          return ServerException(message);
        default:
          return FetchDataException('Error occurred with code: ${response.statusCode} - $message');
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
