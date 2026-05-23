part of 'package:armoyu_services/armoyu_services.dart';

class CountryServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  CountryServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<CountryResponse> countryfetch() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      endpoint: "0/0/${_EndpointConstants.countries}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    CountryResponse armoyuresponse = CountryResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APICountry> countryList = [];
    for (var element in response['icerik']) {
      countryList.add(
        APICountry(
          countryID: element['country_ID'],
          name: element['country_name'],
          code: element['country_code'],
          phonecode: element['country_phoneCode'],
        ),
      );
    }
    armoyuresponse.response = countryList;

    return armoyuresponse;
  }

  Future<ProvinceResponse> fetchprovince({required int countryID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"countryID": countryID},
      endpoint: "0/0/${_EndpointConstants.provinces}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    ProvinceResponse armoyuresponse = ProvinceResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIProvince> provinceList = [];
    for (var element in response['icerik']) {
      provinceList.add(APIProvince(
        provinceID: element['province_ID'],
        name: element['province_name'],
        platecode: element['province_plateCode'],
        phonecode: element['province_phoneCode'],
      ));
    }
    armoyuresponse.response = provinceList;
    return armoyuresponse;
  }
}
