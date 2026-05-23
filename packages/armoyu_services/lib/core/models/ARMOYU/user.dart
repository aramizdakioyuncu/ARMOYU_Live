import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class User {
  int? userID;
  String? username;
  String? password;
  String? displayname;
  String? firstname;
  String? lastname;
  String? avatar;
  String? banner;

  User({
    this.userID,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.avatar,
    this.banner,
    this.displayname,
  });
}

class UserInfo {
  int userID;
  String displayname;
  String? username;
  MediaURL avatar;
  String? role;
  UserInfo({
    required this.userID,
    required this.displayname,
    this.username,
    this.role,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'displayname': displayname,
      'username': username,
      'avatar': avatar.toJson(),
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userID: json['userID'],
      displayname: json['displayname'],
      username: json['username'],
      avatar: MediaURL.fromJson(json['avatar']),
    );
  }
}
