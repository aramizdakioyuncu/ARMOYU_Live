import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSendfield {
  static Widget field1(Group groupInfo, Room room, var chattextcontroller) {
    var textcontroller = chattextcontroller;
    final socketio = Get.find<SocketioController>();
    return Visibility(
      // visible: socketio.chatlist.value == null ? false : true,
      visible: socketio.groups.value!.first.rooms == null ? false : true,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 24, 24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_circle_rounded,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  autofocus: true,
                  controller: textcontroller.value,
                  onSubmitted: (value) {
                    Message message = Message(
                      user: AppList.sessions.first.currentUser,
                      message: value,
                      datetime: DateTime.now(),
                      room: room,
                    );
                    socketio.sendMessage(message);
                    textcontroller.value.clear();
                  },
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.card_giftcard,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.gif,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.emoji_emotions,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
