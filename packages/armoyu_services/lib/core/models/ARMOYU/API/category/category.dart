class APICategory {
  int categoryID;
  String name;

  APICategory({
    required this.categoryID,
    required this.name,
  });

  // JSON'dan Category nesnesi oluşturma
  factory APICategory.fromJson(Map<String, dynamic> json) {
    return APICategory(
      categoryID: json['categoryID'],
      name: json['name'],
    );
  }

  // Category nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'categoryID': categoryID,
      'name': name,
    };
  }
}
