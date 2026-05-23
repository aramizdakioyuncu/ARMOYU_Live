part of 'package:armoyu_services/armoyu_services.dart';

class StationServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  StationServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<StationFetchListResponse> fetchStations() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.stations}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StationFetchListResponse armoyuresponse =
        StationFetchListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIStationList> stationList = [];
    for (var element in response['icerik']) {
      stationList.add(
        APIStationList(
          stationID: element['station_ID'],
          stationName: element['station_name'],
          stationUrl: element['station_URL'],
          stationType: element['station_type'],
          stationUyeSayisi: element['station_uyesayisi'],
          stationLogo: Media(
            mediaID: element['station_logo']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['station_logo']['media_bigURL'],
              normalURL: element['station_logo']['media_URL'],
              minURL: element['station_logo']['media_minURL'],
            ),
          ),
          stationBanner: Media(
            mediaID: element['station_banner']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['station_banner']['media_bigURL'],
              normalURL: element['station_banner']['media_URL'],
              minURL: element['station_banner']['media_minURL'],
            ),
          ),
        ),
      );
    }
    armoyuresponse.response = stationList;
    return armoyuresponse;
  }

  Future<StationFetchListResponse> fetchfoodstation() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"kategori": "yemek"},
      endpoint: "0/0/${_EndpointConstants.stations}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StationFetchListResponse armoyuresponse =
        StationFetchListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    List<APIStationList> stationList = [];
    for (var element in response['icerik']) {
      stationList.add(
        APIStationList(
          stationID: element['station_ID'],
          stationName: element['station_name'],
          stationUrl: element['station_URL'],
          stationType: element['station_type'],
          stationUyeSayisi: element['station_uyesayisi'],
          stationLogo: Media(
            mediaID: element['station_logo']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['station_logo']['media_bigURL'],
              normalURL: element['station_logo']['media_URL'],
              minURL: element['station_logo']['media_minURL'],
            ),
          ),
          stationBanner: Media(
            mediaID: element['station_banner']['media_ID'],
            mediaURL: MediaURL(
              bigURL: element['station_banner']['media_bigURL'],
              normalURL: element['station_banner']['media_URL'],
              minURL: element['station_banner']['media_minURL'],
            ),
          ),
        ),
      );
    }
    armoyuresponse.response = stationList;
    return armoyuresponse;
  }

  Future<StationFetchEquipmentListResponse> fetchEquipments(
      {required int stationID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"istasyonID": stationID},
      endpoint: "0/0/${_EndpointConstants.stationequipments}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StationFetchEquipmentListResponse armoyuresponse =
        StationFetchEquipmentListResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }
    List<APIStationEquipmentList> equipmentList = [];

    for (var element in response['icerik']) {
      equipmentList.add(
        APIStationEquipmentList(
          equipmentId: element['equipment_ID'],
          equipmentName: element['equipment_name'],
          equipmentType: element['equipment_type'],
          equipmentImage: MediaURL(
            bigURL: element['equipment_image'],
            normalURL: element['equipment_image'],
            minURL: element['equipment_image'],
          ),
          equipmentPrice: element['equipment_price'],
        ),
      );
    }
    armoyuresponse.response = equipmentList;
    return armoyuresponse;
  }
}
