import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:get/get.dart';

class Group {
  final int groupID;
  final String name;
  final String? description;
  final Media logo;
  RxList<Groupmember>? groupmembers;
  RxList<Room>? rooms;

  Group({
    required this.groupID,
    required this.name,
    required this.description,
    required this.logo,
    this.groupmembers,
    this.rooms,
  });

  // JSON'dan Group nesnesi oluşturma
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['groupID'],
      name: json['name'],
      description: json['description'],
      logo: Media.fromJson(
          json['logo']), // Media sınıfınızın da fromJson metodu olmalı
      groupmembers: (json['groupmembers'] as List<dynamic>?)
          ?.map((member) => Groupmember.fromJson(member))
          .toList()
          .obs, // RxList dönüşümü
      rooms: (json['rooms'] as List<dynamic>?)
          ?.map((room) => Room.fromJson(room))
          .toList()
          .obs,
    );
  }

  // Group nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'name': name,
      'description': description,
      'logo': logo.toJson(), // Media sınıfınızın toJson metodu olmalı
      'groupmembers': groupmembers?.map((member) => member.toJson()).toList(),
      'rooms': rooms?.map((room) => room.toJson()).toList(),
    };
  }
}
