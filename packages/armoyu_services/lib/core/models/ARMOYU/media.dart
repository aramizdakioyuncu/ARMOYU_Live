class Media {
  int mediaID;
  MediaOwner? owner;

  String? mediaTime;
  String? mediaType;
  MediaURL mediaURL;
  String? mediaDirection;

  Media({
    required this.mediaID,
    this.owner,
    this.mediaTime,
    this.mediaType,
    required this.mediaURL,
    this.mediaDirection,
  });

  Map<String, dynamic> toJson() {
    return {
      'mediaID': mediaID,
      'owner': owner,
      'mediaTime': mediaTime,
      'mediaType': mediaType,
      'mediaURL': mediaURL.toJson(),
      'mediaDirection': mediaDirection,
    };
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaID: json['mediaID'],
      owner: MediaOwner.fromJson(json['owner']),
      mediaTime: json['mediaTime'],
      mediaType: json['mediaType'],
      mediaURL: MediaURL.fromJson(json['mediaURL']),
      mediaDirection: json['mediaDirection'],
    );
  }
}

class MediaOwner {
  int userID;
  String displayname;
  MediaURL avatar;
  MediaOwner({
    required this.userID,
    required this.displayname,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'displayname': displayname,
      'avatar': avatar,
    };
  }

  factory MediaOwner.fromJson(Map<String, dynamic> json) {
    return MediaOwner(
      userID: json['userID'],
      displayname: json['displayname'],
      avatar: MediaURL.fromJson(json['avatar']),
    );
  }
}

class MediaURL {
  String bigURL;
  String normalURL;
  String minURL;

  MediaURL({
    required this.bigURL,
    required this.normalURL,
    required this.minURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'bigURL': bigURL,
      'normalURL': normalURL,
      'minURL': minURL,
    };
  }

  factory MediaURL.fromJson(Map<String, dynamic> json) {
    return MediaURL(
      bigURL: json['bigURL'],
      normalURL: json['normalURL'],
      minURL: json['minURL'],
    );
  }
}
