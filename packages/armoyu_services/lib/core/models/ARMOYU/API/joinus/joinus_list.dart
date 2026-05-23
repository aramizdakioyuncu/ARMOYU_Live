import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIJoinusList {
  int applicationId;
  ApplicationUser applicationUser;
  ApplicationPosition applicationPosition;
  String applicationDate;
  int applicationStatus;

  APIJoinusList({
    required this.applicationId,
    required this.applicationUser,
    required this.applicationPosition,
    required this.applicationDate,
    required this.applicationStatus,
  });

  factory APIJoinusList.fromJson(Map<String, dynamic> json) {
    return APIJoinusList(
      applicationId: json['application_ID'],
      applicationUser: ApplicationUser.fromJson(json['sapplication_user']),
      applicationPosition:
          ApplicationPosition.fromJson(json['sapplication_position']),
      applicationDate: json['sapplication_date'],
      applicationStatus: json['sapplication_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_ID': applicationId,
      'sapplication_user': applicationUser.toJson(),
      'sapplication_position': applicationPosition.toJson(),
      'sapplication_date': applicationDate,
      'sapplication_status': applicationStatus,
    };
  }
}

class ApplicationUser {
  int playerId;
  String playerDisplayName;
  MediaURL playerAvatar;

  ApplicationUser({
    required this.playerId,
    required this.playerDisplayName,
    required this.playerAvatar,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      playerId: json['player_ID'],
      playerDisplayName: json['player_displayname'],
      playerAvatar: MediaURL.fromJson(json['player_avatar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_ID': playerId,
      'player_displayname': playerDisplayName,
      'player_avatar': playerAvatar.toJson(),
    };
  }
}

class ApplicationPosition {
  int positionId;
  String positionDepartment;
  String positionName;

  ApplicationPosition({
    required this.positionId,
    required this.positionDepartment,
    required this.positionName,
  });

  factory ApplicationPosition.fromJson(Map<String, dynamic> json) {
    return ApplicationPosition(
      positionId: json['position_ID'],
      positionDepartment: json['position_department'],
      positionName: json['position_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position_ID': positionId,
      'position_department': positionDepartment,
      'position_name': positionName,
    };
  }
}
