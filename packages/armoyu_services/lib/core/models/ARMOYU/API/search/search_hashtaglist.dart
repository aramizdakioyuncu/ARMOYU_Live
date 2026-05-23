class APISearchHashtagList {
  List<APISearcHashtagDetail> search;

  APISearchHashtagList({
    required this.search,
  });

  // JSON'dan model oluşturma
  factory APISearchHashtagList.fromJson(Map<String, dynamic> json) {
    return APISearchHashtagList(
      search: (json['search'] as List<dynamic>)
          .map((e) => APISearcHashtagDetail.fromJson(e as Map<String, dynamic>))
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

class APISearcHashtagDetail {
  int hashtagID;
  String value;
  int? numberofuses;
  String? firstdate;

  APISearcHashtagDetail({
    required this.hashtagID,
    required this.value,
    this.numberofuses,
    this.firstdate,
  });

  // JSON'dan model oluşturma
  factory APISearcHashtagDetail.fromJson(Map<String, dynamic> json) {
    return APISearcHashtagDetail(
      hashtagID: json['hashtagID'] as int,
      value: json['value'] as String,
      numberofuses: json['numberofuses'] as int?,
      firstdate: json['firstdate'] as String?,
    );
  }

  // Modeli JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'hashtagID': hashtagID,
      'value': value,
      'numberofuses': numberofuses,
      'firstdate': firstdate,
    };
  }
}
