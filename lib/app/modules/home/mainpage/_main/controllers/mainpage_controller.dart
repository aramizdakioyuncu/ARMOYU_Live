import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainpageController extends GetxController {
  Rxn<List<APIChatList>> chatList = Rxn();
  var chatproccess = false.obs;
  var chatpage = 1.obs;

  var homeSelectedPage = 0.obs;
  var pageviewController = PageController().obs;

  @override
  void onInit() {
    fetchchats();
    super.onInit();
  }

  Future<void> fetchchats() async {
    if (chatproccess.value) {
      return;
    }

    chatproccess.value = true;
    ChatListResponse response =
        await ARMOYU.service.chatServices.currentChatList(page: chatpage.value);
    chatproccess.value = false;

    if (!response.result.status) {
      fetchchats();
      return;
    }

    chatList.value ??= [];
    for (var element in response.response!) {
      chatList.value!.add(element);
    }

    chatpage.value++;
  }
}
