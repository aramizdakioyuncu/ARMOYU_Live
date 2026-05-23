part of 'package:armoyu_services/armoyu_services.dart';

class UtilsServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  UtilsServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<ServiceResult> getappdetail() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.previusAuthServicesLogin}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    if (response['durum'] == 0) {
      return result;
    }
    return result;
  }

  Future<ServiceResult> fetchUserInfo({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"oyuncubakid": "$userID"},
      endpoint: "0/0/${_EndpointConstants.previusAuthServicesLogin}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    if (response['durum'] == 0) {
      return result;
    }
    return result;
  }

  Future<ServiceResult> forgotpassword({
    required String username,
    required String useremail,
    required String userresettype,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "kullaniciadi": username,
        "email": useremail,
        "sifirlamatercihi": userresettype
      },
      endpoint: "0/0/${_EndpointConstants.forgotPassword}/0/0/",
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    if (response['durum'] == 0) {
      return result;
    }
    return result;
  }

  Future<ServiceResult> forgotpassworddone({
    required String username,
    required String password,
    required String useremail,
    required String securitycode,
    required String repassword,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "kullaniciadi": username,
        "email": useremail,
        "dogrulamakodu": securitycode,
        "sifre": password,
        "sifretekrar": repassword
      },
      endpoint: "0/0/${_EndpointConstants.forgotPassword}/0/0/",
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    if (response['durum'] == 0) {
      return result;
    }
    return result;
  }

  Future<LookProfileResponse> lookProfile({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"oyuncubakid": userID},
      endpoint: "0/0/${_EndpointConstants.previusAuthServicesLogin}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    LookProfileResponse armoyuresponse = LookProfileResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    armoyuresponse.response = APILogin.updateclass(response);
    return armoyuresponse;
  }

  Future<LookProfilewithUsernameResponse> lookProfilewithusername(
      {required String userusername}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"oyuncubakusername": userusername},
      endpoint: "0/0/${_EndpointConstants.previusAuthServicesLogin}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    LookProfilewithUsernameResponse armoyuresponse =
        LookProfilewithUsernameResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    armoyuresponse.response = APILogin.updateclass(response);
    return armoyuresponse;
  }

  Future<PlayerPopResponse> getplayerxp({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": page},
      endpoint: "0/0/${_EndpointConstants.xpordering}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    PlayerPopResponse armoyuresponse = PlayerPopResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    List<APIPlayerPop> xplist = [];
    for (var element in response['icerik']) {
      xplist.add(
        APIPlayerPop(
          oyuncuID: element['oyuncuID'],
          oyuncuAdSoyad: element['oyuncuadsoyad'],
          oyuncuKullaniciAdi: element['oyuncukullaniciadi'],
          oyuncuAvatar: element['oyuncuavatar'],
          oyuncuSeviye: element['oyuncuseviye'],
          oyuncuSeviyeXP: element['oyuncuseviyexp'],
          oyuncuSeviyeSezonlukXP: element['oyuncuseviyesezonlukxp'],
          oyuncuPop: element['oyuncupop'],
        ),
      );
    }
    armoyuresponse.response = xplist;

    return armoyuresponse;
  }

  Future<PlayerPopResponse> getplayerpop({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": page},
      endpoint: "0/0/${_EndpointConstants.popordering}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    PlayerPopResponse armoyuresponse = PlayerPopResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    List<APIPlayerPop> poplist = [];
    for (var element in response['icerik']) {
      poplist.add(
        APIPlayerPop(
          oyuncuID: element['oyuncuID'],
          oyuncuAdSoyad: element['oyuncuadsoyad'],
          oyuncuKullaniciAdi: element['oyuncukullaniciadi'],
          oyuncuAvatar: element['oyuncuavatar'],
          oyuncuSeviye: element['oyuncuseviye'],
          oyuncuSeviyeXP: element['oyuncuseviyexp'],
          oyuncuSeviyeSezonlukXP: element['oyuncuseviyesezonlukxp'],
          oyuncuPop: element['oyuncupop'],
        ),
      );
    }

    armoyuresponse.response = poplist;

    return armoyuresponse;
  }

  //

  Future<ForeignCurrencyListResponse> foreigncurrencylist(
      {required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": "$page"},
      endpoint: "0/0/piyasa-kur/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    ForeignCurrencyListResponse armoyuresponse =
        ForeignCurrencyListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<ForeignCurrencyList> currencyList = [];
    for (var element in response['icerik']) {
      currencyList.add(
        ForeignCurrencyList(
          name: element['dovizkisaisim'],
          value: element['dovizdeger'],
          image: element['dovizlink'],
        ),
      );
    }
    armoyuresponse.response = currencyList;
    return armoyuresponse;
  }

  Future<WeatherListResponse> weatherlist({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": "$page"},
      endpoint: "0/0/hava-durumu/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    WeatherListResponse armoyuresponse = WeatherListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<WeatherAPI> list = [];
    for (var element in response['icerik']) {
      list.add(
        WeatherAPI(
          city: element['sehir'],
          value: element['derece'],
          weatherlogo: element['logo'],
        ),
      );
    }
    armoyuresponse.response = list;
    return armoyuresponse;
  }

  Future<SuperLigResponse> superlig({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": "$page"},
      endpoint: "0/0/super-lig/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    SuperLigResponse armoyuresponse = SuperLigResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<SuperLigAPI> list = [];
    for (var element in response['icerik']) {
      list.add(
        SuperLigAPI(
          teamname: element['takimadi'],
          avarage: int.parse(element['avaraj']),
          playedmatchcount: int.parse(element['oynananmac']),
          point: int.parse(element['puan']),
          teamlogo: element['logo'] == null
              ? null
              : MediaURL(
                  bigURL: element['logo'],
                  normalURL: element['logo'],
                  minURL: element['logo'],
                ),
        ),
      );
    }
    armoyuresponse.response = list;
    return armoyuresponse;
  }

  Future<GamesOnSaleResponse> gamesOnSale({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": "$page"},
      endpoint: "0/0/indirimdeki-oyunlar/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    GamesOnSaleResponse armoyuresponse = GamesOnSaleResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<GamesOnSaleAPI> list = [];
    for (var element in response['icerik']) {
      list.add(
        GamesOnSaleAPI(
          gameName: element['oyunadi'],
          gameLogo: element['logo'],
          gameLink: element['oyunlink'],
          gamePrice: element['listestil'],
          gamePriceStyle: element['indirimfiyat'],
          gameDiscount: element['indirimoran'],
        ),
      );
    }
    armoyuresponse.response = list;
    return armoyuresponse;
  }

  Future<NewRegisteredUsersResponse> newRegisterUsers(
      {required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": "$page"},
      endpoint: "0/0/yeni-uyeler/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    NewRegisteredUsersResponse armoyuresponse =
        NewRegisteredUsersResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<NewRegisteredUsersAPI> list = [];
    for (var element in response['icerik']) {
      list.add(
        NewRegisteredUsersAPI(
          displayname: element['oyuncuadi'],
          avatar: MediaURL(
            bigURL: element['oyuncuavatar'],
            normalURL: element['oyuncuavatar'],
            minURL: element['oyuncuavatar'],
          ),
          level: int.parse(element['oyuncuseviye']),
          levelcolor: element['oyuncuseviyerenk'],
          xp: element['oyuncuxp'],
          url: element['oyunculink'],
          isme: element['isme'] == 1 ? true : false,
        ),
      );
    }
    armoyuresponse.response = list;
    return armoyuresponse;
  }

  Future<MinecraftStatisticsResponse> minecraftStatistics(
      {required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": "$page"},
      endpoint: "0/0/minecraft-istatistik/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    MinecraftStatisticsResponse armoyuresponse =
        MinecraftStatisticsResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<MinecraftStatisticsAPI> list = [];
    for (var element in response['icerik']) {
      list.add(
        MinecraftStatisticsAPI(
          playername: element['kullaniciad'],
          clanname: element['klan'],
          clancolor: element['klanrenk'],
          point: element['lessayisi'],
        ),
      );
    }
    armoyuresponse.response = list;
    return armoyuresponse;
  }
}
