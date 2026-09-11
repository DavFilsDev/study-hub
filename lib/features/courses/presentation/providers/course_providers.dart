import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/course_remote_datasource.dart';
import '../../data/datasources/course_local_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/usecases/get_courses.dart';
import '../../domain/usecases/get_course_by_id.dart';

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return CourseRemoteDataSourceImpl(ref.watch(dioProvider));
});

final courseLocalDataSourceProvider = Provider<CourseLocalDataSource>((ref) {
  return CourseLocalDataSourceImpl();
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(
    remote: ref.watch(courseRemoteDataSourceProvider),
    local: ref.watch(courseLocalDataSourceProvider),
  );
});

final getCoursesProvider =
    Provider((ref) => GetCourses(ref.watch(courseRepositoryProvider)));
final getCourseByIdProvider =
    Provider((ref) => GetCourseById(ref.watch(courseRepositoryProvider)));

final coursesResultProvider = FutureProvider<(List<Course>?, Failure?)>((ref) {
  return ref.watch(getCoursesProvider)();
});

final courseSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCoursesProvider = Provider<List<Course>>((ref) {
  final result = ref.watch(coursesResultProvider);
  final query = ref.watch(courseSearchQueryProvider).toLowerCase();
  final courses = result.value?.$1 ?? [];
  if (query.isEmpty) return courses;
  return courses
      .where((c) =>
          c.title.toLowerCase().contains(query) ||
          c.code.toLowerCase().contains(query))
      .toList();
});

final courseDetailProvider =
    FutureProvider.family<(Course?, Failure?), String>((ref, id) {
  return ref.watch(getCourseByIdProvider)(id);
});
