import 'package:armoyu_desktop/app/modules/login/views/login_view.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginView>(() => const LoginView());
  }
}
