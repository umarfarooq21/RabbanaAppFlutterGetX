import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'controllers/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved settings before the first frame so the chosen theme
  // is applied immediately instead of flashing the default.
  final settings = SettingsController();
  await settings.load();
  Get.put(settings, permanent: true);

  runApp(const RabbanaApp());
}
