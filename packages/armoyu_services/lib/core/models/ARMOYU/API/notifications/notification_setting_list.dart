class APINotificationSetting {
  final int paylasimBegeni;
  final int paylasimYorum;
  final int yorumBegeni;
  final int dogumGunu;
  final int etkinlik;
  final int yorumYanit;
  final int mesajlar;
  final int aramalar;
  final int bahsetmeler;

  APINotificationSetting({
    required this.paylasimBegeni,
    required this.paylasimYorum,
    required this.yorumBegeni,
    required this.dogumGunu,
    required this.etkinlik,
    required this.yorumYanit,
    required this.mesajlar,
    required this.aramalar,
    required this.bahsetmeler,
  });

  // JSON'dan APINotificationList nesnesi oluşturma
  factory APINotificationSetting.fromJson(Map<String, dynamic> json) {
    return APINotificationSetting(
      paylasimBegeni: json['paylasimbegeni'] as int,
      paylasimYorum: json['paylasimyorum'] as int,
      yorumBegeni: json['yorumbegeni'] as int,
      dogumGunu: json['dogumgunu'] as int,
      etkinlik: json['etkinlik'] as int,
      yorumYanit: json['yorumyanit'] as int,
      mesajlar: json['mesajlar'] as int,
      aramalar: json['aramalar'] as int,
      bahsetmeler: json['bahsetmeler'] as int,
    );
  }

  // APINotificationList nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'paylasimbegeni': paylasimBegeni,
      'paylasimyorum': paylasimYorum,
      'yorumbegeni': yorumBegeni,
      'dogumgunu': dogumGunu,
      'etkinlik': etkinlik,
      'yorumyanit': yorumYanit,
      'mesajlar': mesajlar,
      'aramalar': aramalar,
      'bahsetmeler': bahsetmeler,
    };
  }
}
