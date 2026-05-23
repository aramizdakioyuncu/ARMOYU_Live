part of 'package:armoyu_services/armoyu_services.dart';

class RulesServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  RulesServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<RulesResponse> fetch({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": page},
      endpoint: "0/0/${_EndpointConstants.rules}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    RulesResponse armoyuresponse = RulesResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIRules> rules = [];
    for (var element in response['icerik']) {
      rules.add(
        APIRules(
          ruleId: element['kuralid'],
          content: element['kuralicerik'],
          penaltyDuration: element['cezabaslangic'],
          penaltyDate: element['cezakoyulmatarihi'],
          subRule: element['kuralaltmadde'],
        ),
      );
    }
    armoyuresponse.response = rules;

    return armoyuresponse;
  }
}
