import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyhub/core/error/failures.dart';
import 'package:studyhub/features/courses/data/datasources/course_local_datasource.dart';
import 'package:studyhub/features/courses/data/datasources/course_remote_datasource.dart';
import 'package:studyhub/features/courses/data/models/course_model.dart';
import 'package:studyhub/features/courses/data/repositories/course_repository_impl.dart';

class MockRemote extends Mock implements CourseRemoteDataSource {}

class MockLocal extends Mock implements CourseLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late CourseRepositoryImpl repository;

  const tCourse = CourseModel(
    hiveId: '1',
    hiveTitle: 'Algorithmique',
    hiveCode: 'ALG101',
    hiveDescription: 'Description',
  );

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = CourseRepositoryImpl(remote: remote, local: local);
  });

  group('getCourses', () {
    test('retourne les données remote et les met en cache quand succès',
        () async {
      when(() => remote.getCourses()).thenAnswer((_) async => [tCourse]);
      when(() => local.cacheCourses(any())).thenAnswer((_) async {});

      final (courses, failure) = await repository.getCourses();

      expect(courses, [tCourse]);
      expect(failure, isNull);
      verify(() => local.cacheCourses([tCourse])).called(1);
    });

    test('retourne le cache local quand DioException et cache disponible',
        () async {
      when(() => remote.getCourses()).thenThrow(
        DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError),
      );
      when(() => local.getCachedCourses()).thenAnswer((_) async => [tCourse]);

      final (courses, failure) = await repository.getCourses();

      expect(courses, [tCourse]);
      expect(failure, isNull);
    });

    test('retourne une Failure quand DioException et cache vide', () async {
      when(() => remote.getCourses()).thenThrow(
        DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError),
      );
      when(() => local.getCachedCourses()).thenAnswer((_) async => []);

      final (courses, failure) = await repository.getCourses();

      expect(courses, isNull);
      expect(failure, isA<NetworkFailure>());
    });
  });
}
