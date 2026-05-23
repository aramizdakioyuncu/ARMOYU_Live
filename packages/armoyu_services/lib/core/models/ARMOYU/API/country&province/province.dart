class APIProvince {
  int provinceID;
  String name;
  int platecode;
  int phonecode;
  APIProvince({
    required this.provinceID,
    required this.name,
    required this.platecode,
    required this.phonecode,
  });

  // JSON'dan APICountry nesnesi oluşturma
  factory APIProvince.fromJson(Map<String, dynamic> json) {
    return APIProvince(
      provinceID: json['provinceID'],
      name: json['name'],
      platecode: json['platecode'],
      phonecode: json['phonecode'],
    );
  }

  // APICountry nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'provinceID': provinceID,
      'name': name,
      'platecode': platecode,
      'phonecode': phonecode,
    };
  }
}
