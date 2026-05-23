import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIPostList {
  final int postID;
  String posttype;
  String postdevice;
  PostOwner postOwner;
  String content;
  String? location;
  String date;
  String datecounting;
  String? editdate;
  List<APIPostLiker>? firstlikers;
  int likeCount;
  int commentCount;
  int repostCount;
  int reportCount;
  int didilikeit;
  int didicommentit;
  int didirepostit;
  int didireportit;
  List<Media>? media;
  List<APIPostComments>? firstcomments;

  APIPostList({
    required this.postID,
    required this.posttype,
    required this.postdevice,
    required this.postOwner,
    required this.content,
    required this.location,
    required this.date,
    required this.datecounting,
    required this.editdate,
    this.firstlikers,
    required this.likeCount,
    required this.commentCount,
    required this.repostCount,
    required this.reportCount,
    required this.didilikeit,
    required this.didicommentit,
    required this.didirepostit,
    required this.didireportit,
    this.media,
    this.firstcomments,
  });

  factory APIPostList.fromJson(Map<String, dynamic> json) {
    return APIPostList(
      postID: json['postID'],
      posttype: json['posttype'],
      postdevice: json['postdevice'],
      postOwner: PostOwner.fromJson(json['postOwner']),
      content: json['content'],
      location: json['location'],
      date: json['date'],
      datecounting: json['datecounting'],
      editdate: json['editdate'],
      firstlikers: json['firstlikers'] == null
          ? null
          : (json['firstlikers'] as List<dynamic>)
              .map((likers) => APIPostLiker.fromJson(likers))
              .toList(),
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      repostCount: json['repostCount'],
      reportCount: json['reportCount'],
      didilikeit: json['didilikeit'],
      didicommentit: json['didicommentit'],
      didirepostit: json['didirepostit'],
      didireportit: json['didireportit'],
      media: json['media'],
      firstcomments: json['firstcomments'] == null
          ? null
          : (json['firstcomments'] as List<dynamic>)
              .map((likers) => APIPostComments.fromJson(likers))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postID': postID,
      'posttype': posttype,
      'postdevice': postdevice,
      'postOwner': postOwner.toJson(),
      'content': content,
      'location': location,
      'date': date,
      'datecounting': datecounting,
      'editdate': editdate,
      'firstlikers': firstlikers?.map((e) => e.toJson()).toList(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'repostCount': repostCount,
      'reportCount': reportCount,
      'didilikeit': didilikeit,
      'didicommentit': didicommentit,
      'didirepostit': didirepostit,
      'didireportit': didireportit,
      'media': media,
      'firstcomments': firstcomments?.map((e) => e.toJson()).toList(),
    };
  }
}

class PostOwner {
  int ownerID;
  String displayName;
  String username;
  MediaURL avatar;
  MediaURL banner;
  String? job;
  String? jobURL;

  PostOwner({
    required this.ownerID,
    required this.displayName,
    required this.username,
    required this.avatar,
    required this.banner,
    required this.job,
    required this.jobURL,
  });

  factory PostOwner.fromJson(Map<String, dynamic> json) {
    return PostOwner(
      ownerID: json['ownerID'],
      displayName: json['displayName'],
      username: json['username'],
      avatar: MediaURL.fromJson(json['avatar']),
      banner: MediaURL.fromJson(json['banner']),
      job: json['job'],
      jobURL: json['jobURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerID': ownerID,
      'displayName': displayName,
      'username': username,
      'avatar': avatar.toJson(),
      'banner': banner.toJson(),
      'job': job,
      'jobURL': jobURL,
    };
  }
}

class APIPostLiker {
  int postlikeID;
  int likerID;
  String likerdisplayname;
  String likerusername;
  MediaURL likeravatar;
  String likerURL;
  String likedate;

  APIPostLiker({
    required this.postlikeID,
    required this.likerID,
    required this.likerdisplayname,
    required this.likerusername,
    required this.likeravatar,
    required this.likerURL,
    required this.likedate,
  });

  factory APIPostLiker.fromJson(Map<String, dynamic> json) {
    return APIPostLiker(
      postlikeID: json['postlikeID'],
      likerID: json['likerID'],
      likerdisplayname: json['likerdisplayname'],
      likerusername: (json['likerusername']),
      likeravatar: MediaURL.fromJson(json['likeravatar']),
      likerURL: (json['likerURL']),
      likedate: (json['likedate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postlikeID': postlikeID,
      'likerID': likerID,
      'likerdisplayname': likerdisplayname,
      'likerusername': likerusername,
      'likeravatar': likeravatar.toJson(),
      'likerURL': likerURL,
      'likedate': likedate,
    };
  }
}

class APIPostComments {
  int postID;
  int commentID;
  PostCommenter postcommenter;
  String commentContent;
  String commentTime;
  String commentElapsedTime;
  int replyTo;
  int likeCount;
  int reportCount;
  bool isLikedByMe;
  bool isReportedByMe;

  APIPostComments({
    required this.postID,
    required this.commentID,
    required this.postcommenter,
    required this.commentContent,
    required this.commentTime,
    required this.commentElapsedTime,
    required this.replyTo,
    required this.reportCount,
    required this.likeCount,
    required this.isLikedByMe,
    required this.isReportedByMe,
  });

  factory APIPostComments.fromJson(Map<String, dynamic> json) {
    return APIPostComments(
      postID: json['postID'],
      commentID: json['commentID'],
      postcommenter: json['postcommenter'],
      commentContent: json['commentContent'],
      commentTime: json['commentTime'],
      commentElapsedTime: json['commentElapsedTime'],
      replyTo: json['replyTo'],
      reportCount: json['reportCount'],
      likeCount: json['likeCount'],
      isLikedByMe: json['isLikedByMe'],
      isReportedByMe: json['isReportedByMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postID': postID,
      'commentID': commentID,
      'postcommenter': postcommenter.toJson,
      'commentContent': commentContent,
      'commentTime': commentTime,
      'commentElapsedTime': commentElapsedTime,
      'replyTo': replyTo,
      'reportCount': reportCount,
      'likeCount': likeCount,
      'isLikedByMe': isLikedByMe,
      'isReportedByMe': isReportedByMe,
    };
  }
}

class PostCommenter {
  int userID;
  String mention;
  String username;
  String displayname;
  String userURL;
  MediaURL avatar;

  PostCommenter({
    required this.userID,
    required this.mention,
    required this.username,
    required this.displayname,
    required this.userURL,
    required this.avatar,
  });

  // JSON'dan nesne oluşturma
  factory PostCommenter.fromJson(Map<String, dynamic> json) {
    return PostCommenter(
      userID: json['userID'],
      mention: json['mention'],
      username: json['username'],
      displayname: json['displayname'],
      userURL: json['userURL'],
      avatar: MediaURL.fromJson(json['avatar']),
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'mention': mention,
      'username': username,
      'displayname': displayname,
      'userURL': userURL,
      'avatar': avatar.toJson(),
    };
  }
}
