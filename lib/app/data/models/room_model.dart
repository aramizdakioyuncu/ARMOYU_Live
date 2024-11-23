import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Room {
  final int groupID;
  final String roomUUID;
  RxString name;
  RxInt limit;
  final RoomType type;
  RxList<Message> message;
  RxList<User> currentMembers = <User>[].obs;

  Room({
    required this.groupID,
    required this.roomUUID,
    required String name,
    required int limit,
    required this.type,
    List<Message>? message, // Null olabilen liste
  })  : name = name.obs,
        limit = limit.obs,
        message = (message ?? []).obs; // Eğer null ise boş bir liste atanır

  // Room nesnesini JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID, // Group nesnesini JSON'a çevir
      'roomUUID': roomUUID, // Group nesnesini JSON'a çevir
      'name': name.value, // RxString'den değer al
      'limit': limit.value, // RxInt'den değer al
      'type': type.index, // Enum değerini indeks olarak kaydet
      'message':
          message.map((msg) => msg.toJson()).toList(), // Mesajları JSON'a çevir
      'currentMembers': currentMembers
          .map((member) => member.toJson())
          .toList(), // Üyeleri JSON'a çevir
    };
  }

  // JSON'dan Room nesnesini oluşturma
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      groupID: json['groupID'], // Group nesnesini JSON'dan oluştur
      roomUUID: json['roomUUID'], // Group nesnesini JSON'dan oluştur
      name: json['name'],
      limit: json['limit'],
      type: RoomType.values[json['type']], // RoomType'ı enum'dan almak için
      message: (json['message'] as List<dynamic>?)
              ?.map((msg) => Message.fromJson(msg))
              .toList() // Mesajları JSON'dan oluştur
              .obs ??
          <Message>[].obs, // Null kontrolü ve varsayılan değer
    )..currentMembers.value = (json['currentMembers'] as List<dynamic>)
        .map((member) => User.fromJson(member))
        .toList(); // Mevcut üyeleri JSON'dan oluştur
  }

  bool isUserInAnyRoom(User user) {
    return AppList.groups.any((group) {
      return group.rooms!.any((room) {
        return room.currentMembers
            .any((currentMember) => currentMember.id == user.id);
      });
    });
  }

  void removeUserFromRooms(User user) {
    for (var group in AppList.groups) {
      for (var room in group.rooms!) {
        room.currentMembers.removeWhere(
            (currentMember) => currentMember.username == user.username);
      }
    }
  }

  Widget roomfield(Group group) {
    final socketio = Get.find<SocketioController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
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
                  onTap: () {
                    socketio.callUser(currentMembers[index]);
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: socketio.isSoundStreaming.value == true
                          ? Colors.amber
                          : Colors.transparent,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
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
