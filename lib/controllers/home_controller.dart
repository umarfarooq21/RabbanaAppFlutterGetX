import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/rabbana_dua.dart';
import '../routes/app_routes.dart';
import 'duas_controller.dart';
import 'favorites_controller.dart';

enum HomeFilter { all, favorites }

class HomeController extends GetxController {
  final DuasController duasController = Get.find();
  final FavoritesController favoritesController = Get.find();

  final searchController = TextEditingController();
  final filter = HomeFilter.all.obs;
  final query = ''.obs;

  List<RabbanaDua> get visibleDuas {
    // Ensure Obx tracks these reactive sources.
    favoritesController.favoriteIds.length;
    duasController.duas.length;

    var list = duasController.search(query.value);
    if (filter.value == HomeFilter.favorites) {
      list = list
          .where((d) => favoritesController.isFavorite(d.id))
          .toList();
    }
    return list;
  }

  void onSearchChanged(String value) {
    query.value = value;
  }

  void clearSearch() {
    searchController.clear();
    query.value = '';
  }

  void setFilter(HomeFilter value) {
    filter.value = value;
  }

  void openDua(RabbanaDua dua) {
    Get.toNamed(AppRoutes.duaDetail, arguments: dua.id);
  }

  Future<void> retryLoad() => duasController.load();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
