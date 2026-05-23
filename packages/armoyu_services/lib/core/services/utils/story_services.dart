part of 'package:armoyu_services/armoyu_services.dart';

class StoryServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  StoryServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<StoryFetchListResponse> stories({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": page,
        "limit": "20",
      },
      endpoint: "0/0/${_EndpointConstants.story}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StoryFetchListResponse armoyuresponse =
        StoryFetchListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIStoryList> storyList = [];
    for (var element in response['icerik']) {
      List<StoryContent> storycontent = [];

      for (var element2 in element['hikaye_icerik']) {
        storycontent.add(
          StoryContent(
            hikayeId: element2['hikaye_ID'],
            hikayeDurum: element2['hikaye_durum'],
            hikayeSahip: element2['hikaye_sahip'],
            hikayeZaman: element2['hikaye_zaman'],
            hikayeBenBegeni: element2['hikaye_benbegeni'],
            hikayeBenGoruntulenme: element2['hikaye_bengoruntulenme'],
            hikayeMedya: element2['hikaye_medya'],
          ),
        );
      }
      storyList.add(
        APIStoryList(
          oyuncuId: element['oyuncu_ID'],
          oyuncuAdSoyad: element['oyuncu_adsoyad'],
          oyuncuKadi: element['oyuncu_kadi'],
          oyuncuAvatar: MediaURL(
            bigURL: element['oyuncu_avatar'],
            normalURL: element['oyuncu_avatar'],
            minURL: element['oyuncu_avatar'],
          ),
          hikayeSayisi: element['hikaye_sayisi'],
          hikayeIcerik: storycontent,
        ),
      );
    }
    armoyuresponse.response = storyList;
    return armoyuresponse;
  }

  Future<ServiceResult> addstory({
    required String imageURL,
    required bool isEveryonePublish,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "hikayemedya": imageURL,
        "hikayepaylasimkategori": isEveryonePublish
      },
      endpoint: "0/0/${_EndpointConstants.addstory}/0/",
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

  Future<ServiceResult> removestory({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.removestory}/0/",
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

  Future<ServiceResult> hidestory({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.hidestory}/0/",
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

  Future<ServiceResult> view({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.viewstory}/0/",
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

  Future<StoryViewListResponse> fetchviewlist({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.viewliststory}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StoryViewListResponse armoyuresponse =
        StoryViewListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIStoryViewlist> storyviewerList = [];
    for (var element in response['icerik']) {
      storyviewerList.add(
        APIStoryViewlist(
          goruntuleyenId: element['hgoruntuleyen_ID'],
          goruntuleyenAdSoyad: element['hgoruntuleyen_adsoyad'],
          goruntuleyenKullaniciAd: element['hgoruntuleyen_kullaniciad'],
          goruntuleyenAvatar: MediaURL(
            bigURL: element['hgoruntuleyen_avatar'],
            normalURL: element['hgoruntuleyen_avatar'],
            minURL: element['hgoruntuleyen_avatar'],
          ),
          goruntuleyenBegenme: element['hgoruntuleyen_begenme'],
        ),
      );
    }

    armoyuresponse.response = storyviewerList;

    return armoyuresponse;
  }

  Future<ServiceResult> like({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.likestory}/0/",
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

  Future<ServiceResult> likeremove({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.likeremovestory}/0/",
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

  Future<StoryLikerListResponse> likerslist({required int storyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hikayeID": "$storyID"},
      endpoint: "0/0/${_EndpointConstants.likestory}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StoryLikerListResponse armoyuresponse =
        StoryLikerListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    List<APIStoryLikelist> storylikelist = [];

    for (var element in response['icerik']) {
      storylikelist.add(
        APIStoryLikelist(
          viewerId: element['hgoruntuleyen_ID'],
          viewerFullName: element['hgoruntuleyen_adsoyad'],
          viewerUsername: element['hgoruntuleyen_kullaniciad'],
          viewerAvatar: element['hgoruntuleyen_avatar'],
        ),
      );
    }

    armoyuresponse.response = storylikelist;
    return armoyuresponse;
  }
}
