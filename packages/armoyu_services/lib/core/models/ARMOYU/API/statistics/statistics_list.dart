class APIStatisticsList {
  final TimeCategory month;
  final TimeCategory days;
  final TimeCategory hours;

  APIStatisticsList({
    required this.month,
    required this.days,
    required this.hours,
  });

  /// JSON'dan `StatisticsData` nesnesine dönüştürme
  factory APIStatisticsList.fromJson(Map<String, dynamic> json) {
    return APIStatisticsList(
      month: TimeCategory.fromJson(json['month']),
      days: TimeCategory.fromJson(json['days']),
      hours: TimeCategory.fromJson(json['hours']),
    );
  }

  /// `StatisticsData` nesnesini JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'month': month.toJson(),
      'days': days.toJson(),
      'hours': hours.toJson(),
    };
  }
}

/// **Zaman kategorilerini temsil eden model (Aylar, Günler, Saatler)**
class TimeCategory {
  final List<String> titles;
  final List<String?> values;
  final int totalValue;
  final double percentage;

  TimeCategory({
    required this.titles,
    required this.values,
    required this.totalValue,
    required this.percentage,
  });

  /// JSON'dan `TimeCategory` nesnesine dönüştürme
  factory TimeCategory.fromJson(Map<String, dynamic> json) {
    return TimeCategory(
      titles: List<String>.from(json['titles']),
      values: json['values']
          .map<int?>((e) => e == "null" ? null : int.tryParse(e.toString()))
          .toList(),
      totalValue: json['totalvalue'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  /// JSON'a dönüştürme metodu
  Map<String, dynamic> toJson() {
    return {
      'titles': titles,
      'values': values.map((e) => e?.toString() ?? "null").toList(),
      'totalvalue': totalValue,
      'percentage': percentage,
    };
  }
}
