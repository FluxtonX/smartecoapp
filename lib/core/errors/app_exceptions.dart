class AppException implements Exception {
  final String message;
  final String? prefix;
  
  AppException([this.message = 'Something went wrong', this.prefix]);
  
  @override
  String toString() {
    return "${prefix != null ? "$prefix: " : ""}$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message = 'Error During Communication'])
      : super(message, 'Communication Error');
}

class BadRequestException extends AppException {
  BadRequestException([String message = 'Invalid Request'])
      : super(message, 'Bad Request');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized session'])
      : super(message, 'Unauthorized');
}

class ServerException extends AppException {
  ServerException([String message = 'Internal Server Error'])
      : super(message, 'Server Error');
}
