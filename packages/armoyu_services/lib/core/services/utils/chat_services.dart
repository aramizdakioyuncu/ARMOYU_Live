part of 'package:armoyu_services/armoyu_services.dart';

class ChatServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  ChatServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<ChatListResponse> currentChatList({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": page,
        "limit": "30",
      },
      endpoint: "0/0/${_EndpointConstants.chat}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ChatListResponse armoyuresponse = ChatListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIChatList> chatList = [];
    for (var element in response['icerik']) {
      chatList.add(
        APIChatList(
          kullID: element['kullid'],
          adSoyad: element['adisoyadi'],
          kullAdi: element['kulladi'],
          bildirim: element['bildirim'],
          sonGiris: element['songiris'],
          sonMesaj: element['sonmesaj'],
          sohbetTuru:
              element['sohbetturu'] == "ozel" ? APIChat.ozel : APIChat.grup,
          chatImage: Media(
            mediaID: element['chatImage']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['chatImage']['media_bigURL'],
              normalURL: element['chatImage']['media_URL'],
              minURL: element['chatImage']['media_minURL'],
            ),
          ),
        ),
      );
    }

    armoyuresponse.response = chatList;
    return armoyuresponse;
  }

  Future<ChatNewListResponse> newChatlist({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": page,
        "limit": "30",
      },
      endpoint: "0/0/${_EndpointConstants.chatfriends}/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    ChatNewListResponse armoyuresponse = ChatNewListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIChatList> newchatList = [];
    for (var element in response['icerik']) {
      newchatList.add(
        APIChatList(
          kullID: element['kullid'],
          adSoyad: element['adisoyadi'],
          kullAdi: element['kulladi'],
          bildirim: element['bildirim'],
          sonGiris: element['songiris'],
          sonMesaj: element['sonmesaj'],
          sohbetTuru:
              element['sohbetturu'] == "ozel" ? APIChat.ozel : APIChat.grup,
          chatImage: Media(
            mediaID: element['chatImage']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['chatImage']['media_bigURL'],
              normalURL: element['chatImage']['media_URL'],
              minURL: element['chatImage']['media_minURL'],
            ),
          ),
        ),
      );
    }

    armoyuresponse.response = newchatList;

    return armoyuresponse;
  }

  Future<ChatFetchDetailResponse> fetchdetailChat(
      {required int chatID, required APIChat chatCategory}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sohbetID": chatID,
        "sohbetturu": chatCategory.name,
      },
      endpoint: "0/0/${_EndpointConstants.chatdetail}/0/0",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ChatFetchDetailResponse armoyuresponse =
        ChatFetchDetailResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIChatDetailList> chatdetailList = [];
    for (var element in response['icerik']) {
      chatdetailList.add(
        APIChatDetailList(
          sohbetKim: element['sohbetkim'],
          renkKodu: element['renkkodu'],
          adSoyad: element['adsoyad'],
          avatar: element['avatar'],
          mesajIcerik: element['mesajicerik'],
          zaman: element['zaman'],
          zamanTarih: element['zamantarih'],
          zamanSaat: element['zamansaat'],
          durum: element['durum'],
        ),
      );
    }

    armoyuresponse.response = chatdetailList;
    return armoyuresponse;
  }

  Future<ServiceResult> sendchatmessage({
    required int userID,
    required String message,
    required String type,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "oyuncubakid": "$userID",
        "icerik": message,
        "turu": type,
      },
      endpoint: "0/0/${_EndpointConstants.chatsend}/0/0",
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
