part of 'package:armoyu_services/armoyu_services.dart';

class SurveyServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  SurveyServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<SurveyListResponse> fetchSurveys({required int page}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"sayfa": page},
      endpoint: "0/0/${_EndpointConstants.surveylist}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    SurveyListResponse armoyuresponse = SurveyListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APISurveyList> surveyList = [];
    for (var element in response['icerik']) {
      List<Media> mediaList = [];
      for (var element2 in element['survey_media']) {
        mediaList.add(
          Media(
            mediaID: element2['media_ID'],
            mediaURL: MediaURL(
              bigURL: element2['media_bigURL'],
              normalURL: element2['media_URL'],
              minURL: element2['media_minURL'],
            ),
          ),
        );
      }

      List<SurveyOption> optionList = [];
      for (var element2 in element['survey_options']) {
        optionList.add(
          SurveyOption(
            optionId: element2['option_ID'],
            optionAnswer: element2['option_answer'],
            optionVotingPercentage:
                double.parse(element2['option_votingPercentage']),
          ),
        );
      }

      surveyList.add(
        APISurveyList(
          surveyId: element['survey_ID'],
          surveyOwner: SurveyOwner(
            ownerId: element['survey_owner']['owner_ID'],
            ownerDisplayName: element['survey_owner']['owner_displayname'],
            ownerAvatar: MediaURL(
              bigURL: element['survey_owner']['owner_avatar'],
              normalURL: element['survey_owner']['owner_avatar'],
              minURL: element['survey_owner']['owner_avatar'],
            ),
          ),
          surveyQuestion: element['survey_question'],
          surveyMedia: mediaList,
          surveyType: element['survey_type'],
          surveyStatus: element['survey_status'],
          surveyEndDate: element['survey_enddate'],
          surveyRemainingTime: element['survey_remainingtime'],
          surveyVotingPercentage:
              double.parse(element['survey_votingPercentage']),
          surveyVotingCount: element['survey_votingCount'],
          surveyOptions: optionList,
          surveyDidIVote: element['survey_didIVote'],
          surveySelectedOption: element['survey_selectedOption'],
        ),
      );
    }

    armoyuresponse.response = surveyList;

    return armoyuresponse;
  }

  Future<SurveyListResponse> fetchSurvey({required int surveyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"anketID": surveyID},
      endpoint: "0/0/${_EndpointConstants.surveylist}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    SurveyListResponse armoyuresponse = SurveyListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APISurveyList> surveyList = [];
    for (var element in response['icerik']) {
      List<Media> mediaList = [];
      for (var element2 in element['survey_media']) {
        mediaList.add(
          Media(
            mediaID: element2['media_ID'],
            mediaURL: MediaURL(
              bigURL: element2['media_bigURL'],
              normalURL: element2['media_URL'],
              minURL: element2['media_minURL'],
            ),
          ),
        );
      }

      List<SurveyOption> optionList = [];
      for (var element2 in element['survey_options']) {
        optionList.add(
          SurveyOption(
            optionId: element2['option_ID'],
            optionAnswer: element2['option_answer'],
            optionVotingPercentage:
                double.parse(element2['option_votingPercentage']),
          ),
        );
      }

      surveyList.add(
        APISurveyList(
          surveyId: element['survey_ID'],
          surveyOwner: SurveyOwner(
            ownerId: element['survey_owner']['owner_ID'],
            ownerDisplayName: element['survey_owner']['owner_displayname'],
            ownerAvatar: MediaURL(
              bigURL: element['survey_owner']['owner_avatar'],
              normalURL: element['survey_owner']['owner_avatar'],
              minURL: element['survey_owner']['owner_avatar'],
            ),
          ),
          surveyQuestion: element['survey_question'],
          surveyMedia: mediaList,
          surveyType: element['survey_type'],
          surveyStatus: element['survey_status'],
          surveyEndDate: element['survey_enddate'],
          surveyRemainingTime: element['survey_remainingtime'],
          surveyVotingPercentage:
              double.parse(element['survey_votingPercentage']),
          surveyVotingCount: element['survey_votingCount'],
          surveyOptions: optionList,
          surveyDidIVote: element['survey_didIVote'],
          surveySelectedOption: element['survey_selectedOption'],
        ),
      );
    }

    armoyuresponse.response = surveyList;
    return armoyuresponse;
  }

  Future<ServiceResult> answerSurvey({
    required int surveyID,
    required int optionID,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "anketID": surveyID,
        "secenekID": optionID,
      },
      endpoint: "0/0/${_EndpointConstants.surveyreply}/0/",
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

  Future<ServiceResult> deleteSurvey({required int surveyID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"anketID": surveyID},
      endpoint: "0/0/${_EndpointConstants.deletesurvey}/0/",
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

  Future<ServiceResult> createSurvey({
    required String surveyQuestion,
    required List<String> options,
    required String date,
  }) async {
    Map<String, String> formData = {
      "anketsoru": surveyQuestion,
      "bitiszaman": date,
      "kime": "0",
    };

    for (int i = 0; i < options.length; i++) {
      formData['secenekler[$i]'] = options[i];
    }

    Map<String, dynamic> response = await _apiHelpers.post(
      body: formData,
      endpoint: "0/0/${_EndpointConstants.createsurvey}/0/",
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
