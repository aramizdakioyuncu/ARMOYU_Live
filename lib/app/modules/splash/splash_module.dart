import 'package:armoyu_desktop/app/modules/splash/bindings/splash_bindings.dart';
import 'package:armoyu_desktop/app/modules/splash/views/splash_view.dart';
import 'package:get/get.dart';

class SplashModule {
  static const route = '/';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
