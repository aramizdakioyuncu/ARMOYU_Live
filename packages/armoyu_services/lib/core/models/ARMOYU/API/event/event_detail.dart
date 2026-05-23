import 'package:armoyu_services/core/models/ARMOYU/API/event/event.dart';

class APIEventDetail {
  APIEvent event;
  List<dynamic> dlc; // DLC listesi, içeriğine göre tipi değişebilir
  List<dynamic> files; // Dosya listesi, içeriğine göre tipi değişebilir
  List<dynamic> detail; // Detay listesi, içeriğine göre tipi değişebilir

  APIEventDetail({
    required this.event,
    required this.dlc,
    required this.files,
    required this.detail,
  });

  // JSON'dan APIEventDetail nesnesi oluşturma
  factory APIEventDetail.fromJson(Map<String, dynamic> json) {
    return APIEventDetail(
      event: json['event'],
      dlc: json['dlc'] ?? [],
      files: json['files'] ?? [],
      detail: json['detail'] ?? [],
    );
  }

  // APIEventDetail nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'dlc': dlc,
      'files': files,
      'detail': detail,
    };
  }
}
