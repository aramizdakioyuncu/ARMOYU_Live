import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/chat/controllers/chat_controller.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/message_sendfield.dart';
import 'package:armoyu_desktop/app/widgets/message_widget.dart';
import 'package:armoyu_desktop/app/widgets/profile_widget.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return Obx(() {
      final selectedChat = controller.chat.value;
      if (selectedChat == null) {
        return const Center(
          child: Text(
            "Sohbet seçilmedi",
            style: TextStyle(color: Colors.white54),
          ),
        );
      }

      return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ProfileWidget.showProfileDialog(context,
                        user: Player(
                          user: User(
                            userID: selectedChat.kullID,
                            userName: selectedChat.kullAdi!.obs,
                            displayName: selectedChat.adSoyad.obs,
                            avatar: Media(
                              mediaID: selectedChat.kullID,
                              mediaType: MediaType.image,
                              mediaURL: MediaURL(
                                bigURL:
                                    selectedChat.chatImage.mediaURL.bigURL.obs,
                                normalURL: selectedChat
                                    .chatImage.mediaURL.normalURL.obs,
                                minURL:
                                    selectedChat.chatImage.mediaURL.minURL.obs,
                              ),
                            ),
                          ),
                        ));
                  },
                  child: Row(
                    children: [
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                              selectedChat.chatImage.mediaURL.minURL,
                            ),
                            radius: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Obx(
                        () => SizedBox(
                          child: Text(
                            selectedChat.adSoyad,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const SizedBox(
                        height: 20,
                        child: VerticalDivider(
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width < 1020
                            ? 120
                            : null,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                ),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text("YANİ"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                child: Obx(
                                  () => Text(
                                    selectedChat.kullAdi!,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.call),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.videocam_rounded),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.push_pin,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.person_add,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SearchBar(
                          constraints: BoxConstraints(
                            maxWidth: 150,
                          ),
                          textInputAction: TextInputAction.done,
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.black38),
                          textStyle: WidgetStatePropertyAll(
                            TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => controller.chathistory.value == null
                    ? const CupertinoActivityIndicator()
                    : Scrollbar(
                        controller: controller.chatScrollController.value,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: ListView.builder(
                          controller: controller.chatScrollController.value,
                          reverse: true,
                          itemCount: controller.chathistory.value!.length,
                          itemBuilder: (context, index) {
                            return MessageWidget.chatfield(
                              controller.chathistory.value![
                                  controller.chathistory.value!.length -
                                      1 -
                                      index],
                            );
                          },
                        ),
                      ),
              ),
            ),
            MessageSendfield.field1(
              chattextcontroller: controller.chattextcontroller,
              onsubmitted: (value) async {
                final message = controller.chattextcontroller.value.text.trim();
                if (message.isEmpty || AppList.sessions.isEmpty) {
                  return;
                }

                await ARMOYU.service.chatServices.sendchatmessage(
                  userID: selectedChat.kullID,
                  message: message,
                  type: controller.chatCategory.value.name,
                );

                controller.chathistory.value ??= [];
                controller.chathistory.value!.add(
                  Message(
                    id: 0,
                    user: AppList.sessions.first.currentUser,
                    message: message,
                    datetime: DateTime.now().toString(),
                  ),
                );
                controller.chattextcontroller.value.clear();

                controller.chathistory.refresh();
              },
            ),
          ],
        ),
      );
    });
  }
}
