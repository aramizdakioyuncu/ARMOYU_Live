class APICountry {
  int countryID;
  String name;
  String code;
  int phonecode;

  APICountry({
    required this.countryID,
    required this.name,
    required this.code,
    required this.phonecode,
  });

  // JSON'dan APICountry nesnesi oluşturma
  factory APICountry.fromJson(Map<String, dynamic> json) {
    return APICountry(
      countryID: json['countryID'],
      name: json['name'],
      code: json['code'],
      phonecode: json['phonecode'],
    );
  }

  // APICountry nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'countryID': countryID,
      'name': name,
      'code': code,
      'phonecode': phonecode,
    };
  }
}
