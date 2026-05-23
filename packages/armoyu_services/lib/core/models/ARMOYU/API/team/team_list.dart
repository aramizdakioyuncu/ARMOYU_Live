import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APITeamList {
  int teamId;
  String teamName;
  MediaURL teamLogo;

  APITeamList({
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
  });

  factory APITeamList.fromJson(Map<String, dynamic> json) {
    return APITeamList(
      teamId: json['takim_ID'],
      teamName: json['takim_adi'],
      teamLogo: MediaURL.fromJson(json['takim_logo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'takim_ID': teamId,
      'takim_adi': teamName,
      'takim_logo': teamLogo.toJson(),
    };
  }
}
