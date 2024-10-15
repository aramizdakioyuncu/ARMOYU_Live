import 'package:armoyu_desktop/app/modules/home/home_module.dart';
import 'package:armoyu_desktop/app/modules/login/login_module.dart';
import 'package:armoyu_desktop/app/modules/settings/settings_module.dart';
import 'package:armoyu_desktop/app/modules/splash/splash_module.dart';

class AppPages {
  static const initial = SplashModule.route;

  static final routes = [
    ...SplashModule.routes,
    ...HomeModule.routes,
    ...SettingsModule.routes,
    ...LoginModule.routes,
  ];
}
