import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_detail_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chattextcontroller = TextEditingController().obs;
  Rxn<List<Message>> chathistory = Rxn();
  var chatpage = 1.obs;
  var chatScrollController = ScrollController().obs;

  Rxn<APIChatList> chat = Rxn(null);
  Rx<APIChat> chatCategory = Rx(APIChat.ozel);

  changeChat(APIChatList chatINFO) {
    chathistory.value = [];
    chat.value = chatINFO;
    fetchChatHistory(chatINFO.kullID);
  }

  fetchChatHistory(int chatID) async {
    ChatFetchDetailResponse response =
        await ARMOYU.service.chatServices.fetchdetailChat(
      chatID: chatID,
      chatCategory: chatCategory.value,
    );

    if (!response.result.status) {
      return;
    }

    chathistory.value ??= [];
    for (APIChatDetailList element in response.response!) {
      chathistory.value!.add(
        Message(
          id: 0,
          user: Player(
            user: User(
              displayName: element.adSoyad.obs,
              avatar: Media(
                mediaID: 0,
                mediaType: MediaType.image,
                mediaURL: MediaURL(
                  bigURL: Rx(element.avatar),
                  normalURL: Rx(element.avatar),
                  minURL: Rx(element.avatar),
                ),
              ),
            ),
          ),
          message: element.mesajIcerik,
          datetime: element.zaman,
        ),
      );
    }

    chathistory.refresh();
  }
}
