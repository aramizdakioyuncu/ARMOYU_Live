import 'package:armoyu_desktop/app/modules/turbo/views/turbo_view.dart';
import 'package:get/get.dart';

class TurboModule {
  static const route = '/turbo';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const TurboView(),
    ),
  ];
}
