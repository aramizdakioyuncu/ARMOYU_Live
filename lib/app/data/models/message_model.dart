import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Message {
  final Rx<User> user; // User'ı reaktif hale getir
  final RxString message; // Mesajı reaktif hale getir
  final RxList<Media>? media; // Medya listesini opsiyonel reaktif hale getir
  final Rx<DateTime> datetime; // Tarihi reaktif hale getir
  final Rx<Room> room; // Tarihi reaktif hale getir

  Message({
    required User user,
    required String message,
    List<Media>? media, // Medya opsiyonel
    required DateTime datetime,
    required Room room,
  })  : user = Rx(user),
        message = RxString(message),
        media = media != null ? RxList<Media>(media) : null, // Null kontrolü
        datetime = Rx<DateTime>(datetime),
        room = Rx<Room>(room);

  // Message nesnesini JSON'a dönüştürmek için bir yöntem
  Map<String, dynamic> toJson() {
    return {
      'user': user.value.toJson(), // User nesnesini JSON'a dönüştür
      'message': message.value,
      'media': media
          ?.map((m) => m.toJson())
          .toList(), // Media listesini JSON'a dönüştür, null kontrolü
      'datetime': datetime.value
          .toIso8601String(), // DateTime'ı ISO 8601 formatında string'e dönüştür
      'room': room.value.toJson(), // User nesnesini JSON'a dönüştür
    };
  }

  // JSON'dan Message nesnesi oluşturmak için bir yöntem
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      user: User.fromJson(json['user']), // User nesnesini JSON'dan oluştur
      message: json['message'],
      media: json['media'] != null
          ? List<Media>.from(json['media'].map((m) => Media.fromJson(m)))
          : null, // Media listesini JSON'dan oluştur
      datetime: DateTime.parse(
          json['datetime']), // ISO 8601 string'ini DateTime'a çevir
      room: Room.fromJson(json['room']),
    );
  }

  Widget chatfield() {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(
          user.value.avatar!.minUrl.toString(),
        ),
      ),
      title: Text(
        user.value.displayname.toString(),
      ),
      subtitle: Column(
        children: [
          Align(alignment: Alignment.bottomLeft, child: Text(message.value)),
          media == null
              ? Container()
              : Container(
                  color: Colors.black38,
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: media == null ? 0 : media!.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl:
                            "https://aramizdakioyuncu.com/galeri/profilresimleri/11357profilresimufaklik1668362839.webp",
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
