part of 'package:armoyu_services/armoyu_services.dart';

enum APIMediaType { video, image, sound, all }

class MediaServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  MediaServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<MediaFetchResponse> fetch({
    int? userID,
    String? username,
    APIMediaType category = APIMediaType.all,
    required int page,
    int limit = 30,
  }) async {
    if (userID == null && username == null) {
      return MediaFetchResponse(
          result: ServiceResult(
        description: "userID or username is required",
      ));
    }

    Map<String, dynamic> response = await _apiHelpers.post(
      body: userID != null
          ? {
              "oyuncubakid": userID,
              "kategori": category == APIMediaType.all ? "-1" : category.name,
              "limit": limit,
              "sayfa": page,
            }
          : username == null
              ? {
                  "oyuncubakid": username,
                  "kategori":
                      category == APIMediaType.all ? "-1" : category.name,
                  "limit": limit,
                  "sayfa": page,
                }
              : {
                  "kategori":
                      category == APIMediaType.all ? "-1" : category.name,
                  "limit": limit,
                  "sayfa": page,
                },
      endpoint: "0/0/${_EndpointConstants.media}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    MediaFetchResponse armoyuresponse = MediaFetchResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMediaFetch> mediaList = [];
    for (var element in response['icerik']) {
      mediaList.add(
        APIMediaFetch(
          mediaOwner: MediaOwner(
            userID: element['media_ownerID'],
            displayname: element['media_ownerusername'],
            avatar: MediaURL(
              bigURL: element['media_owneravatar'],
              normalURL: element['media_owneravatar'],
              minURL: element['media_owneravatar'],
            ),
          ),
          mediaDate: element['media_time'],
          mediaSize: element['media_size'],
          category: element['fotokategori'],
          fotoPaylas: element['fotopaylas'],
          mediatype: element['fotodosyatipi'],
          media: Media(
            mediaID: element['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['fotoorijinalurl'],
              normalURL: element['fotoufaklikurl'],
              minURL: element['fotominnakurl'],
            ),
          ),
        ),
      );
    }
    armoyuresponse.response = mediaList;

    return armoyuresponse;
  }

  Future<MediaRotationResponse> rotation({
    required int mediaID,
    required double rotate,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "fotografID": "$mediaID",
        "derece": "$rotate",
      },
      endpoint: "0/0/${_EndpointConstants.mediaturn}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    MediaRotationResponse armoyuresponse =
        MediaRotationResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    return armoyuresponse;
  }

  Future<MediaDeleteResponse> delete({required int mediaID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "medyaID": "$mediaID",
      },
      endpoint: "0/0/${_EndpointConstants.mediadelete}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    MediaDeleteResponse armoyuresponse = MediaDeleteResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    return armoyuresponse;
  }

  Future<MediaUploadResponse> upload({
    required List<XFile> files,
    required String category,
  }) async {
    List<http.MultipartFile> photosCollection = [];
    for (XFile element in files) {
      photosCollection.add(
        await _apiHelpers.generateImageFile(
          "media[]",
          element,
        ),
      );
    }

    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"category": category},
      files: photosCollection,
      endpoint: "0/0/${_EndpointConstants.mediaupload}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    MediaUploadResponse armoyuresponse = MediaUploadResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMediaUpload> medialist = [];
    for (var element in response['icerik']) {
      medialist.add(
        APIMediaUpload(
          status: element['durum'],
          mediaID: element['media_ID'],
          description: element['aciklama'],
          filetype: element['dosyatipi'],
          filecategory: element['fotokategori'],
          mediaURL: MediaURL(
            bigURL: element['orijinallink'],
            normalURL: element['ufakliklink'],
            minURL: element['minnaklink'],
          ),
        ),
      );
    }
    armoyuresponse.response = medialist;

    return armoyuresponse;
  }
}
