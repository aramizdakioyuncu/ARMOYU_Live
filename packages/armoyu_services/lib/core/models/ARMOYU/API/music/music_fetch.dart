import 'package:armoyu_services/core/models/ARMOYU/media.dart';

enum MusicCategory {
  localStorage,
  webStorage,
  allStorage,
}

class APIMusicFetch {
  final int musicID;
  final MusicCategory category;
  final String name;
  final String? ownername;
  final String musicURL;
  final bool ismyfav;
  final int listeningcount;
  final Media musicImage;

  APIMusicFetch({
    required this.musicID,
    required this.category,
    required this.name,
    required this.ownername,
    required this.musicURL,
    required this.ismyfav,
    required this.listeningcount,
    required this.musicImage,
  });

  // JSON'dan APIMediaFetch nesnesi oluşturma
  factory APIMusicFetch.fromJson(Map<String, dynamic> json) {
    return APIMusicFetch(
      musicID: json['musicID'],
      category:
          MusicCategory.values.firstWhere((e) => e.name == json['category']),
      name: json['name'],
      ownername: json['ownername'],
      musicURL: json['musicURL'],
      ismyfav: json['ismyfav'],
      listeningcount: json['listeningcount'],
      musicImage: Media.fromJson(json['musicImage']),
    );
  }

  // APIMediaFetch nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'musicID': musicID,
      'category': category.name,
      'name': name,
      'ownername': ownername,
      'musicURL': musicURL,
      'ismyfav': ismyfav,
      'listeningcount': listeningcount,
      'musicImage': musicImage.toJson(),
    };
  }
}
