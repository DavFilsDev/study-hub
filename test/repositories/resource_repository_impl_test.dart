import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyhub/core/error/failures.dart';
import 'package:studyhub/features/resources/data/datasources/resource_local_datasource.dart';
import 'package:studyhub/features/resources/data/datasources/resource_remote_datasource.dart';
import 'package:studyhub/features/resources/data/models/resource_model.dart';
import 'package:studyhub/features/resources/data/repositories/resource_repository_impl.dart';

class MockRemote extends Mock implements ResourceRemoteDataSource {}

class MockLocal extends Mock implements ResourceLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late ResourceRepositoryImpl repository;

  const tResource = ResourceModel(
    hiveId: 'r1',
    hiveCourseId: '1',
    hiveTitle: 'Cours PDF',
    hiveType: 'pdf',
    hiveUrl: 'https://example.com/doc.pdf',
  );

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = ResourceRepositoryImpl(remote: remote, local: local);
  });

  test('retourne les ressources remote et les met en cache', () async {
    when(() => remote.getResourcesByCourse('1'))
        .thenAnswer((_) async => [tResource]);
    when(() => local.cacheResources('1', any())).thenAnswer((_) async {});

    final (resources, failure) = await repository.getResourcesByCourse('1');

    expect(resources, [tResource]);
    expect(failure, isNull);
    verify(() => local.cacheResources('1', [tResource])).called(1);
  });

  test('retourne le cache local en cas de coupure réseau', () async {
    when(() => remote.getResourcesByCourse('1')).thenThrow(
      DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError),
    );
    when(() => local.getCachedResources('1'))
        .thenAnswer((_) async => [tResource]);

    final (resources, failure) = await repository.getResourcesByCourse('1');

    expect(resources, [tResource]);
    expect(failure, isNull);
  });

  test('retourne une ServerFailure sur erreur HTTP 500', () async {
    when(() => remote.getResourcesByCourse('1')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response:
            Response(requestOptions: RequestOptions(path: ''), statusCode: 500),
      ),
    );
    when(() => local.getCachedResources('1')).thenAnswer((_) async => []);

    final (resources, failure) = await repository.getResourcesByCourse('1');

    expect(resources, isNull);
    expect(failure, isA<ServerFailure>());
  });
}
