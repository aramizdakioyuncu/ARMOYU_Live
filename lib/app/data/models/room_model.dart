import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Room {
  final Group group;
  RxString name;
  RxInt limit;
  final RoomType type;
  List<Message>? message;
  RxList<User> currentMembers = <User>[].obs;

  Room({
    required this.group,
    required String name,
    required int limit,
    required this.type,
    this.message,
  })  : name = name.obs,
        limit = limit.obs;

  // JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'group': group,
      'name': name.value,
      'limit': limit.value,
      'type': roomTypeToString(type), // RoomType'i string'e çeviriyoruz
      'message': message?.map((msg) => msg.toJson()).toList(),
      'currentMembers': currentMembers.map((user) => user.toJson()).toList(),
    };
  }

  // JSON'dan nesne oluşturma
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      group: Group.fromJson(json['group']),
      name: json['name'],
      limit: json['limit'],
      type: stringToRoomType(json['type']),
      message: (json['message'] as List<dynamic>?)
          ?.map((msg) => Message.fromJson(msg))
          .toList(),
    )..currentMembers.value = (json['currentMembers'] as List<dynamic>)
        .map((user) => User.fromJson(user))
        .toList();
  }

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
        room.currentMembers.removeWhere(
            (currentMember) => currentMember.username == user.username);
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

              socketio.changeroom(this);
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
                  trailing: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentMembers[index].microphone.value != true
                            ? Icon(
                                Icons.mic_off,
                                color: currentMembers[index]
                                            .microphoneAccess
                                            .value ==
                                        true
                                    ? Colors.red
                                    : Colors.grey,
                                size: 20,
                              )
                            : Container(),
                        currentMembers[index].speaker.value != true
                            ? Icon(
                                Icons.headset_off,
                                color:
                                    currentMembers[index].speakerAccess.value ==
                                            true
                                        ? Colors.red
                                        : Colors.grey,
                                size: 20,
                              )
                            : Container(),
                      ],
                    ),
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

// RoomType enum'ı JSON ile dönüştürmek için iki yardımcı fonksiyon:
String roomTypeToString(RoomType type) {
  return type.toString().split('.').last; // RoomType'dan string'e dönüştürür
}

RoomType stringToRoomType(String type) {
  return RoomType.values.firstWhere(
      (e) => e.toString().split('.').last == type); // String'den RoomType'a
}
