import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIMediaFetch {
  final MediaOwner mediaOwner;
  final String mediaDate;
  final String mediaSize;
  final String category;
  final String fotoPaylas;
  final String mediatype;
  final Media media;

  APIMediaFetch({
    required this.mediaOwner,
    required this.mediaDate,
    required this.mediaSize,
    required this.category,
    required this.fotoPaylas,
    required this.mediatype,
    required this.media,
  });

  // JSON'dan APIMediaFetch nesnesi oluşturma
  factory APIMediaFetch.fromJson(Map<String, dynamic> json) {
    return APIMediaFetch(
      mediaOwner: MediaOwner.fromJson(json['mediaOwner']),
      mediaDate: json['mediaDate'],
      mediaSize: json['mediaSize'],
      category: json['category'],
      fotoPaylas: json['fotoPaylas'],
      mediatype: json['mediatype'],
      media: Media.fromJson(json['media']),
    );
  }

  // APIMediaFetch nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'mediaOwner': mediaOwner.toJson(),
      'mediaDate': mediaDate,
      'mediaSize': mediaSize,
      'category': category,
      'fotoPaylas': fotoPaylas,
      'mediatype': mediatype,
      'media': media.toJson(),
    };
  }
}
