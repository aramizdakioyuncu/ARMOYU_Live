import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIMySchoolList {
  final int schoolID;
  final String schoolName;
  final String schoolURL;
  final int schoolUserCount;
  final Media schoolLogo;
  final Media schoolBanner;

  APIMySchoolList({
    required this.schoolID,
    required this.schoolName,
    required this.schoolURL,
    required this.schoolUserCount,
    required this.schoolLogo,
    required this.schoolBanner,
  });

  factory APIMySchoolList.fromJson(Map<String, dynamic> json) {
    return APIMySchoolList(
      schoolID: json['school_ID'],
      schoolName: json['school_name'],
      schoolURL: json['school_URL'],
      schoolUserCount: json['school_usercount'],
      schoolLogo: Media.fromJson(json['school_logo']),
      schoolBanner: Media.fromJson(json['school_banner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_ID': schoolID,
      'school_name': schoolName,
      'school_URL': schoolURL,
      'school_usercount': schoolUserCount,
      'school_logo': schoolLogo.toJson(),
      'school_banner': schoolBanner.toJson(),
    };
  }
}
