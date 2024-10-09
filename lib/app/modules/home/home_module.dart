import 'package:armoyu_desktop/app/modules/home/bindings/home_bindings.dart';
import 'package:armoyu_desktop/app/modules/home/views/home_view.dart';
import 'package:get/get.dart';

class HomeModule {
  static const route = '/home';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const HomeView(),
      binding: HomeBindings(),
    ),
  ];
}
