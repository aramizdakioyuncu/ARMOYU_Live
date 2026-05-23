part of 'package:armoyu_services/armoyu_services.dart';

class CrewServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  CrewServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<CrewResponse> fetch({required int page, String? category}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: category != null
          ? {"sayfa": page, "category": category}
          : {"sayfa": page},
      endpoint: "0/0/${_EndpointConstants.crew}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    CrewResponse armoyuresponse = CrewResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APICrewList> countryList = [];
    for (var element in response['icerik']) {
      countryList.add(
        APICrewList(
          id: element['#'],
          playerID: element['player_ID'],
          username: element['player_username'],
          displayName: element['player_displayname'],
          avatar: MediaURL(
            bigURL: element['player_avatar']['media_bigURL'],
            normalURL: element['player_avatar']['media_URL'],
            minURL: element['player_avatar']['media_minURL'],
          ),
          socialAccounts: SocialAccounts(
            facebook: element['player_social']['facebook'],
            youtube: element['player_social']['youtube'],
            twitch: element['player_social']['twitch'],
            instagram: element['player_social']['instagram'],
            steam: element['player_social']['steam'],
            linkedin: element['player_social']['linkedin'],
            reddit: element['player_social']['reddit'],
            github: element['player_social']['github'],
          ),
          role: UserRole(
            roleID: element['player_role']['roleID'],
            roleName: element['player_role']['roleName'],
            roleCategory: element['player_role']['rolecategory'],
            roleColor: element['player_role']['roleColor'],
          ),
        ),
      );
    }
    armoyuresponse.response = countryList;

    return armoyuresponse;
  }
}
