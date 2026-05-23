part of 'package:armoyu_services/armoyu_services.dart';

class SearchServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  SearchServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<SearchHashtagListResponse> hashtag({
    required String hashtag,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "etiket": hashtag,
        "sayfa": page,
      },
      endpoint: "0/0/${_EndpointConstants.hashtag}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    SearchHashtagListResponse armoyuresponse =
        SearchHashtagListResponse(result: result);

    List<APISearcHashtagDetail> list = [];
    for (var element in response['icerik']) {
      list.add(
        APISearcHashtagDetail(
          hashtagID: element['hashtag_ID'],
          value: element['hashtag_value'],
          firstdate: element['hashtag_firstdate'],
          numberofuses: element['hashtag_numberofuses'],
        ),
      );
    }
    armoyuresponse.response = APISearchHashtagList(search: list);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    return armoyuresponse;
  }

  Future<SearchListResponse> searchengine({
    required String searchword,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": "$page",
        "oyuncuadi": searchword,
      },
      endpoint: "0/0/${_EndpointConstants.searchengine}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    SearchListResponse armoyuresponse = SearchListResponse(result: result);

    List<APISearchDetail> list = [];
    for (var element in response['icerik']) {
      list.add(
        APISearchDetail(
          id: element['ID'],
          value: element['Value'],
          turu: element['turu'],
          username: element['username'],
          avatar: element['avatar'],
          gender: element['cins'],
        ),
      );
    }
    armoyuresponse.response = APISearchList(search: list);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    return armoyuresponse;
  }

  Future<SearchListResponse> onlyusers({
    required String searchword,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": "$page",
        "oyuncuadi": searchword,
        "kategori": "oyuncular",
      },
      endpoint: "0/0/${_EndpointConstants.searchengine}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    SearchListResponse armoyuresponse = SearchListResponse(result: result);
    List<APISearchDetail> list = [];
    for (var element in response['icerik']) {
      list.add(
        APISearchDetail(
          id: element['ID'],
          value: element['Value'],
          turu: element['turu'],
          username: element['username'],
          avatar: element['avatar'],
          gender: element['cins'],
        ),
      );
    }
    armoyuresponse.response = APISearchList(search: list);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    return armoyuresponse;
  }

  Future<ServiceResult> onlyschools({
    required String searchword,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": "$page",
        "oyuncuadi": searchword,
      },
      endpoint: "0/0/${_EndpointConstants.searchengine}/0/0/",
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

  Future<ServiceResult> onlyworks({
    required String searchword,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": "$page",
        "oyuncuadi": searchword,
      },
      endpoint: "0/0/${_EndpointConstants.searchengine}/0/0/",
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
}
