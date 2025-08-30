import 'package:hive/hive.dart';

class LocalStorage {
  static const String boxName = 'favorites';
  static const String favKey = 'fav_ids';
  final Box _box;

  LocalStorage._(this._box);

  static Future<LocalStorage> init() async {
    final box = await Hive.openBox(boxName);
    return LocalStorage._(box);
  }

  Set<String> getFavorites() {
    final list = _box.get(favKey, defaultValue: <String>[]);
    return Set<String>.from((list as List).cast<String>());
  }

  Future<void> saveFavorites(Set<String> ids) async {
    await _box.put(favKey, ids.toList());
  }
}