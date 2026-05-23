import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIStationList {
  int stationID;
  String stationName;
  String stationUrl;
  String stationType;
  int stationUyeSayisi;
  Media stationLogo;
  Media stationBanner;

  APIStationList({
    required this.stationID,
    required this.stationName,
    required this.stationUrl,
    required this.stationType,
    required this.stationUyeSayisi,
    required this.stationLogo,
    required this.stationBanner,
  });

  // JSON'dan nesne oluşturma
  factory APIStationList.fromJson(Map<String, dynamic> json) {
    return APIStationList(
      stationID: json['station_ID'],
      stationName: json['station_name'],
      stationUrl: json['station_URL'],
      stationType: json['station_type'],
      stationUyeSayisi: json['station_uyesayisi'],
      stationLogo: Media.fromJson(json['station_logo']),
      stationBanner: Media.fromJson(json['station_banner']),
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'station_ID': stationID,
      'station_name': stationName,
      'station_URL': stationUrl,
      'station_type': stationType,
      'station_uyesayisi': stationUyeSayisi,
      'station_logo': stationLogo.toJson(),
      'station_banner': stationBanner.toJson(),
    };
  }
}
