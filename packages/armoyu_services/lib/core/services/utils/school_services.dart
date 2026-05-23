part of 'package:armoyu_services/armoyu_services.dart';

class SchoolServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  SchoolServices({
    required this.getToken,
    required this.setToken,
    required this.apiKey,
    required this.usePreviousAPI,
  }) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<SchoolFetchListResponse> getschools() async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {},
      endpoint: "0/0/${_EndpointConstants.getschools}/0/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );

    SchoolFetchListResponse armoyuresponse =
        SchoolFetchListResponse(result: result);

    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APISchoolList> schoolList = [];
    for (var element in response['icerik']) {
      schoolList.add(
        APISchoolList(
          schoolID: element['ID'],
          value: element['Value'],
          schoolURL: element['okul_URL'],
          schoolLogo: MediaURL(
            bigURL: element['okul_logo'],
            normalURL: element['okul_ufaklogo'],
            minURL: element['okul_minnaklogo'],
          ),
          memberCount: element['okul_uyesayisi'],
        ),
      );
    }
    armoyuresponse.response = schoolList;

    return armoyuresponse;
  }

  Future<SchoolFetchDetailResponse> fetchSchool({required int schoolID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"okulID": schoolID},
      endpoint: "0/0/${_EndpointConstants.fetchSchool}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );

    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    SchoolFetchDetailResponse armoyuresponse =
        SchoolFetchDetailResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    armoyuresponse.response = APISchoolDetail(
      schoolID: response['icerik']['school_ID'],
      schoolName: response['icerik']['school_name'],
      schoolShortName: response['icerik']['school_shortname'],
      schoolURL: response['icerik']['school_URL'],
      schoolAbout: response['icerik']['school_about'],
      schoolLogo: Media(
        mediaID: response['icerik']['school_logo']['media_ID'],
        mediaURL: MediaURL(
          bigURL: response['icerik']['school_logo']['media_bigURL'],
          normalURL: response['icerik']['school_logo']['media_URL'],
          minURL: response['icerik']['school_logo']['media_minURL'],
        ),
      ),
      schoolBanner: Media(
        mediaID: response['icerik']['school_banner']['media_ID'],
        mediaURL: MediaURL(
          bigURL: response['icerik']['school_banner']['media_bigURL'],
          normalURL: response['icerik']['school_banner']['media_URL'],
          minURL: response['icerik']['school_banner']['media_minURL'],
        ),
      ),
    );

    return armoyuresponse;
  }

  Future<ServiceResult> joinWorkstation({
    required String workstationID,
    required String classID,
    required String jobID,
    required String classPassword,
  }) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {
        "isyeriidi": workstationID,
        "hangisinif": classID,
        "hangibrans": jobID,
        "sinifsifresi": classPassword,
      },
      endpoint: "0/0/${_EndpointConstants.joinworkstation}/0/",
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

  Future<StationFetchDetailResponse> fetchWorkstationDetail(
      {required String workStationID}) async {
    Map<String, dynamic> response = await _apiHelpers.post(
      body: {"hangisyeri": workStationID},
      endpoint: "0/0/${_EndpointConstants.workstationdetail}/0/",
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
    ServiceResult result = ServiceResult(
      status: response['durum'] == 1 ? true : false,
      description: response['aciklama'],
      descriptiondetail: response['aciklamadetay'],
    );
    StationFetchDetailResponse armoyuresponse =
        StationFetchDetailResponse(result: result);
    if (response['durum'] == 0) {
      return armoyuresponse;
    }

    List<APIStationDetail> workstationList = [];
    for (var element in response['icerik']) {
      workstationList.add(
        APIStationDetail(
          id: element['ID'],
          value: element['Value'],
        ),
      );
    }
    armoyuresponse.response = workstationList;

    return armoyuresponse;
  }
}
