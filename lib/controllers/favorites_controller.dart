import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController {
  static const _storageKey = 'favorite_dua_ids';

  final favoriteIds = <int>{}.obs;
  SharedPreferences? _prefs;

  int get count => favoriteIds.length;

  bool isFavorite(int duaId) => favoriteIds.contains(duaId);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    final stored = _prefs!.getStringList(_storageKey) ?? const [];
    favoriteIds
      ..clear()
      ..addAll(stored.map(int.tryParse).whereType<int>());
    favoriteIds.refresh();
  }

  Future<void> toggle(int duaId) async {
    if (favoriteIds.contains(duaId)) {
      favoriteIds.remove(duaId);
    } else {
      favoriteIds.add(duaId);
    }
    await _persist();
  }

  Future<void> add(int duaId) async {
    if (favoriteIds.add(duaId)) {
      await _persist();
    }
  }

  Future<void> remove(int duaId) async {
    if (favoriteIds.remove(duaId)) {
      await _persist();
    }
  }

  Future<void> clear() async {
    if (favoriteIds.isEmpty) return;
    favoriteIds.clear();
    await _persist();
  }

  Future<void> _persist() async {
    _prefs ??= await SharedPreferences.getInstance();
    final values = favoriteIds.map((id) => id.toString()).toList()..sort();
    await _prefs!.setStringList(_storageKey, values);
  }
}
