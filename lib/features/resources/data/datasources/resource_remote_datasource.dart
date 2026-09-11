import 'package:dio/dio.dart';
import '../models/resource_model.dart';

abstract class ResourceRemoteDataSource {
  Future<List<ResourceModel>> getResourcesByCourse(String courseId);
}

class ResourceRemoteDataSourceImpl implements ResourceRemoteDataSource {
  final Dio dio;
  ResourceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ResourceModel>> getResourcesByCourse(String courseId) async {
    final response = await dio.get('/resources', queryParameters: {
      'course_id': 'eq.$courseId',
      'select': '*',
    });
    return (response.data as List)
        .map((e) => ResourceModel.fromJson(e))
        .toList();
  }
}
