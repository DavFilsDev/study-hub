import 'package:hive/hive.dart';
import '../models/course_model.dart';

abstract class CourseLocalDataSource {
  Future<List<CourseModel>> getCachedCourses();
  Future<void> cacheCourses(List<CourseModel> courses);
  Future<CourseModel?> getCachedCourseById(String id);
}

class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  static const boxName = 'courses_box';

  Future<Box<CourseModel>> _box() async => Hive.openBox<CourseModel>(boxName);

  @override
  Future<List<CourseModel>> getCachedCourses() async {
    final box = await _box();
    return box.values.toList();
  }

  @override
  Future<void> cacheCourses(List<CourseModel> courses) async {
    final box = await _box();
    await box.clear();
    await box.putAll({for (var c in courses) c.hiveId: c});
  }

  @override
  Future<CourseModel?> getCachedCourseById(String id) async {
    final box = await _box();
    return box.get(id);
  }
}
