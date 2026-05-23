part of 'package:armoyu_services/armoyu_services.dart';

class LoginRegisterServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  LoginRegisterServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<LoginRegisterInviteCodeResponse> inviteCodeTest(
      {required String code}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"davetkodu": code},
      endpoint: "0/0/${_EndpointConstants.invitecodefetch}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    LoginRegisterInviteCodeResponse armoyuresponse =
        LoginRegisterInviteCodeResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    armoyuresponse.response = APIInvitecode(
      userID: response['aciklamadetay']['oyuncu_ID'],
      displayname: response['aciklamadetay']['oyuncu_displayName'],
      avatar: MediaURL(
        bigURL: response['aciklamadetay']['oyuncu_avatar'],
        normalURL: response['aciklamadetay']['oyuncu_avatar'],
        minURL: response['aciklamadetay']['oyuncu_avatar'],
      ),
    );

    return armoyuresponse;
  }
}
