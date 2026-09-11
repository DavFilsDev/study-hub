import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/resource_remote_datasource.dart';
import '../../data/datasources/resource_local_datasource.dart';
import '../../data/datasources/favorite_local_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../../domain/usecases/get_resources_by_course.dart';

final resourceRemoteDataSourceProvider =
    Provider<ResourceRemoteDataSource>((ref) {
  return ResourceRemoteDataSourceImpl(ref.watch(dioProvider));
});

final resourceLocalDataSourceProvider =
    Provider<ResourceLocalDataSource>((ref) {
  return ResourceLocalDataSourceImpl();
});

final favoriteLocalDataSourceProvider =
    Provider((ref) => FavoriteLocalDataSource());

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  return ResourceRepositoryImpl(
    remote: ref.watch(resourceRemoteDataSourceProvider),
    local: ref.watch(resourceLocalDataSourceProvider),
  );
});

final getResourcesByCourseProvider = Provider(
    (ref) => GetResourcesByCourse(ref.watch(resourceRepositoryProvider)));

final resourcesResultProvider =
    FutureProvider.family<(List<Resource>?, Failure?), String>((ref, courseId) {
  return ref.watch(getResourcesByCourseProvider)(courseId);
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(favoriteLocalDataSourceProvider));
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoriteLocalDataSource _ds;
  FavoritesNotifier(this._ds) : super({}) {
    _load();
  }

  Future<void> _load() async => state = await _ds.getFavorites();

  Future<void> toggle(String resourceId) async {
    await _ds.toggleFavorite(resourceId);
    final updated = Set<String>.from(state);
    updated.contains(resourceId)
        ? updated.remove(resourceId)
        : updated.add(resourceId);
    state = updated;
  }
}
