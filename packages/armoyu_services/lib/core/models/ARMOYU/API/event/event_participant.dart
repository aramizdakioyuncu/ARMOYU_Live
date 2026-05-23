import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIEventParticipant {
  List<APIEventparticipantGroups> groups;
  List<UserInfo> players;

  APIEventParticipant({
    required this.groups,
    required this.players,
  });
}

class APIEventparticipantGroups {
  int groupID;
  String groupName;
  String groupShortname;
  String groupLogo;
  String groupBanner;
  String groupURL;
  List<UserInfo> groupPlayers;

  APIEventparticipantGroups({
    required this.groupID,
    required this.groupName,
    required this.groupShortname,
    required this.groupLogo,
    required this.groupBanner,
    required this.groupURL,
    required this.groupPlayers,
  });

  // JSON'dan APIEventparticipantGroups nesnesi oluşturma
  factory APIEventparticipantGroups.fromJson(Map<String, dynamic> json) {
    return APIEventparticipantGroups(
      groupID: json['group_ID'],
      groupName: json['group_name'],
      groupShortname: json['group_shortname'],
      groupLogo: json['group_logo'],
      groupBanner: json['group_banner'],
      groupURL: json['group_URL'],
      groupPlayers: (json['groupPlayers'] as List<dynamic>)
          .map((player) => UserInfo.fromJson(player))
          .toList(),
    );
  }

  // APIEventparticipantGroups nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'group_ID': groupID,
      'group_name': groupName,
      'group_shortname': groupShortname,
      'group_logo': groupLogo,
      'group_banner': groupBanner,
      'group_URL': groupURL,
      'group_players': groupPlayers.map((player) => player.toJson()).toList(),
    };
  }
}
