import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIControlpanelUserslist {
  final int id;
  final String kullaniciNo;
  final String userLogin;
  final String displayName;
  final MediaURL avatar;
  final String yetki;
  final String kayitEden;
  final int yas;
  final String sonGiris;
  final int kalanHak;
  final bool problemli;

  APIControlpanelUserslist({
    required this.id,
    required this.kullaniciNo,
    required this.userLogin,
    required this.displayName,
    required this.avatar,
    required this.yetki,
    required this.kayitEden,
    required this.yas,
    required this.sonGiris,
    required this.kalanHak,
    required this.problemli,
  });

  factory APIControlpanelUserslist.fromJson(Map<String, dynamic> json) {
    return APIControlpanelUserslist(
      id: json['#'] ?? 0,
      kullaniciNo: json['kullanici_no'] ?? '',
      userLogin: json['user_login'] ?? '',
      displayName: json['display_name'] ?? '',
      avatar: MediaURL.fromJson(json['avatar']),
      yetki: json['yetki'] ?? '',
      kayitEden: json['kayit_eden'] ?? '',
      yas: json['yas'] ?? 0,
      sonGiris: json['son_giris'] ?? '',
      kalanHak: json['kalan_hak'] ?? 0,
      problemli: json['problemli'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '#': id,
      'kullanici_no': kullaniciNo,
      'user_login': userLogin,
      'display_name': displayName,
      'avatar': avatar.toJson(),
      'yetki': yetki,
      'kayit_eden': kayitEden,
      'yas': yas,
      'son_giris': sonGiris,
      'kalan_hak': kalanHak,
      'problemli': problemli,
    };
  }
}
