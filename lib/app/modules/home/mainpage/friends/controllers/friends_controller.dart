import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/profile/profile_friendlist.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  var friendlist = RxList<Player>();

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
    ProfileFriendListResponse response =
        await ARMOYU.service.profileServices.friendlist(
      userID: AppList.sessions.first.currentUser.user.userID!,
      page: currentPage.value,
    );

    isLoadingMoreProccess.value = false;

    if (!response.result.status) {
      return;
    }

    for (APIProfileFriendlist element in response.response!) {
      log(element.toString());

      friendlist.add(
        Player(
          user: User(
            userID: element.playerID,
            displayName: element.displayName.obs,
            userName: element.username.obs,
            avatar: Media(
              mediaID: 0,
              mediaType: MediaType.image,

              mediaURL: MediaURL(
                bigURL: element.avatar.bigURL.obs,
                normalURL: element.avatar.normalURL.obs,
                minURL: element.avatar.minURL.obs,
              ),

              // isLocal: false,
            ),
          ),
        ),
      );
    }
    currentPage.value += 1;
  }
}
