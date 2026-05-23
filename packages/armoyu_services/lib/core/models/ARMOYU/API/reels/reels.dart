import 'package:armoyu_services/core/models/ARMOYU/media.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIReel {
  final int reelsID;
  final UserInfo owner;
  final String description;
  final DateTime date;
  final Media media;
  final int likeCount;
  final int commentCount;
  final int status;

  APIReel({
    required this.reelsID,
    required this.owner,
    required this.description,
    required this.date,
    required this.media,
    this.likeCount = 0,
    this.commentCount = 0,
    this.status = 1,
  });

  factory APIReel.fromJson(Map<String, dynamic> json) {
    return APIReel(
      reelsID: json['sreels_ID'],
      owner: UserInfo.fromJson(json['sreels_owner']),
      description: json['sreels_description'],
      date: DateTime.parse(json['sreels_date']),
      media: Media.fromJson(json['sreels_media']),
      likeCount: json['sreels_likecount'] ?? 0,
      commentCount: json['sreels_commentcount'] ?? 0,
      status: json['sreels_status'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sreels_ID': reelsID,
      'sreels_owner': owner.toJson(),
      'sreels_description': description,
      'sreels_date': date.toIso8601String(),
      'sreels_media': media.toJson(),
      'sreels_likecount': likeCount,
      'sreels_commentcount': commentCount,
      'sreels_status': status,
    };
  }
}
