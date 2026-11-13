import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/rabbana_dua.dart';

enum DuasLoadState { initial, loading, loaded, error }

class DuasController extends GetxController {
  final state = DuasLoadState.initial.obs;
  final duas = <RabbanaDua>[].obs;
  final errorMessage = RxnString();

  bool get isLoading => state.value == DuasLoadState.loading;
  bool get hasData => duas.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  RabbanaDua? byId(int id) {
    for (final dua in duas) {
      if (dua.id == id) return dua;
    }
    return null;
  }

  List<RabbanaDua> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return duas.toList();

    return duas.where((dua) {
      return dua.translation.toLowerCase().contains(q) ||
          dua.transliteration.toLowerCase().contains(q) ||
          dua.reference.toLowerCase().contains(q) ||
          dua.number.toString() == q;
    }).toList();
  }

  Future<void> load() async {
    if (state.value == DuasLoadState.loading) return;

    state.value = DuasLoadState.loading;
    errorMessage.value = null;

    try {
      final raw = await rootBundle.loadString('assets/data/rabbanas.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      final loaded = decoded
          .cast<Map<String, dynamic>>()
          .map(RabbanaDua.fromJson)
          .toList()
        ..sort((a, b) => a.number.compareTo(b.number));
      duas.assignAll(loaded);
      state.value = DuasLoadState.loaded;
    } catch (error, stackTrace) {
      debugPrint('Failed to load duas: $error\n$stackTrace');
      errorMessage.value = 'Unable to load Rabbana duas.';
      duas.clear();
      state.value = DuasLoadState.error;
    }
  }
}
