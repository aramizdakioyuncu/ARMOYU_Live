part of 'package:armoyu_services/armoyu_services.dart';

class AppServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  AppServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<SitemessageResponse> sitemesaji() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.sitemessages}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    SitemessageResponse armoyuresponse = SitemessageResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    Sitemessage sitemessage = Sitemessage(
      status: response['icerik']['durum'] == 1 ? true : false,
      currentMembers: response['icerik']['mevcutoyuncu'],
      onlineMembers: response['icerik']['cevrimicikac'],
      chatcount: response['icerik']['sohbetbildirim'],
      avaiblepolls: response['icerik']['mevcutanket'],
      avaibleEvents: response['icerik']['mevcutetkinlik'],
      avaiblegroupEvents: response['icerik']['grupetkinlik'],
      downloads: response['icerik']['indirmeler'],
      friendrequests: response['icerik']['arkadaslikistekleri'],
      grouprequests: response['icerik']['grupistekleri'],
    );

    armoyuresponse.response = sitemessage;
    return armoyuresponse;
  }
}
