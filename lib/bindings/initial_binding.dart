import 'package:get/get.dart';

import '../controllers/duas_controller.dart';
import '../controllers/favorites_controller.dart';

/// [SettingsController] is registered before the app is built
/// (see `main.dart` / `app.dart`) because it drives the theme.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoritesController(), permanent: true);
    Get.put(DuasController(), permanent: true);
  }
}
