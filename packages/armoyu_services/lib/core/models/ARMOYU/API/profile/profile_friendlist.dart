import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIProfileFriendlist {
  int playerID;
  MediaURL avatar;
  String playerLink;
  String displayName;
  String username;
  int level;
  int status;
  String lastLogin;
  int friendshipStatus;

  APIProfileFriendlist({
    required this.playerID,
    required this.avatar,
    required this.playerLink,
    required this.displayName,
    required this.username,
    required this.level,
    required this.status,
    required this.lastLogin,
    required this.friendshipStatus,
  });

  // JSON'dan nesne oluşturma
  factory APIProfileFriendlist.fromJson(Map<String, dynamic> json) {
    return APIProfileFriendlist(
      playerID: json['playerID'],
      avatar: MediaURL.fromJson(json['avatar']),
      playerLink: json['playerLink'],
      displayName: json['displayName'],
      username: json['username'],
      level: json['level'],
      status: json['status'],
      lastLogin: json['lastLogin'],
      friendshipStatus: json['friendshipStatus'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'playerID': playerID,
      'avatar': avatar.toJson(),
      'playerLink': playerLink,
      'displayName': displayName,
      'username': username,
      'level': level,
      'status': status,
      'lastLogin': lastLogin,
      'friendshipStatus': friendshipStatus,
    };
  }
}
