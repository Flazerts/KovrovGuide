import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  SharedPreferences? _prefs;
  Set<int> favoriteIds = <int>{};
  List<int> planIds = <int>[];
  String searchQuery = '';
  String? selectedCategory;

  Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      favoriteIds = (_prefs?.getStringList('kovrov_favorites') ?? <String>[])
          .map(int.tryParse)
          .whereType<int>()
          .toSet();
      planIds = (_prefs?.getStringList('kovrov_plan') ?? <String>[])
          .map(int.tryParse)
          .whereType<int>()
          .toList();
    } catch (_) {
      // При недоступном хранилище приложение продолжит работать до закрытия.
    }
  }

  bool isFavorite(int id) => favoriteIds.contains(id);
  bool isInPlan(int id) => planIds.contains(id);

  Future<void> toggleFavorite(int id) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    notifyListeners();
    await _save();
  }

  Future<void> togglePlan(int id) async {
    if (planIds.contains(id)) {
      planIds.remove(id);
    } else {
      planIds.add(id);
    }
    notifyListeners();
    await _save();
  }

  /// Adds an item only once; useful when building a route from the catalogue.
  Future<void> addToPlan(int id) async {
    if (planIds.contains(id)) return;
    planIds = <int>[...planIds, id];
    notifyListeners();
    await _save();
  }

  /// Reorders a point without changing the selected places.
  Future<void> movePlanItem(int id, int offset) async {
    final currentIndex = planIds.indexOf(id);
    if (currentIndex < 0 || offset == 0) return;
    final targetIndex = currentIndex + offset;
    if (targetIndex < 0 || targetIndex >= planIds.length) return;
    final reordered = List<int>.from(planIds);
    final value = reordered.removeAt(currentIndex);
    reordered.insert(targetIndex, value);
    planIds = reordered;
    notifyListeners();
    await _save();
  }

  Future<void> removeFromPlan(int id) async {
    planIds.remove(id);
    notifyListeners();
    await _save();
  }

  Future<void> clearPlan() async {
    planIds = <int>[];
    notifyListeners();
    await _save();
  }

  Future<void> createSuggestedPlan() async {
    planIds = <int>[1, 8, 9, 10];
    notifyListeners();
    await _save();
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      await _prefs?.setStringList('kovrov_favorites', favoriteIds.map((e) => e.toString()).toList());
      await _prefs?.setStringList('kovrov_plan', planIds.map((e) => e.toString()).toList());
    } catch (_) {
      // Не блокируем основную функциональность из-за ошибки сохранения.
    }
  }
}
