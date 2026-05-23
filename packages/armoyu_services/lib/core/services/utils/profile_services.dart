part of 'package:armoyu_services/armoyu_services.dart';

class ProfileServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  ProfileServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<ProfileInviteListResponse> invitelist({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "sayfa": page,
        "limit": "30",
      },
      endpoint: "0/0/${_EndpointConstants.invitelist}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ProfileInviteListResponse armoyuresponse =
        ProfileInviteListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIProfileInvitelist> usersList = [];
    for (var element in response['icerik']) {
      usersList.add(
        APIProfileInvitelist(
          userID: element['oyuncu_ID'],
          avatar: MediaURL(
            bigURL: element['oyuncu_avatar'],
            normalURL: element['oyuncu_avatar'],
            minURL: element['oyuncu_avatar'],
          ),
          displayName: element['oyuncu_displayname'],
          username: element['oyuncu_username'],
          isVerified: element['oyuncu_dogrulama'],
          verificationTime: element['oyuncu_dogrulamazaman'],
          membershipDuration: element['oyuncu_zaman'],
        ),
      );
    }

    armoyuresponse.response = usersList;
    return armoyuresponse;
  }

  Future<ServiceResult> sendauthmailURL({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"userID": "$userID"},
      endpoint: "0/0/${_EndpointConstants.sendauthmail}/",
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

  Future<ServiceResult> invitecoderefresh() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.invitecoderefresh}/0/",
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

  Future<ProfileFriendListResponse> friendlist({
    required int userID,
    required int page,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "oyuncubakid": userID,
        "sayfa": "$page",
        "limit": "50",
      },
      endpoint: "0/0/${_EndpointConstants.friendlist}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ProfileFriendListResponse armoyuresponse =
        ProfileFriendListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIProfileFriendlist> friendList = [];

    for (var element in response['icerik']) {
      friendList.add(
        APIProfileFriendlist(
          playerID: element['oyuncuID'],
          avatar: MediaURL(
            bigURL: element['oyuncuavatar'],
            normalURL: element['oyuncufakavatar'],
            minURL: element['oyuncuminnakavatar'],
          ),
          playerLink: element['oyunculink'],
          displayName: element['oyuncuad'],
          username: element['oyuncukullaniciad'],
          level: element['oyunculevel'],
          status: element['oyuncudurum'],
          lastLogin: element['songiris'],
          friendshipStatus: element['oyuncuarkadasdurum'],
        ),
      );
    }

    armoyuresponse.response = friendList;
    return armoyuresponse;
  }

  Future<ServiceResult> friendrequest({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"oyuncubakid": userID},
      endpoint: "0/0/${_EndpointConstants.friendrequest}/0/",
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

  Future<ServiceResult> friendrequestanswer({
    required int userID,
    required int answer,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "oyuncubakid": userID,
        "cevap": answer,
      },
      endpoint: "0/0/${_EndpointConstants.friendrequestanswer}/0/0/",
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

  Future<ServiceResult> userdurting({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"oyuncubakid": userID},
      endpoint: "0/0/${_EndpointConstants.userdurting}/0/0/",
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

  Future<ServiceResult> friendremove({required int userID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "oyuncubakid": userID,
      },
      endpoint: "0/0/${_EndpointConstants.friendremove}/0/0/",
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

  Future<ServiceResult> defaultavatar() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.defaultavatar}/0/0/",
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

  Future<ServiceResult> defaultbanner() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.defaultbanner}/0/0/",
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

  Future<ServiceResult> changeavatar({required List<XFile> files}) async {
    List<http.MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection.add(await _apiHelpers.generateImageFile("resim", file));
    }
    Map<String, dynamic> response = await _apiHelpers.post(
      files: photosCollection,
      endpoint: "0/0/${_EndpointConstants.changeavatar}/0/0/",
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

  Future<ServiceResult> changebanner({required List<XFile> files}) async {
    List<http.MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection.add(await _apiHelpers.generateImageFile("resim", file));
    }
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      files: photosCollection,
      endpoint: "0/0/${_EndpointConstants.changebanner}/0/0/",
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

  Future<ServiceResult> selectfavteam({int? teamID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"favoritakimID": "$teamID"},
      endpoint: "0/0/${_EndpointConstants.selectfavteam}/0/",
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

  Future<ServiceResult> saveprofiledetails({
    required String firstname,
    required String lastname,
    required String aboutme,
    required String email,
    required String countryID,
    required String provinceID,
    required String birthday,
    required String phoneNumber,
    required String passwordControl,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "ad": firstname,
        "soyad": lastname,
        "about": aboutme,
        "hakkimda": lastname,
        "email": email,
        "countryID": countryID,
        "provinceID": provinceID,
        "birthday": birthday,
        "phoneNumber": phoneNumber,
        "passwordControl": passwordControl,
        "v1": "1",
      },
      endpoint: "0/0/${_EndpointConstants.saveprofiledetails}/0/",
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

  Future<APIMyGroupListResponse> myGroups() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.mygroups}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    APIMyGroupListResponse armoyuresponse =
        APIMyGroupListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMyGroupList> groupList = [];
    for (var element in response['icerik']) {
      groupList.add(
        APIMyGroupList(
          groupID: element['group_ID'],
          groupName: element['group_name'],
          groupShortName: element['group_shortname'],
          groupJoinStatus: element['group_joinstatus'],
          groupDescription: element['group_description'],
          groupSocial: MyGroupSocial(
            groupWebsite: element['group_social']['group_website'],
            groupDiscord: element['group_social']['group_discord'],
          ),
          groupURL: element['group_URL'],
          groupUserCount: element['group_usercount'],
          groupLogo: Media(
            mediaID: element['group_logo']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['group_logo']['media_bigURL'],
              normalURL: element['group_logo']['media_URL'],
              minURL: element['group_logo']['media_minURL'],
            ),
          ),
          groupBanner: Media(
            mediaID: element['group_banner']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['group_banner']['media_bigURL'],
              normalURL: element['group_banner']['media_URL'],
              minURL: element['group_banner']['media_minURL'],
            ),
          ),
          groupMyRole: MyGroupMyRole(
            owner: element['group_myRole']['owner'],
            userInvite: element['group_myRole']['user_invite'],
            userKick: element['group_myRole']['user_kick'],
            userRole: element['group_myRole']['user_role'],
            groupSettings: element['group_myRole']['group_settings'],
            groupFiles: element['group_myRole']['group_files'],
            groupEvents: element['group_myRole']['group_events'],
            groupRole: element['group_myRole']['group_role'],
            groupSurvey: element['group_myRole']['group_survey'],
          ),
        ),
      );
    }

    armoyuresponse.response = groupList;
    return armoyuresponse;
  }

  Future<APIMySchoolListResponse> mySchools() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.myschools}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    APIMySchoolListResponse armoyuresponse =
        APIMySchoolListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIMySchoolList> myschoolList = [];

    for (var element in response['icerik']) {
      myschoolList.add(
        APIMySchoolList(
          schoolID: element['school_ID'],
          schoolName: element['school_name'],
          schoolURL: element['school_URL'],
          schoolUserCount: element['school_usercount'],
          schoolLogo: Media(
            mediaID: element['school_logo']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['school_logo']['media_bigURL'],
              normalURL: element['school_logo']['media_URL'],
              minURL: element['school_logo']['media_minURL'],
            ),
          ),
          schoolBanner: Media(
            mediaID: element['school_banner']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['school_banner']['media_bigURL'],
              normalURL: element['school_banner']['media_URL'],
              minURL: element['school_banner']['media_minURL'],
            ),
          ),
        ),
      );
    }

    armoyuresponse.response = myschoolList;

    return armoyuresponse;
  }

  Future<ServiceResult> myStations() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.mystations}/0/0/",
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
