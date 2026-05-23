import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIInvitecode {
  final int userID;
  final String displayname;
  final MediaURL avatar;
  APIInvitecode({
    required this.userID,
    required this.displayname,
    required this.avatar,
  });

  // JSON'dan APIInvitecode nesnesi oluşturma
  factory APIInvitecode.fromJson(Map<String, dynamic> json) {
    return APIInvitecode(
      userID: json['userID'],
      displayname: json['displayname'],
      avatar: MediaURL.fromJson(json['avatar']),
    );
  }

  // APIInvitecode nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'displayname': displayname,
      'avatar': avatar.toJson(),
    };
  }
}
