part of 'package:armoyu_services/armoyu_services.dart';

class BlockingServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  BlockingServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<BlockingListResponse> list() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.blockinglist}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    BlockingListResponse armoyuresponse = BlockingListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIBlockingList> blockedList = [];
    for (var element in response['icerik']) {
      blockedList.add(
        APIBlockingList(
          blockID: element['engel_ID'],
          blockeduser: UserInfo(
            userID: element['engel_kimeID'],
            displayname: element['engel_kime'],
            username: element['engel_kadi'],
            avatar: MediaURL(
              bigURL: element['engel_avatar'],
              normalURL: element['engel_avatar'],
              minURL: element['engel_avatar'],
            ),
          ),
          date: element['engel_zaman'],
        ),
      );
    }
    armoyuresponse.response = blockedList;

    return armoyuresponse;
  }

  Future<BlockingAddResponse> add({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.bloclistadd}/0",
      body: {"userID": userID},
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    BlockingAddResponse armoyuresponse = BlockingAddResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    return armoyuresponse;
  }

  Future<BlockingRemoveResponse> remove({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"userID": userID},
      endpoint: "0/0/${_EndpointConstants.bloclistremove}/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    BlockingRemoveResponse armoyuresponse =
        BlockingRemoveResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    return armoyuresponse;
  }
}
