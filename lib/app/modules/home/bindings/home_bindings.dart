import 'package:armoyu_desktop/app/modules/home/views/home_view.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeView>(() => const HomeView());
  }
}
