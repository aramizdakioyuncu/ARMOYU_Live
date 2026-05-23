part of 'package:armoyu_services/armoyu_services.dart';

class ControlpanelServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  ControlpanelServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<ControlPanelHomeResponse> home() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "category": "home",
      },
      endpoint: "0/0/${_EndpointConstants.controlpanel}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ControlPanelHomeResponse armoyuresponse =
        ControlPanelHomeResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIControlpanelUserslist> usersList = [];
    for (var element in response['icerik']) {
      usersList.add(
        APIControlpanelUserslist(
          id: element['#'],
          kullaniciNo: element['kullanici_no'],
          userLogin: element['user_login'],
          displayName: element['display_name'],
          avatar: MediaURL(
            bigURL: element['avatar'],
            normalURL: element['avatar'],
            minURL: element['avatar'],
          ),
          yetki: element['yetki'],
          kayitEden: element['kayit_eden'],
          yas: element['yas'],
          sonGiris: element['son_giris'],
          kalanHak: element['kalan_hak'],
          problemli: element['problemli'],
        ),
      );
    }
    armoyuresponse.response = usersList;

    return armoyuresponse;
  }

  Future<ControlPanelMeetingResponse> meeting() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "category": "meeting",
      },
      endpoint: "0/0/${_EndpointConstants.controlpanel}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ControlPanelMeetingResponse armoyuresponse =
        ControlPanelMeetingResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIControlpanelMeetinglist> meetingList = [];
    for (var element in response['icerik']) {
      meetingList.add(
        APIControlpanelMeetinglist(
          etkinlikId: element['etkinlik_id'],
          etkinlikAdi: element['etkinlik_adi'],
          olusturan: element['olusturan'],
          olusturanAvatar: element['olusturan_avatar'],
          zaman: element['zaman'],
          katilimciSayisi: element['katilimci_sayisi'],
          katilimLimit: element['katilim_limit'],
          durum: element['durum'],
        ),
      );
    }
    armoyuresponse.response = meetingList;

    return armoyuresponse;
  }
}
