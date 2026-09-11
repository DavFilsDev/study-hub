import 'package:dio/dio.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseById(String id);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio dio;
  CourseRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CourseModel>> getCourses() async {
    final response =
        await dio.get('/courses', queryParameters: {'select': '*'});
    return (response.data as List).map((e) => CourseModel.fromJson(e)).toList();
  }

  @override
  Future<CourseModel> getCourseById(String id) async {
    final response = await dio
        .get('/courses', queryParameters: {'id': 'eq.$id', 'select': '*'});
    final list = response.data as List;
    if (list.isEmpty) throw Exception('Cours introuvable');
    return CourseModel.fromJson(list.first);
  }
}
