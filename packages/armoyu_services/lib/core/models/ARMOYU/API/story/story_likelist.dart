class APIStoryLikelist {
  int viewerId;
  String viewerFullName;
  String viewerUsername;
  String viewerAvatar;

  APIStoryLikelist({
    required this.viewerId,
    required this.viewerFullName,
    required this.viewerUsername,
    required this.viewerAvatar,
  });

  factory APIStoryLikelist.fromJson(Map<String, dynamic> json) {
    return APIStoryLikelist(
      viewerId: json['viewerId'],
      viewerFullName: json['viewerFullName'],
      viewerUsername: json['viewerUsername'],
      viewerAvatar: json['viewerAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewerId': viewerId,
      'viewerFullName': viewerFullName,
      'viewerUsername': viewerUsername,
      'viewerAvatar': viewerAvatar,
    };
  }
}
