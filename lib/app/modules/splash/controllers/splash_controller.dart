import 'dart:async';

import 'package:get/get.dart';

class SplashController extends GetxController {
  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();

    _navigationTimer = Timer(const Duration(seconds: 2), () {
      Get.offNamed("/login");
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    super.onClose();
  }
}
