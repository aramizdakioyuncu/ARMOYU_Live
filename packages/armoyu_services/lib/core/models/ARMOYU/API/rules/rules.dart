class APIRules {
  final int ruleId;
  final String content;
  final String penaltyDuration;
  final String penaltyDate;
  final int? subRule;

  APIRules({
    required this.ruleId,
    required this.content,
    required this.penaltyDuration,
    required this.penaltyDate,
    this.subRule,
  });

  /// JSON'dan `RuleModel` nesnesine dönüştürme
  factory APIRules.fromJson(Map<String, dynamic> json) {
    return APIRules(
      ruleId: json['kuralid'],
      content: json['kuralicerik'],
      penaltyDuration: json['cezabaslangic'],
      penaltyDate: json['cezakoyulmatarihi'],
      subRule: json['kuralaltmadde'],
    );
  }

  /// `RuleModel` nesnesini JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'kuralid': ruleId,
      'kuralicerik': content,
      'cezabaslangic': penaltyDuration,
      'cezakoyulmatarihi': penaltyDate,
      'kuralaltmadde': subRule,
    };
  }
}
