import 'package:armoyu_desktop/app/modules/splash/views/splash_view.dart';
import 'package:get/get.dart';

class SplashModule {
  static const route = '/';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SplashView(),
    ),
  ];
}
