part of 'package:armoyu_services/armoyu_services.dart';

class NewsServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  NewsServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<NewsListResponse> fetch({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": page,
        "limit": "10",
      },
      endpoint: "0/0/${_EndpointConstants.newsList}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    NewsListResponse armoyuresponse = NewsListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APINewsDetail> list = [];

    for (var element in response['icerik']) {
      list.add(
        APINewsDetail(
          newsID: element['haberID'],
          newsURL: element['link'],
          newsOwner: UserInfo(
            userID: element['yazarID'],
            displayname: element['yazar'],
            avatar: MediaURL(
              bigURL: element['yazaravatar'],
              normalURL: element['yazaravatar'],
              minURL: element['yazaravatar'],
            ),
          ),
          title: element['haberbaslik'],
          content: null,
          summary: element['ozet'],
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: element['resim'],
              normalURL: element['resimorijinal'],
              minURL: element['resimminnak'],
            ),
          ),
          date: element['gecenzaman'],
          category: element['kategori'],
          views: element['goruntulen'],
        ),
      );
    }

    armoyuresponse.response = APINewsList(news: list);
    return armoyuresponse;
  }

  Future<NewsFetchResponse> fetchdetail({
    int? newsID,
    String? newsURL,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: newsID != null
          ? {
              "haberID": newsID,
            }
          : {
              "haberURL": newsURL,
            },
      endpoint: "0/0/${_EndpointConstants.newsDetail}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    NewsFetchResponse armoyuresponse = NewsFetchResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    armoyuresponse.response = APINewsDetail(
      newsID: response['icerik']['haberID'],
      newsURL: response['icerik']['link'],
      newsOwner: UserInfo(
        userID: response['icerik']['yazarID'],
        displayname: response['icerik']['yazar'],
        avatar: MediaURL(
          bigURL: response['icerik']['yazaravatar'],
          normalURL: response['icerik']['yazaravatar'],
          minURL: response['icerik']['yazaravatar'],
        ),
      ),
      title: response['icerik']['haberbaslik'],
      content: response['icerik']['yaziicerik'],
      summary: response['icerik']['ozet'],
      media: Media(
        mediaID: 0,
        mediaURL: MediaURL(
          bigURL: response['icerik']['resim'],
          normalURL: response['icerik']['resimorijinal'],
          minURL: response['icerik']['resimminnak'],
        ),
      ),
      date: response['icerik']['gecenzaman'],
      category: response['icerik']['kategori'],
      views: response['icerik']['goruntulen'],
    );
    return armoyuresponse;
  }
}
