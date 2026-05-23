class APISearchList {
  List<APISearchDetail> search;

  APISearchList({
    required this.search,
  });

  // JSON'dan model oluşturma
  factory APISearchList.fromJson(Map<String, dynamic> json) {
    return APISearchList(
      search: (json['search'] as List<dynamic>)
          .map((e) => APISearchDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Modeli JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'search': search.map((e) => e.toJson()).toList(),
    };
  }
}

class APISearchDetail {
  int id;
  String value;
  String? turu;
  String? username;
  String? avatar;
  String? gender;

  APISearchDetail({
    required this.id,
    required this.value,
    this.turu,
    this.username,
    this.avatar,
    this.gender,
  });

  // JSON'dan model oluşturma
  factory APISearchDetail.fromJson(Map<String, dynamic> json) {
    return APISearchDetail(
      id: json['id'] as int,
      value: json['value'] as String,
      turu: json['turu'] as String?,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
    );
  }

  // Modeli JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'turu': turu,
      'username': username,
      'avatar': avatar,
      'gender': gender,
    };
  }
}
