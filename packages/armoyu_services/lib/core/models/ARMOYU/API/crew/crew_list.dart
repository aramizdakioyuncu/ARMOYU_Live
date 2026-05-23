import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APICrewList {
  final int id;
  final int playerID;
  final String username;
  final String displayName;
  final MediaURL avatar;
  final SocialAccounts socialAccounts;
  final UserRole role;

  APICrewList({
    required this.id,
    required this.playerID,
    required this.displayName,
    required this.username,
    required this.avatar,
    required this.socialAccounts,
    required this.role,
  });

  /// JSON'dan `TeamMember` nesnesine dönüştürme
  factory APICrewList.fromJson(Map<String, dynamic> json) {
    return APICrewList(
      id: json['#'],
      playerID: json['player_ID'],
      username: json['player_username'],
      displayName: json['player_displayname'],
      avatar: MediaURL.fromJson(json['player_avatar']),
      socialAccounts: SocialAccounts.fromJson(json['player_social']),
      role: UserRole.fromJson(json['player_role']),
    );
  }

  /// `TeamMember` nesnesini JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      '#': id,
      'player_ID': playerID,
      'player_username': username,
      'player_displayname': displayName,
      'player_avatar': avatar.toJson(),
      'player_social': socialAccounts.toJson(),
      'player_role': role.toJson(),
    };
  }
}
