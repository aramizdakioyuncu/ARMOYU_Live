import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIStoryList {
  int oyuncuId;
  String oyuncuAdSoyad;
  String oyuncuKadi;
  MediaURL oyuncuAvatar;
  int hikayeSayisi;
  List<StoryContent> hikayeIcerik;

  APIStoryList({
    required this.oyuncuId,
    required this.oyuncuAdSoyad,
    required this.oyuncuKadi,
    required this.oyuncuAvatar,
    required this.hikayeSayisi,
    required this.hikayeIcerik,
  });

  // JSON'dan nesne oluşturma
  factory APIStoryList.fromJson(Map<String, dynamic> json) {
    return APIStoryList(
      oyuncuId: json['oyuncu_ID'],
      oyuncuAdSoyad: json['oyuncu_adsoyad'],
      oyuncuKadi: json['oyuncu_kadi'],
      oyuncuAvatar: MediaURL.fromJson(json['oyuncu_avatar']),
      hikayeSayisi: json['hikaye_sayisi'],
      hikayeIcerik: (json['hikaye_icerik'] as List)
          .map((story) => StoryContent.fromJson(story))
          .toList(),
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'oyuncu_ID': oyuncuId,
      'oyuncu_adsoyad': oyuncuAdSoyad,
      'oyuncu_kadi': oyuncuKadi,
      'oyuncu_avatar': oyuncuAvatar.toJson(),
      'hikaye_sayisi': hikayeSayisi,
      'hikaye_icerik': hikayeIcerik.map((story) => story.toJson()).toList(),
    };
  }
}

class StoryContent {
  int hikayeId;
  int hikayeDurum;
  int hikayeSahip;
  String hikayeZaman;
  int hikayeBenBegeni;
  int hikayeBenGoruntulenme;
  String hikayeMedya;

  StoryContent({
    required this.hikayeId,
    required this.hikayeDurum,
    required this.hikayeSahip,
    required this.hikayeZaman,
    required this.hikayeBenBegeni,
    required this.hikayeBenGoruntulenme,
    required this.hikayeMedya,
  });

  // JSON'dan nesne oluşturma
  factory StoryContent.fromJson(Map<String, dynamic> json) {
    return StoryContent(
      hikayeId: json['hikaye_ID'],
      hikayeDurum: json['hikaye_durum'],
      hikayeSahip: json['hikaye_sahip'],
      hikayeZaman: json['hikaye_zaman'],
      hikayeBenBegeni: json['hikaye_benbegeni'],
      hikayeBenGoruntulenme: json['hikaye_bengoruntulenme'],
      hikayeMedya: json['hikaye_medya'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'hikaye_ID': hikayeId,
      'hikaye_durum': hikayeDurum,
      'hikaye_sahip': hikayeSahip,
      'hikaye_zaman': hikayeZaman,
      'hikaye_benbegeni': hikayeBenBegeni,
      'hikaye_bengoruntulenme': hikayeBenGoruntulenme,
      'hikaye_medya': hikayeMedya,
    };
  }
}
