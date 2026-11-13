import 'package:get/get.dart';

import '../controllers/duas_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController(), permanent: true);
    Get.put(FavoritesController(), permanent: true);
    Get.put(DuasController(), permanent: true);
  }
}
