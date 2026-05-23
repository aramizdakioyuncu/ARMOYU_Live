import 'package:armoyu_services/core/models/ARMOYU/API/group/group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIGroupDetail {
  int groupID;
  String groupName;
  String groupShortname;
  bool groupJoinStatus;
  String? groupDescription;
  GroupSocial groupSocial;
  String groupURL;
  UserInfo groupOwner;
  MediaURL groupLogo;
  MediaURL groupBanner;

  APIGroupDetail({
    required this.groupID,
    required this.groupName,
    required this.groupShortname,
    required this.groupJoinStatus,
    required this.groupDescription,
    required this.groupSocial,
    required this.groupURL,
    required this.groupOwner,
    required this.groupLogo,
    required this.groupBanner,
  });

  // JSON'dan APIGroupDetail nesnesi oluşturma
  factory APIGroupDetail.fromJson(Map<String, dynamic> json) {
    return APIGroupDetail(
      groupID: json['group_ID'],
      groupName: json['group_name'],
      groupShortname: json['group_shortname'],
      groupJoinStatus: json['group_joinstatus'],
      groupDescription: json['group_description'],
      groupSocial: GroupSocial.fromJson(json['group_social']),
      groupURL: json['group_URL'],
      groupOwner: UserInfo.fromJson(json['group_owner']),
      groupLogo: MediaURL.fromJson(json['group_logo']),
      groupBanner: MediaURL.fromJson(json['group_banner']),
    );
  }

  // APIGroupDetail nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'group_ID': groupID,
      'group_name': groupName,
      'group_shortname': groupShortname,
      'group_joinstatus': groupJoinStatus,
      'group_description': groupDescription,
      'group_social': groupSocial.toJson(),
      'group_URL': groupURL,
      'group_owner': groupOwner.toJson(),
      'group_logo': groupLogo.toJson(),
      'group_banner': groupBanner.toJson(),
    };
  }
}
