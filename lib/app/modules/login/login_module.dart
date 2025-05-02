import 'package:armoyu_desktop/app/modules/login/views/login_view.dart';
import 'package:get/get.dart';

class LoginModule {
  static const route = '/login';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const LoginView(),
    ),
  ];
}
