import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Room {
  RxString name;
  RxInt limit;
  final RoomType type;
  List<Message>? message;
  RxList<User> currentMembers = <User>[].obs;

  Room({
    required String name,
    required int limit,
    required this.type,
    this.message,
  })  : name = name.obs,
        limit = limit.obs;

  bool isUserInAnyRoom(User user) {
    return AppList.groups.any((group) {
      return group.rooms.any((room) {
        return room.currentMembers
            .any((currentMember) => currentMember.id == user.id);
      });
    });
  }

  void removeUserFromRooms(User user) {
    for (var group in AppList.groups) {
      for (var room in group.rooms) {
        room.currentMembers
            .removeWhere((currentMember) => currentMember.id == user.id);
      }
    }
  }

  Widget roomfield(Group group) {
    final socketio = Get.find<SocketioController>(
      tag: AppList.sessions.first.currentUser.id.toString(),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              socketio.selectedRoom.value = this;

              if (socketio.selectedRoom.value!.message == null) {
                socketio.selectedRoom.value!.message = [];
              }
              socketio.chatlist.value = socketio.selectedRoom.value!.message!;

              if (isUserInAnyRoom(AppList.sessions.first.currentUser)) {
                removeUserFromRooms(AppList.sessions.first.currentUser);
                currentMembers.add(AppList.sessions.first.currentUser);
              } else {
                currentMembers.add(AppList.sessions.first.currentUser);
              }

              log(currentMembers.length.toString());
            },
            leading: Icon(
              type == RoomType.text ? Icons.tag : Icons.volume_up_rounded,
            ),
            title: Text(
              name.value,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Text(currentMembers.length.toString()),
          ),
          ...List.generate(
            currentMembers.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                    child: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                        currentMembers[index].avatar!.minUrl.toString(),
                      ),
                      radius: 14,
                    ),
                  ),
                  title: Text(
                    currentMembers[index].displayname.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mic,
                        size: 20,
                      ),
                      Icon(
                        Icons.volume_off,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

enum RoomType { voice, text }
