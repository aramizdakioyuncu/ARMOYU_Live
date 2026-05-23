import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIGroupMedia {
  Media media;
  String category;
  String date;
  String type;
  APIGroupMedia({
    required this.media,
    required this.category,
    required this.date,
    required this.type,
  });

  // JSON'dan APIGroupMedia nesnesi oluşturma
  factory APIGroupMedia.fromJson(Map<String, dynamic> json) {
    return APIGroupMedia(
      media: Media.fromJson(json['media']),
      category: json['category'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
    );
  }

  // APIGroupMedia nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'media':
          media.toJson(), // Media sınıfının toJson metodunun olması gerekir
      'category': category,
      'date': date,
      'type': type,
    };
  }
}
