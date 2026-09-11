import 'package:hive/hive.dart';
import '../models/resource_model.dart';

abstract class ResourceLocalDataSource {
  Future<List<ResourceModel>> getCachedResources(String courseId);
  Future<void> cacheResources(String courseId, List<ResourceModel> resources);
}

class ResourceLocalDataSourceImpl implements ResourceLocalDataSource {
  static const boxName = 'resources_box';

  Future<Box<ResourceModel>> _box() async =>
      Hive.openBox<ResourceModel>(boxName);

  @override
  Future<List<ResourceModel>> getCachedResources(String courseId) async {
    final box = await _box();
    return box.values.where((r) => r.hiveCourseId == courseId).toList();
  }

  @override
  Future<void> cacheResources(
      String courseId, List<ResourceModel> resources) async {
    final box = await _box();
    // supprime les anciennes entrées de ce cours avant de réinsérer
    final oldKeys =
        box.keys.where((k) => box.get(k)?.hiveCourseId == courseId).toList();
    await box.deleteAll(oldKeys);
    await box.putAll({for (var r in resources) r.hiveId: r});
  }
}
