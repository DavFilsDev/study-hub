import '../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourseById {
  final CourseRepository repository;
  GetCourseById(this.repository);

  Future<(Course?, Failure?)> call(String id) => repository.getCourseById(id);
}
