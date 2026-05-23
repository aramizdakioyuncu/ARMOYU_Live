part of 'package:armoyu_services/armoyu_services.dart';

class MusicServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  MusicServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<MusicFetchResponse> musicsList({
    required int page,
    MusicCategory category = MusicCategory.localStorage,
    int limit = 30,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "kategori": category == MusicCategory.localStorage
            ? "oynatilabilir"
            : category == MusicCategory.webStorage
                ? ""
                : category == MusicCategory.allStorage
                    ? ""
                    : "",
        "limit": limit,
        "sayfa": page,
      },
      endpoint: "0/0/${_EndpointConstants.music}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    MusicFetchResponse armoyuresponse = MusicFetchResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMusicFetch> musicList = [];
    for (var element in response['icerik']) {
      musicList.add(
        APIMusicFetch(
          musicID: element['muzikID'],
          category: category,
          name: element['muzikadi'],
          ownername: element['muzik_sahipbilgi'],
          musicURL: element['muziklink'],
          ismyfav: element['muzikfavoridurum'] == 1 ? true : false,
          listeningcount: element['muzikdinlenmesay'],
          musicImage: Media(
            mediaID: element['music_image']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['music_image']['media_bigURL'],
              normalURL: element['music_image']['media_URL'],
              minURL: element['music_image']['media_minURL'],
            ),
          ),
        ),
      );
    }
    armoyuresponse.response = musicList;

    return armoyuresponse;
  }

  Future<MusicFetchResponse> musicfavoriteList({
    required int page,
    int limit = 30,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "limit": limit,
        "sayfa": page,
      },
      endpoint: "0/0/${_EndpointConstants.musicFavorites}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    MusicFetchResponse armoyuresponse = MusicFetchResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMusicFetch> musicList = [];
    for (var element in response['icerik']) {
      musicList.add(
        APIMusicFetch(
          musicID: element['muzikID'],
          category: MusicCategory.localStorage,
          name: element['muzikadi'],
          ownername: element['muzik_sahipbilgi'],
          musicURL: element['muziklink'],
          ismyfav: element['muzikfavoridurum'] == 1 ? true : false,
          listeningcount: element['muzikdinlenmesay'],
          musicImage: Media(
            mediaID: element['music_image']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['music_image']['media_bigURL'],
              normalURL: element['music_image']['media_URL'],
              minURL: element['music_image']['media_minURL'],
            ),
          ),
        ),
      );
    }
    armoyuresponse.response = musicList;

    return armoyuresponse;
  }

  Future<MusicFetchResponse> musicSearch({required String search}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sarkibilgi": search,
      },
      endpoint: "0/0/${_EndpointConstants.musicSearch}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    MusicFetchResponse armoyuresponse = MusicFetchResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMusicFetch> musicList = [];
    for (var element in response['icerik']) {
      musicList.add(
        APIMusicFetch(
          musicID: element['muzikID'],
          category: MusicCategory.localStorage,
          name: element['muzikadi'],
          ownername: element['muzik_sahipbilgi'],
          musicURL: element['muziklink'],
          ismyfav: element['muzikfavoridurum'] == 1 ? true : false,
          listeningcount: element['muzikdinlenmesay'],
          musicImage: Media(
            mediaID: element['music_image']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['music_image']['media_bigURL'],
              normalURL: element['music_image']['media_URL'],
              minURL: element['music_image']['media_minURL'],
            ),
          ),
        ),
      );
    }
    armoyuresponse.response = musicList;

    return armoyuresponse;
  }

  Future<ServiceResult> addfavorite({required int musicID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"muzikID": musicID},
      endpoint: "0/0/${_EndpointConstants.musicaddFavorite}/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    return result;
  }

  Future<ServiceResult> removefavorite({required int musicID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"muzikID": musicID},
      endpoint: "0/0/${_EndpointConstants.musicremoveFavorite}/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    return result;
  }
}
