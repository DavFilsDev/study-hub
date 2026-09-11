import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../datasources/resource_remote_datasource.dart';
import '../datasources/resource_local_datasource.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDataSource remote;
  final ResourceLocalDataSource local;

  ResourceRepositoryImpl({required this.remote, required this.local});

  @override
  Future<(List<Resource>?, Failure?)> getResourcesByCourse(
      String courseId) async {
    try {
      final resources = await remote.getResourcesByCourse(courseId);
      await local.cacheResources(courseId, resources);
      return (resources, null);
    } on DioException catch (e) {
      final failure = mapDioExceptionToFailure(e);
      final cached = await local.getCachedResources(courseId);
      if (cached.isNotEmpty) return (cached, null);
      return (null, failure);
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }
}
