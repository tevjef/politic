import 'dart:io';

import 'package:logging/logging.dart';

var errorLogger = new Logger('error');

class ErrorTransformer<T> {
  static Future<T> transform<T>(Future<T> f) {
    return f.catchError((error) {
      errorLogger.info(error);
      if (error is IOException) {
        throw NetworkError(
            "Could not connect to servers.", true, error);
      }
      throw GenericError("Opps! Something went wrong.", error);
    });
  }
}

abstract class Retryable {
  bool canRetry();
}

class NetworkError implements Exception, Retryable {
  final String message;
  final bool isRetryable;
  final Exception cause;

  const NetworkError(this.message, this.isRetryable, this.cause);

  @override
  String toString() => message;

  @override
  bool canRetry() => isRetryable;
}

class AuthException implements Exception {
  final String message;
  final Object cause;

  const AuthException(this.message, this.cause);

  @override
  String toString() => message;
}

class GenericError implements Exception, Retryable {
  final String message;
  final Object cause;

  const GenericError(this.message, this.cause);

  @override
  String toString() => message;

  @override
  bool canRetry() => false;
}
