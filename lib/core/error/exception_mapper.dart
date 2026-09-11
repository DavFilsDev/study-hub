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
      if (status == 401 || status == 403) {
        return const ServerFailure('Session expirée, reconnecte-toi.');
      }
      if (status != null && status >= 500) {
        return const ServerFailure(
            'Le serveur est momentanément indisponible.');
      }
      return ServerFailure('Erreur serveur ($status)');
    default:
      return UnknownFailure(e.message ?? 'Erreur inconnue');
  }
}
