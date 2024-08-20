import 'package:app/services/service_locator.dart';

class AppException implements Exception {
  final String _userFriendlyMessage;
  final String _technicalMessage;
  StackTrace? _stackTrace;
  static const defaultErrorMessage = 'An error occurred';

  // Adjusted constructor with optional positional parameters
  AppException(
      [String? userFriendlyMessage,
      String? technicalMessage,
      StackTrace? stackTrace])
      : _userFriendlyMessage = userFriendlyMessage ?? defaultErrorMessage,
        _technicalMessage =
            technicalMessage ?? userFriendlyMessage ?? defaultErrorMessage,
        _stackTrace = stackTrace {
    log.e('New exception: ${runtimeType.toString()} \n'
        ' userFriendlyMessage: $_userFriendlyMessage, \n'
        ' technicalMessage: $_technicalMessage, \n'
        ' ${_stackTrace != null ? ' stackTrace: $_stackTrace' : ''}');

    // send the technical message and stack trace to
    // crashlytics for production debugging

    _stackTrace ??= StackTrace.current;
  }

  String get technicalMessage => _technicalMessage;
  String get userFriendlyMessage => _userFriendlyMessage;
  StackTrace? get stackTrace => _stackTrace;

  @override
  String toString() => _userFriendlyMessage;
}

class ServerException extends AppException {
  final int statusCode;

  ServerException(this.statusCode, String statusMessage) : super(statusMessage);

  @override
  String get userFriendlyMessage {
    if (statusCode == 400) {
      return _userFriendlyMessage;
    } else if (statusCode == 404) {
      return 'Resource not found';
    } else if (statusCode == 500) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred.';
    }
  }
}

class FirebaseApiKeysException extends AppException {
  final String code;
  final String message;

  FirebaseApiKeysException(this.code, this.message) : super(message);

  @override
  String get userFriendlyMessage => 'Failed to get initial data from server';
}

class NoInternetException extends AppException {
  @override
  String get userFriendlyMessage =>
      'Network error. Please check your internet connection.';
}

class ApiKeyException extends AppException {
  ApiKeyException();

  @override
  String get userFriendlyMessage =>
      'Please exit and reopen the app with internet connection on';
}
