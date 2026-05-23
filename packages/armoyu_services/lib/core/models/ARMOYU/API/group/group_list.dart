import 'package:armoyu_services/core/models/ARMOYU/media.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIGroupList {
  final List<APIGroupListDetail> groups;

  APIGroupList({
    required this.groups,
  });

  Map<String, dynamic> toJson() {
    return {
      'groups': groups.map((player) => player.toJson()).toList(),
    };
  }

  factory APIGroupList.fromJson(Map<String, dynamic> json) {
    return APIGroupList(
      groups: (json['groups'] as List<dynamic>)
          .map((player) => APIGroupListDetail.fromJson(player))
          .toList(),
    );
  }
}

class APIGroupListDetail {
  final int groupID;
  final String name;
  final String shortname;
  final String registerdate;
  final int membercount;
  final String? category;
  final String? categorydetail;

  final String? defaultgame;

  final bool joinable;
  final String? description;
  final GroupSocial socail;
  final String groupURL;
  final UserInfo groupOwner;
  final Media logo;
  final Media banner;

  APIGroupListDetail({
    required this.groupID,
    required this.name,
    required this.shortname,
    required this.registerdate,
    required this.membercount,
    required this.category,
    required this.categorydetail,
    required this.defaultgame,
    required this.joinable,
    this.description,
    required this.socail,
    required this.groupURL,
    required this.groupOwner,
    required this.logo,
    required this.banner,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'name': name,
      'shortname': shortname,
      'registerdate': registerdate,
      'membercount': membercount,
      'category': category,
      'categorydetail': categorydetail,
      'defaultgame': defaultgame,
      'joinable': joinable,
      'description': description,
      'socail': socail.toJson(),
      'groupURL': groupURL,
      'groupOwner': groupOwner.toJson(),
      'logo': logo.toJson(),
      'banner': banner.toJson(),
    };
  }

  factory APIGroupListDetail.fromJson(Map<String, dynamic> json) {
    return APIGroupListDetail(
      groupID: json['groupID'],
      name: json['name'],
      shortname: json['shortname'],
      registerdate: json['registerdate'],
      membercount: json['membercount'],
      category: json['category'],
      categorydetail: json['categorydetail'],
      defaultgame: json['defaultgame'],
      joinable: (json['joinable']),
      description: json['description'],
      socail: GroupSocial.fromJson(json['socail']),
      groupURL: json['groupURL'],
      groupOwner: UserInfo.fromJson(json['groupOwner']),
      logo: Media.fromJson(json['logo']),
      banner: Media.fromJson(json['banner']),
    );
  }
}

class GroupSocial {
  String? website;
  String? discord;

  GroupSocial({
    this.website,
    this.discord,
  });

  Map<String, dynamic> toJson() {
    return {
      'website': website,
      'discord': discord,
    };
  }

  factory GroupSocial.fromJson(Map<String, dynamic> json) {
    return GroupSocial(
      website: json['website'],
      discord: json['discord'],
    );
  }
}
