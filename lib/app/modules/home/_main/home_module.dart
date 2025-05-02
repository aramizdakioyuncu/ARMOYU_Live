import 'package:armoyu_desktop/app/modules/home/_main/views/home_view.dart';
import 'package:get/get.dart';

class HomeModule {
  static const route = '/home';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const HomeView(),
    ),
  ];
}
