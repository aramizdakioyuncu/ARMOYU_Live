import 'package:armoyu_desktop/app/modules/settings/_main/views/settings_view.dart';
import 'package:get/get.dart';

class SettingsModule {
  static const route = '/settings';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SettingsView(),
    ),
  ];
}
