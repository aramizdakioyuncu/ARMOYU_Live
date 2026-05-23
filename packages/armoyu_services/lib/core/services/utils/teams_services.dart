part of 'package:armoyu_services/armoyu_services.dart';

class TeamsServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  TeamsServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<TeamListResponse> fetch() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.teamslist}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    TeamListResponse armoyuresponse = TeamListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APITeamList> teamList = [];
    for (var element in response['icerik']) {
      teamList.add(
        APITeamList(
          teamId: element['takim_ID'],
          teamName: element['takim_adi'],
          teamLogo: MediaURL(
            bigURL: element['takim_logo'],
            normalURL: element['takim_logo'],
            minURL: element['takim_logo'],
          ),
        ),
      );
    }
    armoyuresponse.response = teamList;
    return armoyuresponse;
  }
}
