import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  var friendlist = RxList<User>();

  var scrollController = ScrollController().obs;

  var isLoadingMoreProccess = false.obs;
  var currentPage = 1.obs;
  @override
  void onInit() {
    super.onInit();
    fetchfriendlist();

    // Scroll listener ekliyoruz
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent &&
          !isLoadingMoreProccess.value) {
        // Liste sonuna ulaşıldığında yeni verileri yükle
        log('Liste sonuna ulaşıldı');
        loadMoreFriends();
      }
    });
  }

  loadMoreFriends() {
    fetchfriendlist();
  }

  fetchfriendlist() async {
    if (isLoadingMoreProccess.value) {
      return;
    }

    isLoadingMoreProccess.value = true;
    Map<String, dynamic> response =
        await ARMOYU.service.profileServices.friendlist(
      username: AppList.sessions.first.currentUser.username!,
      password: AppList.sessions.first.currentUser.password!,
      userID: AppList.sessions.first.currentUser.id!,
      page: currentPage.value,
    );

    isLoadingMoreProccess.value = false;

    if (response['durum'] == 0) {
      return;
    }

    for (var element in response['icerik']) {
      log(element.toString());

      friendlist.add(
        User(
          displayname: element['oyuncuad'],
          avatar: Media(
            id: 0,
            type: MediaType.image,
            bigUrl: element['oyuncuavatar'],
            normalUrl: element['oyuncufakavatar'],
            minUrl: element['oyuncuminnakavatar'],
            isLocal: false,
          ),
        ),
      );
    }
    currentPage.value += 1;
  }
}
