import 'package:armoyu_services/core/models/ARMOYU/API/blocking/blocking_add.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/blocking/blocking_remove.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/blocking/blocking_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/category/category.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_detail_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/controlpanel/controlpanel_meetinglist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/controlpanel/controlpanel_userslist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/country.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/province.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/crew/crew_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event_joinorleave.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event_participant.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_create.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_invite_answer.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_media.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_request.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room_chat.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_user.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_user_kick.dart';
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
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_xp_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/super_lig.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/weather_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_services/core/models/ARMOYU/sitemessage.dart';

class SitemessageResponse {
  final ServiceResult result;
  Sitemessage? response;
  SitemessageResponse({required this.result, this.response});
}

// #Blocking
class BlockingListResponse {
  final ServiceResult result;
  List<APIBlockingList>? response;
  BlockingListResponse({required this.result, this.response});
}

class BlockingAddResponse {
  final ServiceResult result;
  APIBlockingAdd? response;
  BlockingAddResponse({required this.result, this.response});
}

class BlockingRemoveResponse {
  final ServiceResult result;
  APIBlockingRemove? response;
  BlockingRemoveResponse({required this.result, this.response});
}

// #Category
class CategoryResponse {
  final ServiceResult result;
  List<APICategory>? response;
  CategoryResponse({required this.result, this.response});
}

// #Chat
class ChatListResponse {
  final ServiceResult result;
  List<APIChatList>? response;
  ChatListResponse({required this.result, this.response});
}

class ChatNewListResponse {
  final ServiceResult result;
  List<APIChatList>? response;
  ChatNewListResponse({required this.result, this.response});
}

class ChatFetchDetailResponse {
  final ServiceResult result;
  List<APIChatDetailList>? response;
  ChatFetchDetailResponse({required this.result, this.response});
}

// #Country
class CountryResponse {
  final ServiceResult result;
  List<APICountry>? response;
  CountryResponse({required this.result, this.response});
}

//Crew
class CrewResponse {
  final ServiceResult result;
  List<APICrewList>? response;
  CrewResponse({required this.result, this.response});
}

// #Province
class ProvinceResponse {
  final ServiceResult result;
  List<APIProvince>? response;
  ProvinceResponse({required this.result, this.response});
}

// #Event
class EventResponse {
  final ServiceResult result;
  List<APIEvent>? response;
  EventResponse({required this.result, this.response});
}

class EventDetailResponse {
  final ServiceResult result;
  APIEventDetail? response;
  EventDetailResponse({required this.result, this.response});
}

class EventJoinorLeaveResponse {
  final ServiceResult result;
  APIEventJoinorleave? response;
  EventJoinorLeaveResponse({required this.result, this.response});
}

class EventParticipantResponse {
  final ServiceResult result;
  APIEventParticipant? response;
  EventParticipantResponse({required this.result, this.response});
}

// #Group
class GroupListResponse {
  final ServiceResult result;
  APIGroupList? response;
  GroupListResponse({required this.result, this.response});
}

class GroupDetailResponse {
  final ServiceResult result;
  APIGroupDetail? response;
  GroupDetailResponse({required this.result, this.response});
}

class GroupUsersResponse {
  final ServiceResult result;
  APIGroupUser? response;
  GroupUsersResponse({required this.result, this.response});
}

class GroupLeaveResponse {
  final ServiceResult result;
  APIGroupUser? response;
  GroupLeaveResponse({required this.result, this.response});
}

class GroupSettingsResponse {
  final ServiceResult result;
  APIGroupUser? response;
  GroupSettingsResponse({required this.result, this.response});
}

class GroupChangeMediaResponse {
  final ServiceResult result;
  APIGroupMedia? response;
  GroupChangeMediaResponse({required this.result, this.response});
}

class GroupRequestAnswerResponse {
  final ServiceResult result;
  APIGroupRequest? response;
  GroupRequestAnswerResponse({required this.result, this.response});
}

class GroupUserInviteResponse {
  final ServiceResult result;
  APIGroupInviteAnswer? response;
  GroupUserInviteResponse({required this.result, this.response});
}

class GroupUserKickResponse {
  final ServiceResult result;
  APIGroupUserKick? response;
  GroupUserKickResponse({required this.result, this.response});
}

class GroupCreateResponse {
  final ServiceResult result;
  APIGroupCreate? response;
  GroupCreateResponse({required this.result, this.response});
}

class GroupCreateRoomResponse {
  final ServiceResult result;
  GroupRoom? response;
  GroupCreateRoomResponse({required this.result, this.response});
}

class GroupRoomsResponse {
  final ServiceResult result;
  List<GroupRoom>? response;
  GroupRoomsResponse({required this.result, this.response});
}

class GroupRoomChatsResponse {
  final ServiceResult result;
  List<GroupRoomChat>? response;
  GroupRoomChatsResponse({required this.result, this.response});
}

class GroupRoomChatsSendResponse {
  final ServiceResult result;
  GroupRoomChat? response;
  GroupRoomChatsSendResponse({required this.result, this.response});
}

// #JoinUS

class JoinUsFetchDepartmentsResponse {
  final ServiceResult result;
  List<APIJoinusPermissionList>? response;
  JoinUsFetchDepartmentsResponse({required this.result, this.response});
}

class JoinUsApplicationsResponse {
  final ServiceResult result;
  List<APIJoinusList>? response;
  JoinUsApplicationsResponse({required this.result, this.response});
}

class JoinUsRequestJoinDepartmentResponse {
  final ServiceResult result;
  APIGroupCreate? response;
  JoinUsRequestJoinDepartmentResponse({required this.result, this.response});
}

// #LoginRegister

class LoginRegisterInviteCodeResponse {
  final ServiceResult result;
  APIInvitecode? response;
  LoginRegisterInviteCodeResponse({required this.result, this.response});
}

// #Media
class MediaFetchResponse {
  final ServiceResult result;
  List<APIMediaFetch>? response;
  MediaFetchResponse({required this.result, this.response});
}

// #Music
class MusicFetchResponse {
  final ServiceResult result;
  List<APIMusicFetch>? response;
  MusicFetchResponse({required this.result, this.response});
}

class MediaRotationResponse {
  final ServiceResult result;
  APIMediaFetch? response;
  MediaRotationResponse({required this.result, this.response});
}

class MediaDeleteResponse {
  final ServiceResult result;
  APIMediaFetch? response;
  MediaDeleteResponse({required this.result, this.response});
}

class MediaUploadResponse {
  final ServiceResult result;
  List<APIMediaUpload>? response;
  MediaUploadResponse({required this.result, this.response});
}
// #News

class NewsListResponse {
  final ServiceResult result;
  APINewsList? response;
  NewsListResponse({required this.result, this.response});
}

class NewsFetchResponse {
  final ServiceResult result;
  APINewsDetail? response;
  NewsFetchResponse({required this.result, this.response});
}

// #Notifications

class NotificationListResponse {
  final ServiceResult result;
  List<APINotificationList>? response;
  NotificationListResponse({required this.result, this.response});
}

class NotificationSettingsResponse {
  final ServiceResult result;
  APINotificationSetting? response;
  NotificationSettingsResponse({required this.result, this.response});
}

class NotificationSettingsUpdateResponse {
  final ServiceResult result;
  // APINotificationList? response;
  NotificationSettingsUpdateResponse({required this.result});
}

// #Posts
class PostLikeResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostLikeResponse({required this.result});
}

class PostUnLikeResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostUnLikeResponse({required this.result});
}

class PostCommentLikeResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostCommentLikeResponse({required this.result});
}

class PostCommentUnLikeResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostCommentUnLikeResponse({required this.result});
}

class PostShareResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostShareResponse({required this.result});
}

class PostRemoveResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostRemoveResponse({required this.result});
}

class PostRemoveCommentResponse {
  final ServiceResult result;
  // APINotificationList? response;
  PostRemoveCommentResponse({required this.result});
}

class PostFetchListResponse {
  final ServiceResult result;
  List<APIPostList>? response;

  PostFetchListResponse({required this.result, this.response});
}

class PostFetchResponse {
  final ServiceResult result;
  APIPostList? response;

  PostFetchResponse({required this.result, this.response});
}

class PostCommentsFetchResponse {
  final ServiceResult result;
  List<APIPostComments>? response;
  PostCommentsFetchResponse({required this.result});
}

class PostCreateCommentResponse {
  final ServiceResult result;
  PostCreateCommentResponse({required this.result});
}

class PostLikesListResponse {
  final ServiceResult result;
  List<APIPostLiker>? response;

  PostLikesListResponse({required this.result, this.response});
}

// #Profile

class ProfileInviteListResponse {
  final ServiceResult result;
  List<APIProfileInvitelist>? response;

  ProfileInviteListResponse({required this.result, this.response});
}

class ProfileFriendListResponse {
  final ServiceResult result;
  List<APIProfileFriendlist>? response;

  ProfileFriendListResponse({required this.result, this.response});
}

//Reels
class ReelsListResponse {
  final ServiceResult result;
  List<APIReel>? response;

  ReelsListResponse({required this.result, this.response});
}

//Rules
class RulesResponse {
  final ServiceResult result;
  List<APIRules>? response;
  RulesResponse({required this.result, this.response});
}

// #School

class SchoolFetchListResponse {
  final ServiceResult result;
  List<APISchoolList>? response;
  SchoolFetchListResponse({required this.result, this.response});
}

class SchoolFetchDetailResponse {
  final ServiceResult result;
  APISchoolDetail? response;
  SchoolFetchDetailResponse({required this.result, this.response});
}

// #Station
class StationFetchDetailResponse {
  final ServiceResult result;
  List<APIStationDetail>? response;
  StationFetchDetailResponse({required this.result, this.response});
}

class StationFetchListResponse {
  final ServiceResult result;
  List<APIStationList>? response;
  StationFetchListResponse({required this.result, this.response});
}

class StatisticsListResponse {
  final ServiceResult result;
  List<APIStatisticsList>? response;
  StatisticsListResponse({required this.result, this.response});
}

class StationFetchEquipmentListResponse {
  final ServiceResult result;
  List<APIStationEquipmentList>? response;
  StationFetchEquipmentListResponse({required this.result, this.response});
}

// #Story

class StoryFetchListResponse {
  final ServiceResult result;
  List<APIStoryList>? response;
  StoryFetchListResponse({required this.result, this.response});
}

class StoryViewListResponse {
  final ServiceResult result;
  List<APIStoryViewlist>? response;
  StoryViewListResponse({required this.result, this.response});
}

class StoryLikerListResponse {
  final ServiceResult result;
  List<APIStoryLikelist>? response;
  StoryLikerListResponse({required this.result, this.response});
}

// #Survey
class SurveyListResponse {
  final ServiceResult result;
  List<APISurveyList>? response;
  SurveyListResponse({required this.result, this.response});
}

// #Teams
class TeamListResponse {
  final ServiceResult result;
  List<APITeamList>? response;
  TeamListResponse({required this.result, this.response});
}

// #Search

class SearchListResponse {
  final ServiceResult result;
  APISearchList? response;
  SearchListResponse({required this.result, this.response});
}

class SearchHashtagListResponse {
  final ServiceResult result;
  APISearchHashtagList? response;
  SearchHashtagListResponse({required this.result, this.response});
}

//login Register Forgotmy password

class LoginResponse {
  final ServiceResult result;
  APILogin? response;
  LoginResponse({required this.result, this.response});
}

class RegisterResponse {
  final ServiceResult result;
  RegisterResponse({required this.result});
}
//Look Profile

class LookProfileResponse {
  final ServiceResult result;
  APILogin? response;
  LookProfileResponse({required this.result, this.response});
}

class LookProfilewithUsernameResponse {
  final ServiceResult result;
  APILogin? response;
  LookProfilewithUsernameResponse({required this.result, this.response});
}

//#Utils

class APIMyGroupListResponse {
  final ServiceResult result;
  List<APIMyGroupList>? response;
  APIMyGroupListResponse({required this.result, this.response});
}

class APIMySchoolListResponse {
  final ServiceResult result;
  List<APIMySchoolList>? response;
  APIMySchoolListResponse({required this.result, this.response});
}

class PlayerPopResponse {
  final ServiceResult result;
  List<APIPlayerPop>? response;
  PlayerPopResponse({required this.result, this.response});
}

class PlayerXPResponse {
  final ServiceResult result;
  List<APIPlayerXp>? response;
  PlayerXPResponse({required this.result, this.response});
}

class ForeignCurrencyListResponse {
  final ServiceResult result;
  List<ForeignCurrencyList>? response;
  ForeignCurrencyListResponse({required this.result, this.response});
}

class WeatherListResponse {
  final ServiceResult result;
  List<WeatherAPI>? response;
  WeatherListResponse({required this.result, this.response});
}

class SuperLigResponse {
  final ServiceResult result;
  List<SuperLigAPI>? response;
  SuperLigResponse({required this.result, this.response});
}

class GamesOnSaleResponse {
  final ServiceResult result;
  List<GamesOnSaleAPI>? response;
  GamesOnSaleResponse({required this.result, this.response});
}

class NewRegisteredUsersResponse {
  final ServiceResult result;
  List<NewRegisteredUsersAPI>? response;
  NewRegisteredUsersResponse({required this.result, this.response});
}

class MinecraftStatisticsResponse {
  final ServiceResult result;
  List<MinecraftStatisticsAPI>? response;
  MinecraftStatisticsResponse({required this.result, this.response});
}

// #Control Panel
class ControlPanelHomeResponse {
  final ServiceResult result;
  List<APIControlpanelUserslist>? response;
  ControlPanelHomeResponse({required this.result, this.response});
}

class ControlPanelMeetingResponse {
  final ServiceResult result;
  List<APIControlpanelMeetinglist>? response;
  ControlPanelMeetingResponse({required this.result, this.response});
}
