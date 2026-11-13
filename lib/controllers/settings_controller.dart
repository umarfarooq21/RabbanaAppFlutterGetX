import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const _fontScaleKey = 'font_scale';
  static const _showTransliterationKey = 'show_transliteration';
  static const _showTranslationKey = 'show_translation';

  final fontScale = 1.0.obs;
  final showTransliteration = true.obs;
  final showTranslation = true.obs;

  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    fontScale.value = _prefs!.getDouble(_fontScaleKey) ?? 1.0;
    showTransliteration.value =
        _prefs!.getBool(_showTransliterationKey) ?? true;
    showTranslation.value = _prefs!.getBool(_showTranslationKey) ?? true;
  }

  Future<void> setFontScale(double value) async {
    final next = value.clamp(0.85, 1.4);
    if (fontScale.value == next) return;
    fontScale.value = next;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setDouble(_fontScaleKey, fontScale.value);
  }

  Future<void> setShowTransliteration(bool value) async {
    if (showTransliteration.value == value) return;
    showTransliteration.value = value;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_showTransliterationKey, value);
  }

  Future<void> setShowTranslation(bool value) async {
    if (showTranslation.value == value) return;
    showTranslation.value = value;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_showTranslationKey, value);
  }
}
