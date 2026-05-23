import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIProfileInvitelist {
  int userID;
  MediaURL avatar;
  String displayName;
  String username;
  bool isVerified;
  String verificationTime;
  String membershipDuration;

  APIProfileInvitelist({
    required this.userID,
    required this.avatar,
    required this.displayName,
    required this.username,
    required this.isVerified,
    required this.verificationTime,
    required this.membershipDuration,
  });

  // JSON'dan nesne oluşturma
  factory APIProfileInvitelist.fromJson(Map<String, dynamic> json) {
    return APIProfileInvitelist(
      userID: json['userID'],
      avatar: MediaURL.fromJson(json['avatar']),
      displayName: json['displayName'],
      username: json['username'],
      isVerified: json['isVerified'],
      verificationTime: json['verificationTime'],
      membershipDuration: json['membershipDuration'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'avatar': avatar.toJson(),
      'displayName': displayName,
      'username': username,
      'isVerified': isVerified,
      'verificationTime': verificationTime,
      'membershipDuration': membershipDuration,
    };
  }
}
