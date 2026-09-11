import '../../../../core/error/failures.dart';
import '../entities/course.dart';

abstract class CourseRepository {
  Future<(List<Course>?, Failure?)> getCourses();
  Future<(Course?, Failure?)> getCourseById(String id);
}
