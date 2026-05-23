class APINotificationList {
  int bildirimID;
  int bildirimDurum;
  String bildirimIcerik;
  String bildirimIcerikLink;
  String bildirimZaman;
  int bildirimGonderenID;
  String bildirimGonderenAdSoyad;
  String bildirimGonderenAvatar;
  String bildirimGonderenLink;
  String bildirimAmac;
  String bildirimKategori;
  int bildirimKategoriDetay;

  APINotificationList({
    required this.bildirimID,
    required this.bildirimDurum,
    required this.bildirimIcerik,
    required this.bildirimIcerikLink,
    required this.bildirimZaman,
    required this.bildirimGonderenID,
    required this.bildirimGonderenAdSoyad,
    required this.bildirimGonderenAvatar,
    required this.bildirimGonderenLink,
    required this.bildirimAmac,
    required this.bildirimKategori,
    required this.bildirimKategoriDetay,
  });

  factory APINotificationList.fromJson(Map<String, dynamic> json) {
    return APINotificationList(
      bildirimID: json['bildirimID'],
      bildirimDurum: json['bildirimdurum'],
      bildirimIcerik: json['bildirimicerik'],
      bildirimIcerikLink: json['bildirimiceriklink'],
      bildirimZaman: json['bildirimzaman'],
      bildirimGonderenID: json['bildirimgonderenID'],
      bildirimGonderenAdSoyad: json['bildirimgonderenadsoyad'],
      bildirimGonderenAvatar: json['bildirimgonderenavatar'],
      bildirimGonderenLink: json['bildirimgonderenlink'],
      bildirimAmac: json['bildirimamac'],
      bildirimKategori: json['bildirimkategori'],
      bildirimKategoriDetay: json['bildirimkategoridetay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bildirimID': bildirimID,
      'bildirimdurum': bildirimDurum,
      'bildirimicerik': bildirimIcerik,
      'bildirimiceriklink': bildirimIcerikLink,
      'bildirimzaman': bildirimZaman,
      'bildirimgonderenID': bildirimGonderenID,
      'bildirimgonderenadsoyad': bildirimGonderenAdSoyad,
      'bildirimgonderenavatar': bildirimGonderenAvatar,
      'bildirimgonderenlink': bildirimGonderenLink,
      'bildirimamac': bildirimAmac,
      'bildirimkategori': bildirimKategori,
      'bildirimkategoridetay': bildirimKategoriDetay,
    };
  }
}
