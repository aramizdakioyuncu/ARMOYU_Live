import 'package:armoyu_services/core/models/ARMOYU/API/category/category.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_detail_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/controlpanel/controlpanel_meetinglist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/controlpanel/controlpanel_userslist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/country.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/province.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/crew/crew_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event_participant.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_media.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room_chat.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_user.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/joinus/joinus_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/joinus/joinus_permission_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/invitecode.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/media/media_fetch.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/media/media_upload.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/music/music_fetch.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/news/news_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_setting_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/profile/profile_friendlist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/profile/profile_invitelist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/reels/reels.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/rules/rules.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/school/school_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/school/school_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_hashtaglist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/search/search_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/station/station_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/station/station_equipment_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/station/station_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/statistics/statistics_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/story/story_likelist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/story/story_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/story/story_viewlist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/survey/survey_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/team/team_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/foreign_currency_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/games_on_sale.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/minecraft_statistics.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/my_group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/my_school_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/new_registered_users.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/super_lig.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/weather_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/blocking/blocking_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_services/core/models/ARMOYU/sitemessage.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart';
import 'package:armoyu_services/export.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
export 'package:armoyu_services/export.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart' as path_provider;

part 'core/services/logging/logging_services.dart';
part 'core/services/auth/auth_services.dart';
part 'core/services/user/user_services.dart';

part 'core/services/utils/about_services.dart';
part 'core/services/utils/app_services.dart';
part 'core/services/utils/blocking_services.dart';
part 'core/services/utils/category_services.dart';
part 'core/services/utils/chat_services.dart';
part 'core/services/utils/country_services.dart';
part 'core/services/utils/crew_services.dart';
part 'core/services/utils/event_services.dart';
part 'core/services/utils/group_services.dart';

part 'core/services/utils/joinus_services.dart';
part 'core/services/utils/loginregister_services.dart';
part 'core/services/utils/media_services.dart';
part 'core/services/utils/music_services.dart';
part 'core/services/utils/news_services.dart';
part 'core/services/utils/notification_services.dart';
part 'core/services/utils/posts_services.dart';
part 'core/services/utils/profile_services.dart';
part 'core/services/utils/reels_services.dart';

part 'core/services/utils/rules_services.dart';
part 'core/services/utils/school_services.dart';
part 'core/services/utils/search_services.dart';
part 'core/services/utils/station_services.dart';
part 'core/services/utils/statistics_services.dart';
part 'core/services/utils/story_services.dart';
part 'core/services/utils/survey_services.dart';
part 'core/services/utils/teams_services.dart';
part 'core/services/utils/controlpanel_services.dart';

part 'core/services/utils/utils_services.dart';
part 'core/helpers/api_helpers.dart';
part 'core/constants/endpoint_constants.dart';

class ARMOYUServices {
  late final AuthServices authServices;
  late final UserServices userServices;
  late final UtilsServices utilsServices;

  late final AboutServices aboutServices;

  late final AppServices appServices;
  late final BlockingServices blockingServices;
  late final CategoryServices categoryServices;
  late final ChatServices chatServices;
  late final CountryServices countryServices;
  late final CrewServices crewServices;
  late final EventServices eventServices;
  late final GroupServices groupServices;

  late final JoinUsServices joinusServices;
  late final LoginRegisterServices loginRegisterServices;
  late final MediaServices mediaServices;
  late final MusicServices musicServices;
  late final NewsServices newsServices;
  late final NotificationServices notificationServices;
  late final PostsServices postsServices;
  late final ProfileServices profileServices;
  late final ReelsServices reelsServices;
  late final RulesServices rulesServices;
  late final SchoolServices schoolServices;
  late final SearchServices searchServices;
  late final StationServices stationServices;
  late final StatisticsServices statisticsServices;
  late final StoryServices storyServices;
  late final SurveyServices surveyServices;
  late final TeamsServices teamsServices;
  late final ControlpanelServices controlpanelServices;

//WİDGETSLIST
  final List<APISearchDetail> peopleList = [];
  final List<APISearcHashtagDetail> hashtagList = [];

  void addpeopleList({required APISearchDetail newPerson}) {
    if (!peopleList.any((person) => person.id == newPerson.id)) {
      peopleList.add(newPerson);
    } else {
      log("Kişi zaten listede bulunmaktadır.");
    }
  }

  void addhashtagList({required APISearcHashtagDetail newHashtag}) {
    if (!hashtagList
        .any((hashtag) => hashtag.hashtagID == newHashtag.hashtagID)) {
      hashtagList.add(newHashtag);
    } else {
      log("Hashtag zaten listede bulunmaktadır.");
    }
  }
//

  final String apiKey;

  String? _token;
  String? get _getToken => _token;
  set token(String? value) => _token = value;

  ARMOYUServices({required this.apiKey, bool usePreviousAPI = false}) {
    authServices = AuthServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    userServices = UserServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    utilsServices = UtilsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    aboutServices = AboutServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    appServices = AppServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    blockingServices = BlockingServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    categoryServices = CategoryServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );
    chatServices = ChatServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    countryServices = CountryServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    crewServices = CrewServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    eventServices = EventServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    groupServices = GroupServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );
//

    joinusServices = JoinUsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    loginRegisterServices = LoginRegisterServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    mediaServices = MediaServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    musicServices = MusicServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );
    newsServices = NewsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    notificationServices = NotificationServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    postsServices = PostsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    profileServices = ProfileServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    reelsServices = ReelsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    rulesServices = RulesServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    schoolServices = SchoolServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    searchServices = SearchServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    stationServices = StationServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );
    statisticsServices = StatisticsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    storyServices = StoryServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    surveyServices = SurveyServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );

    teamsServices = TeamsServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );
    controlpanelServices = ControlpanelServices(
      getToken: () => _getToken,
      setToken: (String? tkn) => token = tkn,
      apiKey: apiKey,
      usePreviousAPI: usePreviousAPI,
    );
  }

  Future<bool> setup() async {
    return await _LoggingServices.instance.setup(service: this);
  }
}
