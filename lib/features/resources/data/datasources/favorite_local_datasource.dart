import 'package:hive/hive.dart';

class FavoriteLocalDataSource {
  static const boxName = 'favorites_box';

  Future<Box> _box() async => Hive.openBox(boxName);

  Future<Set<String>> getFavorites() async {
    final box = await _box();
    return (box.get('ids', defaultValue: <String>[]) as List)
        .cast<String>()
        .toSet();
  }

  Future<void> toggleFavorite(String resourceId) async {
    final box = await _box();
    final current = (box.get('ids', defaultValue: <String>[]) as List)
        .cast<String>()
        .toSet();
    current.contains(resourceId)
        ? current.remove(resourceId)
        : current.add(resourceId);
    await box.put('ids', current.toList());
  }
}
