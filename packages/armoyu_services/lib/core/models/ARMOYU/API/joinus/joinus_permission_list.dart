class APIJoinusPermissionList {
  int id;
  String value;
  String category;
  String? about;
  String joinStatus;

  APIJoinusPermissionList({
    required this.id,
    required this.value,
    required this.category,
    required this.about,
    required this.joinStatus,
  });

  factory APIJoinusPermissionList.fromJson(Map<String, dynamic> json) {
    return APIJoinusPermissionList(
      id: json['ID'],
      value: json['Value'],
      category: json['category'],
      about: json['about'],
      joinStatus: json['joinstatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Value': value,
      'category': category,
      'about': about,
      'joinstatus': joinStatus,
    };
  }
}
