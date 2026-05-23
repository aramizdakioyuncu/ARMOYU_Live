import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIStoryViewlist {
  int goruntuleyenId;
  String goruntuleyenAdSoyad;
  String goruntuleyenKullaniciAd;
  MediaURL goruntuleyenAvatar;
  int goruntuleyenBegenme;

  APIStoryViewlist({
    required this.goruntuleyenId,
    required this.goruntuleyenAdSoyad,
    required this.goruntuleyenKullaniciAd,
    required this.goruntuleyenAvatar,
    required this.goruntuleyenBegenme,
  });

  // JSON'dan nesne oluşturma
  factory APIStoryViewlist.fromJson(Map<String, dynamic> json) {
    return APIStoryViewlist(
      goruntuleyenId: json['hgoruntuleyen_ID'],
      goruntuleyenAdSoyad: json['hgoruntuleyen_adsoyad'],
      goruntuleyenKullaniciAd: json['hgoruntuleyen_kullaniciad'],
      goruntuleyenAvatar: MediaURL.fromJson(json['hgoruntuleyen_avatar']),
      goruntuleyenBegenme: json['hgoruntuleyen_begenme'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'hgoruntuleyen_ID': goruntuleyenId,
      'hgoruntuleyen_adsoyad': goruntuleyenAdSoyad,
      'hgoruntuleyen_kullaniciad': goruntuleyenKullaniciAd,
      'hgoruntuleyen_avatar': goruntuleyenAvatar.toJson(),
      'hgoruntuleyen_begenme': goruntuleyenBegenme,
    };
  }
}
