import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RecitationSpeed {
  slow('Slow', 0.3),
  normal('Normal', 0.42),
  fast('Fast', 0.55);

  const RecitationSpeed(this.label, this.rate);

  final String label;
  final double rate;
}

class SettingsController extends GetxController {
  static const _themeModeKey = 'theme_mode';
  static const _fontScaleKey = 'font_scale';
  static const _showTransliterationKey = 'show_transliteration';
  static const _showTranslationKey = 'show_translation';
  static const _recitationSpeedKey = 'recitation_speed';

  static const minFontScale = 0.85;
  static const maxFontScale = 1.4;

  final themeMode = ThemeMode.system.obs;
  final fontScale = 1.0.obs;
  final showTransliteration = true.obs;
  final showTranslation = true.obs;
  final recitationSpeed = RecitationSpeed.normal.obs;

  SharedPreferences? _prefs;
  bool _loaded = false;

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await _store;
    themeMode.value = ThemeMode.values.firstWhere(
      (m) => m.name == prefs.getString(_themeModeKey),
      orElse: () => ThemeMode.system,
    );
    fontScale.value = prefs.getDouble(_fontScaleKey) ?? 1.0;
    showTransliteration.value = prefs.getBool(_showTransliterationKey) ?? true;
    showTranslation.value = prefs.getBool(_showTranslationKey) ?? true;
    recitationSpeed.value = RecitationSpeed.values.firstWhere(
      (s) => s.name == prefs.getString(_recitationSpeedKey),
      orElse: () => RecitationSpeed.normal,
    );
    _loaded = true;
  }

  Future<void> setThemeMode(ThemeMode value) async {
    if (themeMode.value == value) return;
    themeMode.value = value;
    await (await _store).setString(_themeModeKey, value.name);
  }

  Future<void> setFontScale(double value) async {
    final next = value.clamp(minFontScale, maxFontScale).toDouble();
    if (fontScale.value == next) return;
    fontScale.value = next;
    await (await _store).setDouble(_fontScaleKey, next);
  }

  Future<void> setShowTransliteration(bool value) async {
    if (showTransliteration.value == value) return;
    showTransliteration.value = value;
    await (await _store).setBool(_showTransliterationKey, value);
  }

  Future<void> setShowTranslation(bool value) async {
    if (showTranslation.value == value) return;
    showTranslation.value = value;
    await (await _store).setBool(_showTranslationKey, value);
  }

  Future<void> setRecitationSpeed(RecitationSpeed value) async {
    if (recitationSpeed.value == value) return;
    recitationSpeed.value = value;
    await (await _store).setString(_recitationSpeedKey, value.name);
  }

  Future<void> resetToDefaults() async {
    themeMode.value = ThemeMode.system;
    fontScale.value = 1.0;
    showTransliteration.value = true;
    showTranslation.value = true;
    recitationSpeed.value = RecitationSpeed.normal;
    final prefs = await _store;
    await Future.wait([
      prefs.remove(_themeModeKey),
      prefs.remove(_fontScaleKey),
      prefs.remove(_showTransliterationKey),
      prefs.remove(_showTranslationKey),
      prefs.remove(_recitationSpeedKey),
    ]);
  }
}
