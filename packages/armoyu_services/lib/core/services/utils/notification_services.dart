part of 'package:armoyu_services/armoyu_services.dart';

class NotificationServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  NotificationServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }
  Future<NotificationListResponse> getnotifications({
    required String kategori,
    required String kategoridetay,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "kategori": kategori,
        "kategoridetay": kategoridetay,
        "sayfa": page,
        "limit": "20",
      },
      endpoint: "0/0/${_EndpointConstants.notifications}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    NotificationListResponse armoyuresponse =
        NotificationListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APINotificationList> notificationList = [];
    for (var element in response['icerik']) {
      notificationList.add(
        APINotificationList(
          bildirimID: element['bildirimID'],
          bildirimDurum: element['bildirimdurum'],
          bildirimIcerik: element['bildirimicerik'],
          bildirimIcerikLink: element['bildirimiceriklink'],
          bildirimZaman: element['bildirimzaman'],
          bildirimGonderenID: element['bildirimgonderenID'],
          bildirimGonderenAdSoyad: element['bildirimgonderenadsoyad'],
          bildirimGonderenAvatar: element['bildirimgonderenavatar'],
          bildirimGonderenLink: element['bildirimgonderenlink'],
          bildirimAmac: element['bildirimamac'],
          bildirimKategori: element['bildirimkategori'],
          bildirimKategoriDetay: element['bildirimkategoridetay'],
        ),
      );
    }
    armoyuresponse.response = notificationList;
    return armoyuresponse;
  }

  Future<NotificationSettingsResponse> listNotificationSettings() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.notificationsettings}/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    NotificationSettingsResponse armoyuresponse =
        NotificationSettingsResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    armoyuresponse.response = APINotificationSetting(
      paylasimBegeni: response['icerik']['paylasimbegeni'],
      paylasimYorum: response['icerik']['paylasimyorum'],
      yorumBegeni: response['icerik']['yorumbegeni'],
      dogumGunu: response['icerik']['dogumgunu'],
      etkinlik: response['icerik']['etkinlik'],
      yorumYanit: response['icerik']['yorumyanit'],
      mesajlar: response['icerik']['mesajlar'],
      aramalar: response['icerik']['aramalar'],
      bahsetmeler: response['icerik']['bahsetmeler'],
    );
    return armoyuresponse;
  }

  Future<NotificationSettingsUpdateResponse> updateNotificationSettings(
      {required List<String> options}) async {
    Map<String, String> formData = {};

    for (int i = 0; i < options.length; i++) {
      formData['notification[$i]'] = options[i];
    }
    Map<String, dynamic> response = await _apiHelpers.post(
      body: formData,
      endpoint: "0/0/${_EndpointConstants.notificationsettingsupdate}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    NotificationSettingsUpdateResponse armoyuresponse =
        NotificationSettingsUpdateResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    return armoyuresponse;
  }
}
