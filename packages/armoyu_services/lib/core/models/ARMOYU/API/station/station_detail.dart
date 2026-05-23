class APIStationDetail {
  int id;
  String value;

  APIStationDetail({
    required this.id,
    required this.value,
  });

  // JSON'dan nesne oluşturma
  factory APIStationDetail.fromJson(Map<String, dynamic> json) {
    return APIStationDetail(
      id: json['id'],
      value: json['value'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}
