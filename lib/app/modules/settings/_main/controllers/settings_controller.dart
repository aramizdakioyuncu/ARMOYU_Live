import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var selectedItem = 0.obs;
  var controller = ScrollController().obs;

  @override
  void onClose() {
    controller.value.dispose();
    super.onClose();
  }
}
