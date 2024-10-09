import 'package:armoyu_desktop/app/modules/splash/views/splash_view.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashView>(() => const SplashView());
  }
}
