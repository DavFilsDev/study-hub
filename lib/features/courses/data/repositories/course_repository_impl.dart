import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';
import '../datasources/course_local_datasource.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remote;
  final CourseLocalDataSource local;

  CourseRepositoryImpl({required this.remote, required this.local});

  @override
  Future<(List<Course>?, Failure?)> getCourses() async {
    try {
      final courses = await remote.getCourses();
      await local.cacheCourses(courses);
      return (courses, null);
    } on DioException catch (e) {
      final failure = mapDioExceptionToFailure(e);
      final cached = await local.getCachedCourses();
      if (cached.isNotEmpty) return (cached, null);
      return (null, failure);
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<(Course?, Failure?)> getCourseById(String id) async {
    try {
      final course = await remote.getCourseById(id);
      return (course, null);
    } on DioException catch (e) {
      final failure = mapDioExceptionToFailure(e);
      final cached = await local.getCachedCourseById(id);
      if (cached != null) return (cached, null);
      return (null, failure);
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }
}
