class APIControlpanelMeetinglist {
  final String etkinlikId;
  final String etkinlikAdi;
  final String olusturan;
  final String olusturanAvatar;
  final String zaman;
  final int katilimciSayisi;
  final String katilimLimit;
  final String durum;

  APIControlpanelMeetinglist({
    required this.etkinlikId,
    required this.etkinlikAdi,
    required this.olusturan,
    required this.olusturanAvatar,
    required this.zaman,
    required this.katilimciSayisi,
    required this.katilimLimit,
    required this.durum,
  });

  /// JSON'dan Dart Nesnesine Çevirme
  factory APIControlpanelMeetinglist.fromJson(Map<String, dynamic> json) {
    return APIControlpanelMeetinglist(
      etkinlikId: json["etkinlik_id"] ?? "",
      etkinlikAdi: json["etkinlik_adi"] ?? "",
      olusturan: json["olusturan"] ?? "",
      olusturanAvatar: json["olusturan_avatar"] ?? "",
      zaman: json["zaman"] ?? "",
      katilimciSayisi: json["katilimci_sayisi"] ?? 0,
      katilimLimit: json["katilim_limit"] ?? "0",
      durum: json["durum"] ?? "Bilinmiyor",
    );
  }

  /// Dart Nesnesinden JSON'a Çevirme
  Map<String, dynamic> toJson() {
    return {
      "etkinlik_id": etkinlikId,
      "etkinlik_adi": etkinlikAdi,
      "olusturan": olusturan,
      "olusturan_avatar": olusturanAvatar,
      "zaman": zaman,
      "katilimci_sayisi": katilimciSayisi,
      "katilim_limit": katilimLimit,
      "durum": durum,
    };
  }
}
