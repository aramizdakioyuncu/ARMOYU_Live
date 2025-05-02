import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';

import 'package:get/get.dart';

class Groupmember {
  Rx<Player> user;
  final String description;
  final int status;
  final Rxn<Room> currentRoom = Rxn<Room>();

  Groupmember({
    required this.user,
    required this.description,
    required this.status,
    Room? currentRoom,
  }) {
    if (currentRoom != null) {
      this.currentRoom.value = currentRoom;
    }
  }

// JSON'dan Groupmember nesnesi oluşturma
  factory Groupmember.fromJson(Map<String, dynamic> json) {
    return Groupmember(
      user: Player.fromJson(json['user']).obs, // User sınıfından dönüştürme
      description: json['description'],
      status: json['status'],
      currentRoom: json['currentRoom'] != null
          ? Room.fromJson(json['currentRoom']) // Room dönüşümü
          : null,
    );
  }

  // Groupmember nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(), // User sınıfının toJson metodu olmalı
      'description': description,
      'status': status,
      'currentRoom': currentRoom.value?.toJson(), // Room dönüşümü
    };
  }
}
