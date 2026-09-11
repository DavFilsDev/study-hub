import 'package:dio/dio.dart';
import 'failures.dart';

Failure mapDioExceptionToFailure(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      return ServerFailure('Erreur serveur ($status)');
    default:
      return UnknownFailure(e.message ?? 'Erreur inconnue');
  }
}
