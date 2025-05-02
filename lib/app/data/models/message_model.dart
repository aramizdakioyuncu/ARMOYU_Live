import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:get/get.dart';

class Message {
  int id; // User'ı reaktif hale getir
  final Rx<Player> user; // User'ı reaktif hale getir
  final RxString message; // Mesajı reaktif hale getir
  final RxList<Media>? media; // Medya listesini opsiyonel reaktif hale getir
  final Rx<String> datetime; // Tarihi reaktif hale getir
  final Rxn<Room> room; // Tarihi reaktif hale getir

  Message({
    required this.id,
    required Player user,
    required String message,
    List<Media>? media, // Medya opsiyonel
    required String datetime,
    Room? room,
  })  : user = Rx(user),
        message = RxString(message),
        media = media != null ? RxList<Media>(media) : null, // Null kontrolü
        datetime = Rx<String>(datetime),
        room = Rxn<Room>(room);

  // Message nesnesini JSON'a dönüştürmek için bir yöntem
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.value.toJson(), // User nesnesini JSON'a dönüştür
      'message': message.value,
      'media': media
          ?.map((m) => m.toJson())
          .toList(), // Media listesini JSON'a dönüştür, null kontrolü
      'datetime':
          datetime.value, // DateTime'ı ISO 8601 formatında string'e dönüştür
      'room': room.value?.toJson(), // User nesnesini JSON'a dönüştür
    };
  }

  // JSON'dan Message nesnesi oluşturmak için bir yöntem
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      user: Player.fromJson(json['user']), // User nesnesini JSON'dan oluştur
      message: json['message'],
      media: json['media'] != null
          ? List<Media>.from(json['media'].map((m) => Media.fromJson(m)))
          : null, // Media listesini JSON'dan oluştur
      datetime: json['datetime'], // ISO 8601 string'ini DateTime'a çevir
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
    );
  }
}
