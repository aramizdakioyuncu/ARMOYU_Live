import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APISchoolDetail {
  int schoolID;
  String schoolName;
  String schoolShortName;
  String schoolURL;
  String schoolAbout;
  Media schoolLogo;
  Media schoolBanner;

  APISchoolDetail({
    required this.schoolID,
    required this.schoolName,
    required this.schoolShortName,
    required this.schoolURL,
    required this.schoolAbout,
    required this.schoolLogo,
    required this.schoolBanner,
  });

  // JSON'dan nesne oluşturma
  factory APISchoolDetail.fromJson(Map<String, dynamic> json) {
    return APISchoolDetail(
      schoolID: json['schoolID'],
      schoolName: json['schoolName'],
      schoolShortName: json['schoolShortName'],
      schoolURL: json['schoolURL'],
      schoolAbout: json['schoolAbout'],
      schoolLogo: Media.fromJson(json['schoolLogo']),
      schoolBanner: Media.fromJson(json['schoolBanner']),
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'schoolID': schoolID,
      'schoolName': schoolName,
      'schoolShortName': schoolShortName,
      'schoolURL': schoolURL,
      'schoolAbout': schoolAbout,
      'schoolLogo': schoolLogo.toJson(),
      'schoolBanner': schoolBanner.toJson(),
    };
  }
}
