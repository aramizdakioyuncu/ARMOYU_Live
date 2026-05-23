import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APISchoolList {
  int schoolID;
  String value;
  String schoolURL;
  MediaURL schoolLogo;
  int memberCount;

  APISchoolList({
    required this.schoolID,
    required this.value,
    required this.schoolURL,
    required this.schoolLogo,
    required this.memberCount,
  });

  // JSON'dan nesne oluşturma
  factory APISchoolList.fromJson(Map<String, dynamic> json) {
    return APISchoolList(
      schoolID: json['schoolID'],
      value: json['value'],
      schoolURL: json['schoolURL'],
      schoolLogo: json['schoolLogo'],
      memberCount: json['memberCount'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'schoolID': schoolID,
      'value': value,
      'schoolURL': schoolURL,
      'schoolLogo': schoolLogo,
      'memberCount': memberCount,
    };
  }
}
