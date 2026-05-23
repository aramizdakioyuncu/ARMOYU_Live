import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIChatList {
  int kullID;
  String adSoyad;
  String? kullAdi;
  int bildirim;
  String sonGiris;
  String? sonMesaj;
  APIChat sohbetTuru;
  Media chatImage;

  APIChatList({
    required this.kullID,
    required this.adSoyad,
    this.kullAdi,
    required this.bildirim,
    required this.sonGiris,
    required this.sonMesaj,
    required this.sohbetTuru,
    required this.chatImage,
  });

  factory APIChatList.fromJson(Map<String, dynamic> json) {
    return APIChatList(
      kullID: json['kullid'],
      adSoyad: json['adisoyadi'],
      kullAdi: json['kulladi'],
      bildirim: json['bildirim'],
      sonGiris: json['songiris'],
      sonMesaj: json['sonmesaj'],
      sohbetTuru: APIChat.values.firstWhere(
        (e) => e.name == json['sohbetturu'],
        orElse: () => APIChat.ozel, // Varsayılan değer (isteğe bağlı)
      ),
      chatImage: Media.fromJson(json['chatImage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kullid': kullID,
      'adisoyadi': adSoyad,
      'kulladi': kullAdi,
      'bildirim': bildirim,
      'songiris': sonGiris,
      'sonmesaj': sonMesaj,
      'sohbetturu': sohbetTuru.name,
      'chatImage': chatImage.toJson(),
    };
  }
}
