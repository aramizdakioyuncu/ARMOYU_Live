import 'package:armoyu_desktop/app/modules/home/mainpage/_main/controllers/mainpage_controller.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/chat/controllers/chat_controller.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/chat/views/chat_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/events/views/events_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/friends/views/friends_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/library/views/library_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/turbo/views/turbo_view.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainpageView extends StatelessWidget {
  const MainpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainpageController());

    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Material(
            color: const Color.fromARGB(255, 29, 29, 29),
            child: Obx(
              () => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              controller.pageviewController.value.jumpToPage(0);
                            },
                            selected: controller.homeSelectedPage.value == 0
                                ? true
                                : false,
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.gamepad,
                              ),
                            ),
                            title: const Text("Etkinlik"),
                          ),
                          ListTile(
                            onTap: () {
                              controller.pageviewController.value.jumpToPage(1);
                            },
                            selected: controller.homeSelectedPage.value == 1
                                ? true
                                : false,
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.book_sharp,
                              ),
                            ),
                            title: const Text("Kitaplık"),
                          ),
                          ListTile(
                            onTap: () {
                              controller.pageviewController.value.jumpToPage(2);
                            },
                            selected: controller.homeSelectedPage.value == 2
                                ? true
                                : false,
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.speed,
                              ),
                            ),
                            title: const Text("Turbo"),
                          ),
                          ListTile(
                            onTap: () {
                              controller.pageviewController.value.jumpToPage(3);
                            },
                            selected: controller.homeSelectedPage.value == 3
                                ? true
                                : false,
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.group,
                              ),
                            ),
                            title: const Text("Arkadaşlar"),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "DİREKT MESAJLAR",
                              ),
                            ),
                          ),
                          Column(
                            children: controller.chatList.value == null
                                ? [const CupertinoActivityIndicator()]
                                : List.generate(
                                    controller.chatList.value!.length,
                                    (index) {
                                      APIChatList chatINFO =
                                          controller.chatList.value![index];
                                      final chatcontroller =
                                          Get.put(ChatController());
                                      return ListTile(
                                        onTap: () {
                                          controller.pageviewController.value
                                              .jumpToPage(4);

                                          chatcontroller.changeChat(chatINFO);
                                        },
                                        selected:
                                            controller.homeSelectedPage.value ==
                                                        4 &&
                                                    chatINFO.sohbetTuru ==
                                                        chatcontroller
                                                            .chat
                                                            .value!
                                                            .sohbetTuru &&
                                                    chatINFO.kullAdi ==
                                                        chatcontroller
                                                            .chat.value!.kullAdi
                                                ? true
                                                : false,
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: CircleAvatar(
                                            foregroundImage:
                                                CachedNetworkImageProvider(
                                              chatINFO
                                                  .chatImage.mediaURL.minURL,
                                            ),
                                            radius: 15,
                                          ),
                                        ),
                                        title: Text(chatINFO.adSoyad),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Bottomusermenu.field(AppList.sessions.first.currentUser),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: PageView(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageviewController.value,
            onPageChanged: (value) {
              controller.homeSelectedPage.value = value;
            },
            children: const [
              EventsView(),
              LibraryView(),
              TurboView(),
              FriendsView(),
              ChatView(),
            ],
          ),
        ),
      ],
    );
  }
}
