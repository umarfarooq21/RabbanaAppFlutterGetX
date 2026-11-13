import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../views/dua_detail/dua_detail_view.dart';
import '../views/home/home_view.dart';
import '../views/splash/splash_view.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 700),
    ),
    GetPage(
      name: AppRoutes.duaDetail,
      page: () => const DuaDetailView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 420),
    ),
  ];
}
