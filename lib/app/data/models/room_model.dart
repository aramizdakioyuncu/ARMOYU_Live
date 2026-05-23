import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:get/get.dart';

class Room {
  final int groupID;
  final int roomID;
  RxString name;
  Rxn<int> limit;
  final RoomType type;
  RxList<Message> message;
  RxList<Player> currentMembers = <Player>[].obs;

  Room({
    required this.groupID,
    required this.roomID,
    required String name,
    required int? limit,
    required this.type,
    List<Message>? message, // Null olabilen liste
  })  : name = name.obs,
        limit = Rxn(limit),
        message = (message ?? []).obs; // Eğer null ise boş bir liste atanır

  // Socket emit için minimal payload (messages ve currentMembers dahil değil)
  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'roomID': roomID,
      'name': name.value,
      'limit': limit.value,
      'type': type.index,
    };
  }

  // JSON'dan Room nesnesini oluşturma
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      groupID: json['groupID'], // Group nesnesini JSON'dan oluştur
      roomID: (json['roomUUID'] ?? json['roomID']) as int,
      name: json['name'],
      limit: json['limit'],
      type: RoomType.values[json['type']], // RoomType'ı enum'dan almak için
      message: (json['message'] as List<dynamic>?)
              ?.map((msg) => Message.fromJson(msg))
              .toList() // Mesajları JSON'dan oluştur
              .obs ??
          <Message>[].obs, // Null kontrolü ve varsayılan değer
    )..currentMembers.value = ((json['currentMembers'] as List<dynamic>?) ?? [])
        .map((member) => Player.fromJson(member))
        .toList(); // Mevcut üyeleri JSON'dan oluştur
  }

  bool isUserInAnyRoom(Player user) {
    return AppList.groups.any((group) {
      return group.rooms!.any((room) {
        return room.currentMembers.any(
            (currentMember) => currentMember.user.userID == user.user.userID);
      });
    });
  }

  void removeUserFromRooms(Player user) {
    for (var group in AppList.groups) {
      for (var room in group.rooms!) {
        room.currentMembers.removeWhere((currentMember) =>
            currentMember.user.userName == user.user.userName);
      }
    }
  }
}
