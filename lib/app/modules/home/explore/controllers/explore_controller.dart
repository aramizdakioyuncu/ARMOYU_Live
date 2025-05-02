import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var pageController = PageController().obs;
  var currentPage = 0.obs; // Şu anki sayfayı tutan değişken

  void changePage(int page) {
    currentPage.value = page;
    pageController.value.jumpToPage(page);
  }
}
