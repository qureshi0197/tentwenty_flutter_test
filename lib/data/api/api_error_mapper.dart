import 'package:dio/dio.dart';

String mapDioError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection.';

      case DioExceptionType.badResponse:
        return 'Server error. Please try later.';

      default:
        return 'Something went wrong.';
    }
  }

  return 'Unexpected error occurred.';
}
