class APIChatDetailList {
  String sohbetKim;
  String? renkKodu;
  String adSoyad;
  String avatar;
  String mesajIcerik;
  String zaman;
  String zamanTarih;
  String zamanSaat;
  int durum;

  APIChatDetailList({
    required this.sohbetKim,
    this.renkKodu,
    required this.adSoyad,
    required this.avatar,
    required this.mesajIcerik,
    required this.zaman,
    required this.zamanTarih,
    required this.zamanSaat,
    required this.durum,
  });

  factory APIChatDetailList.fromJson(Map<String, dynamic> json) {
    return APIChatDetailList(
      sohbetKim: json['sohbetkim'],
      renkKodu: json['renkkodu'],
      adSoyad: json['adsoyad'],
      avatar: json['avatar'],
      mesajIcerik: json['mesajicerik'],
      zaman: json['zaman'],
      zamanTarih: json['zamantarih'],
      zamanSaat: json['zamansaat'],
      durum: json['durum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sohbetkim': sohbetKim,
      'renkkodu': renkKodu,
      'adsoyad': adSoyad,
      'avatar': avatar,
      'mesajicerik': mesajIcerik,
      'zaman': zaman,
      'zamantarih': zamanTarih,
      'zamansaat': zamanSaat,
      'durum': durum,
    };
  }
}
