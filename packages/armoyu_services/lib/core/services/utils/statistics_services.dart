part of 'package:armoyu_services/armoyu_services.dart';

class StatisticsServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  StatisticsServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<StatisticsListResponse> fetch({required String category}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"category": category},
      endpoint: "0/0/${_EndpointConstants.statistics}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StatisticsListResponse armoyuresponse =
        StatisticsListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIStatisticsList> statisticsList = [];
    var element = response['icerik'];

    //hours
    List<String> hourstitles = [];
    List<String?> hoursvalues = [];
    for (var titles in element['hours']['titles']) {
      hourstitles.add(titles);
    }
    for (var values in element['hours']['values']) {
      hoursvalues.add(values);
    }

    //days
    List<String> daystitles = [];
    List<String?> daysvalues = [];
    for (var titles in element['days']['titles']) {
      daystitles.add(titles);
    }
    for (var values in element['days']['values']) {
      daysvalues.add(values);
    }

    //month
    List<String> monthtitles = [];
    List<String?> monthvalues = [];
    for (var titles in element['month']['titles']) {
      monthtitles.add(titles);
    }
    for (var values in element['month']['values']) {
      monthvalues.add(values);
    }

    statisticsList.add(
      APIStatisticsList(
        hours: TimeCategory(
          titles: hourstitles,
          values: hoursvalues,
          totalValue: element['hours']['totalvalue'],
          percentage: element['hours']['percentage'],
        ),
        days: TimeCategory(
          titles: daystitles,
          values: daysvalues,
          totalValue: element['days']['totalvalue'],
          percentage: element['days']['percentage'],
        ),
        month: TimeCategory(
          titles: monthtitles,
          values: monthvalues,
          totalValue: element['month']['totalvalue'],
          percentage: element['month']['percentage'],
        ),
      ),
    );

    armoyuresponse.response = statisticsList;
    return armoyuresponse;
  }
}
