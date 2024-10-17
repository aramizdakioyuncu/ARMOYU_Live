import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/modules/webrtc/controllers/socketio_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Groupmember {
  Rx<User> user;
  final String description;
  final int status;
  Rx<Room>? currentRoom;

  Groupmember({
    required this.user,
    required this.description,
    required this.status,
    this.currentRoom,
  });

// JSON'dan Groupmember nesnesi oluşturma
  factory Groupmember.fromJson(Map<String, dynamic> json) {
    return Groupmember(
      user: User.fromJson(json['user']).obs, // User sınıfından dönüştürme
      description: json['description'],
      status: json['status'],
      currentRoom: json['currentRoom'] != null
          ? Room.fromJson(json['currentRoom']).obs // Room dönüşümü
          : null,
    );
  }

  // Groupmember nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(), // User sınıfının toJson metodu olmalı
      'description': description,
      'status': status,
      'currentRoom': currentRoom?.value.toJson(), // Room dönüşümü
    };
  }

  Widget listtile() {
    final socketio = Get.find<SocketioController>();
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(
          user.value.avatar!.minUrl.toString(),
        ),
      ),
      onTap: () {
        socketio.callUser(user.value);
      },
      title: Text(
        user.value.displayname.toString(),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        currentRoom == null ? description : currentRoom!.value.name.toString(),
        // description,
        style: const TextStyle(
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
