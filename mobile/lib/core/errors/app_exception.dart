class AppException implements Exception {
  final String message;
  final String? code;
  final bool isClientError;

  const AppException({
    required this.message,
    this.code,
    this.isClientError = false,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'Network error. Please check your connection.'})
      : super(code: 'network_error', isClientError: true);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Session expired. Please log in again.'})
      : super(code: 'unauthorized', isClientError: true);
}

class ValidationException extends AppException {
  const ValidationException({required super.message})
      : super(code: 'validation_error', isClientError: true);
}

class ServerException extends AppException {
  const ServerException({super.message = 'Server error. Please try again later.'})
      : super(code: 'server_error');
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'The requested resource was not found.'})
      : super(code: 'not_found', isClientError: true);
}
