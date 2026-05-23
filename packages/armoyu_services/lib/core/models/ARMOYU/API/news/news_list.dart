import 'package:armoyu_services/core/models/ARMOYU/media.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APINewsList {
  List<APINewsDetail> news;
  APINewsList({
    required this.news,
  });

  Map<String, dynamic> toJson() {
    return {
      'news': news.map((player) => player.toJson()).toList(),
    };
  }

  factory APINewsList.fromJson(Map<String, dynamic> json) {
    return APINewsList(
      news: (json['news'] as List<dynamic>)
          .map((player) => APINewsDetail.fromJson(player))
          .toList(),
    );
  }
}

class APINewsDetail {
  final int newsID;
  final String newsURL;
  final UserInfo newsOwner;
  final String title;
  final String? content;
  final String summary;
  final Media media;
  final String date;
  final String category;
  final int views;

  APINewsDetail({
    required this.newsID,
    required this.newsURL,
    required this.newsOwner,
    required this.title,
    this.content,
    required this.summary,
    required this.media,
    required this.date,
    required this.category,
    required this.views,
  });

  Map<String, dynamic> toJson() {
    return {
      'newsID': newsID,
      'newsURL': newsURL,
      'newsOwner': newsOwner.toJson(),
      'title': title,
      'content': content,
      'summary': summary,
      'media': media.toJson(),
      'date': date,
      'category': category,
      'views': views,
    };
  }

  factory APINewsDetail.fromJson(Map<String, dynamic> json) {
    return APINewsDetail(
      newsID: json['newsID'],
      newsURL: json['newsURL'],
      newsOwner: UserInfo.fromJson(json['newsOwner']),
      title: json['title'],
      content: json['content'],
      summary: json['summary'],
      media: Media.fromJson(json['media']),
      date: json['date'],
      category: json['category'],
      views: json['views'],
    );
  }
}
