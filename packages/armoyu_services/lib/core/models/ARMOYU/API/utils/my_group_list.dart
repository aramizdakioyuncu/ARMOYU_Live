import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIMyGroupList {
  int groupID;
  String groupName;
  String groupShortName;
  int groupJoinStatus;
  String? groupDescription;
  MyGroupSocial groupSocial;
  String groupURL;
  int groupUserCount;
  Media groupLogo;
  Media groupBanner;
  MyGroupMyRole groupMyRole;

  APIMyGroupList({
    required this.groupID,
    required this.groupName,
    required this.groupShortName,
    required this.groupJoinStatus,
    required this.groupDescription,
    required this.groupSocial,
    required this.groupURL,
    required this.groupUserCount,
    required this.groupLogo,
    required this.groupBanner,
    required this.groupMyRole,
  });

  factory APIMyGroupList.fromJson(Map<String, dynamic> json) {
    return APIMyGroupList(
      groupID: json['group_ID'],
      groupName: json['group_name'],
      groupShortName: json['group_shortname'],
      groupJoinStatus: json['group_joinstatus'],
      groupDescription: json['group_description'],
      groupSocial: MyGroupSocial.fromJson(json['group_social']),
      groupURL: json['group_URL'],
      groupUserCount: json['group_usercount'],
      groupLogo: Media.fromJson(json['group_logo']),
      groupBanner: Media.fromJson(json['group_banner']),
      groupMyRole: MyGroupMyRole.fromJson(json['group_myRole']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_ID': groupID,
      'group_name': groupName,
      'group_shortname': groupShortName,
      'group_joinstatus': groupJoinStatus,
      'group_description': groupDescription,
      'group_social': groupSocial.toJson(),
      'group_URL': groupURL,
      'group_usercount': groupUserCount,
      'group_logo': groupLogo.toJson(),
      'group_banner': groupBanner.toJson(),
      'group_myRole': groupMyRole.toJson(),
    };
  }
}

class MyGroupSocial {
  String? groupWebsite;
  String? groupDiscord;

  MyGroupSocial({
    required this.groupWebsite,
    required this.groupDiscord,
  });

  factory MyGroupSocial.fromJson(Map<String, dynamic> json) {
    return MyGroupSocial(
      groupWebsite: json['group_website'],
      groupDiscord: json['group_discord'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_website': groupWebsite,
      'group_discord': groupDiscord,
    };
  }
}

class MyGroupMyRole {
  int owner;
  int userInvite;
  int userKick;
  int userRole;
  int groupSettings;
  int groupFiles;
  int groupEvents;
  int groupRole;
  int groupSurvey;

  MyGroupMyRole({
    required this.owner,
    required this.userInvite,
    required this.userKick,
    required this.userRole,
    required this.groupSettings,
    required this.groupFiles,
    required this.groupEvents,
    required this.groupRole,
    required this.groupSurvey,
  });

  factory MyGroupMyRole.fromJson(Map<String, dynamic> json) {
    return MyGroupMyRole(
      owner: json['owner'],
      userInvite: json['user_invite'],
      userKick: json['user_kick'],
      userRole: json['user_role'],
      groupSettings: json['group_settings'],
      groupFiles: json['group_files'],
      groupEvents: json['group_events'],
      groupRole: json['group_role'],
      groupSurvey: json['group_survey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'user_invite': userInvite,
      'user_kick': userKick,
      'user_role': userRole,
      'group_settings': groupSettings,
      'group_files': groupFiles,
      'group_events': groupEvents,
      'group_role': groupRole,
      'group_survey': groupSurvey,
    };
  }
}
