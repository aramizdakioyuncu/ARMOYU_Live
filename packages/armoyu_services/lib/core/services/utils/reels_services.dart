part of 'package:armoyu_services/armoyu_services.dart';

class ReelsServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  ReelsServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<ReelsListResponse> fetch({
    required int page,
    int limit = 30,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": page,
        "limit": limit,
      },
      endpoint: "0/0/${_EndpointConstants.reels}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ReelsListResponse armoyuresponse = ReelsListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIReel> reelsList = [];

    for (var element in response['icerik']) {
      reelsList.add(
        APIReel(
          reelsID: element['reels_ID'],
          owner: UserInfo(
            userID: element['reels_owner']['owner_ID'],
            displayname: element['reels_owner']['owner_displayname'],
            username: element['reels_owner']['owner_username'],
            avatar: MediaURL(
              bigURL: element['reels_owner']['owner_avatar']['media_bigURL'],
              normalURL: element['reels_owner']['owner_avatar']['media_URL'],
              minURL: element['reels_owner']['owner_avatar']['media_minURL'],
            ),
          ),
          description: element['reels_description'],
          date: DateTime.parse(element['reels_date']),
          media: Media(
            mediaID: element['reels_media']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['reels_media']['media_URL']['media_bigURL'],
              normalURL: element['reels_media']['media_URL']['media_URL'],
              minURL: element['reels_media']['media_URL']['media_minURL'],
            ),
          ),
        ),
      );
    }

    armoyuresponse.response = reelsList;
    return armoyuresponse;
  }
}
