import 'package:armoyu_desktop/app/modules/settings/bindings/settings_binding.dart';
import 'package:armoyu_desktop/app/modules/settings/views/settings_view.dart';
import 'package:get/get.dart';

class SettingsModule {
  static const route = '/settings';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
