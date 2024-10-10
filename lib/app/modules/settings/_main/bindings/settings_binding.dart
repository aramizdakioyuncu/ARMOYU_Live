import 'package:armoyu_desktop/app/modules/settings/_main/views/settings_view.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsView>(() => const SettingsView());
  }
}
