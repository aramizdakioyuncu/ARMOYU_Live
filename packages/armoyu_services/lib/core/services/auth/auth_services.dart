part of 'package:armoyu_services/armoyu_services.dart';

final class AuthServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  AuthServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    password = _apiHelpers.generateMd5(password);

    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "username": username,
        "password": password,
      },
      endpoint: "0/0/${_EndpointConstants.previusAuthServicesLogin}/0/0/",
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    LoginResponse armoyuresponse = LoginResponse(result: result);
    if (armoyuresponse.result.status == false ||
        armoyuresponse.result.description == "Oyuncu bilgileri yanlış!") {
      return armoyuresponse;
    }

    //TOKEN AYARLARMA
    setToken(response['aciklama']);
    //TOKEN AYARLARMA

    armoyuresponse.response = APILogin.updateclass(response);

    return armoyuresponse;
  }

  Future<LoginResponse> loginwithbarriertoken(
      {required String barriertoken}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.previusAuthServicesLogin}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: barriertoken),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    LoginResponse armoyuresponse = LoginResponse(result: result);
    if (armoyuresponse.result.status == false ||
        armoyuresponse.result.description == "Oyuncu bilgileri yanlış!") {
      return armoyuresponse;
    }

    //TOKEN AYARLARMA
    setToken(barriertoken);
    //TOKEN AYARLARMA

    armoyuresponse.response = APILogin.updateclass(response);

    return armoyuresponse;
  }

  setbarriertoken({required String barriertoken}) {
    //TOKEN AYARLARMA
    setToken(barriertoken);
    //TOKEN AYARLARMA
  }

  Future<RegisterResponse> register({
    required String firstname,
    required String lastname,
    required String username,
    required String email,
    required String password,
    required String rpassword,
    String? inviteCode,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "islem": "kayit-ol",
        "kullaniciadi": username,
        "ad": firstname,
        "soyad": lastname,
        "email": email,
        "parola": password,
        "parolakontrol": rpassword,
        "davetkodu": inviteCode ?? "",
      },
      endpoint: "0/0/${_EndpointConstants.register}/0/0/",
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    RegisterResponse armoyuresponse = RegisterResponse(result: result);

    return armoyuresponse;
  }

  Future<Map<String, dynamic>> logOut() async {
    Map<String, dynamic> result = await _apiHelpers.post(
      body: {"islem": "cikis-yap"},
      endpoint: "0/0/${_EndpointConstants.logout}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    return result;
  }
}
