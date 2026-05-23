import 'package:armoyu_services/core/constants/variables.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/country.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/province.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APILogin {
  String? arkadasdurum;
  String? cinsiyet;
  String? arkadasdurumaciklama;
  int? playerID;
  String? username;
  String? firstName;
  String? lastName;
  String? displayName;
  String? displayNameV2;
  String? displayNameV3;
  String? url;
  String? kulno;
  String? burc;
  String? odp;
  int? level;
  String? levelXP;
  String? levelColor;
  Media? avatar;
  Media? banner;
  Media? wallpaper;
  APILoginDetailInfo? detailInfo;
  UserRole? userRole;
  SocialAccounts? socailAccounts;
  Job? job;

  DefaultGroup? defaultGroup;
  int? roleID;
  String? roleName;
  String? roleColor;
  String? koyuncuhak;
  int? ortakarkadaslar;
  List<Friend>? ortakarkadasliste;
  List<Friend>? arkadasliste;
  APILoginBanHistory? banHistory;
  String? registeredDate;
  String? registeredDateV2;
  FavoriteTeam? favTeam;
  int? mevcutoyunsayisi;
  List<PopularGame>? popularGames;

  APILogin({
    this.arkadasdurum,
    this.cinsiyet,
    this.arkadasdurumaciklama,
    this.playerID,
    this.username,
    this.firstName,
    this.lastName,
    this.displayName,
    this.displayNameV2,
    this.displayNameV3,
    this.url,
    this.kulno,
    this.burc,
    this.odp,
    this.level,
    this.levelXP,
    this.levelColor,
    this.avatar,
    this.banner,
    this.wallpaper,
    this.detailInfo,
    this.userRole,
    this.socailAccounts,
    this.job,
    this.defaultGroup,
    this.roleID,
    this.roleName,
    this.roleColor,
    this.koyuncuhak,
    this.ortakarkadaslar,
    this.ortakarkadasliste,
    this.arkadasliste,
    this.banHistory,
    this.registeredDate,
    this.registeredDateV2,
    this.favTeam,
    this.mevcutoyunsayisi,
    this.popularGames,
  });

  factory APILogin.fromJson(Map<String, dynamic> json) {
    return APILogin(
      arkadasdurum: json['arkadasdurum'],
      cinsiyet: json['cinsiyet'],
      arkadasdurumaciklama: json['arkadasdurumaciklama'],
      playerID: json['playerID'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      displayName: json['displayName'],
      displayNameV2: json['displayNameV2'],
      displayNameV3: json['displayNameV3'],
      url: json['URL'],
      kulno: json['kulno'],
      burc: json['burc'],
      odp: json['ODP'],
      level: json['level'],
      levelXP: json['levelXP'],
      levelColor: json['levelColor'],
      avatar: json['avatar'] != null ? Media.fromJson(json['avatar']) : null,
      banner: json['banner'] != null ? Media.fromJson(json['banner']) : null,
      wallpaper:
          json['wallpaper'] != null ? Media.fromJson(json['wallpaper']) : null,
      detailInfo: json['detailInfo'] != null
          ? APILoginDetailInfo.fromJson(json['detailInfo'])
          : null,
      userRole:
          json['userRole'] != null ? UserRole.fromJson(json['userRole']) : null,
      socailAccounts: json['socailAccounts'] != null
          ? SocialAccounts.fromJson(json['socailAccounts'])
          : null,
      job: json['job'] != null ? Job.fromJson(json['job']) : null,
      defaultGroup: json['defaultGroup'] != null
          ? DefaultGroup.fromJson(json['defaultGroup'])
          : null,
      roleID: json['roleID'],
      roleName: json['roleName'],
      roleColor: json['roleColor'],
      koyuncuhak: json['koyuncuhak'],
      ortakarkadaslar: json['ortakarkadaslar'],
      ortakarkadasliste: json['ortakarkadasliste'] != null
          ? (json['ortakarkadasliste'] as List<dynamic>)
              .map((e) => Friend.fromJson(e))
              .toList()
          : null,
      arkadasliste: json['arkadasliste'] != null
          ? (json['arkadasliste'] as List<dynamic>)
              .map((e) => Friend.fromJson(e))
              .toList()
          : null,
      banHistory: json['banHistory'] != null
          ? APILoginBanHistory.fromJson(json['banHistory'])
          : null,
      registeredDate: json['registeredDate'],
      registeredDateV2: json['registeredDateV2'],
      favTeam: json['favTeam'] != null
          ? FavoriteTeam.fromJson(json['favTeam'])
          : null,
      mevcutoyunsayisi: json['mevcutoyunsayisi'],
      popularGames: json['popularGames'] != null
          ? (json['popularGames'] as List<dynamic>)
              .map((e) => PopularGame.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arkadasdurum': arkadasdurum,
      'cinsiyet': cinsiyet,
      'arkadasdurumaciklama': arkadasdurumaciklama,
      'playerID': playerID,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'displayNameV2': displayNameV2,
      'displayNameV3': displayNameV3,
      'URL': url,
      'kulno': kulno,
      'burc': burc,
      'ODP': odp,
      'level': level,
      'levelXP': levelXP,
      'levelColor': levelColor,
      'avatar': avatar?.toJson(),
      'banner': banner?.toJson(),
      'wallpaper': wallpaper?.toJson(),
      'detailInfo': detailInfo?.toJson(),
      'userRole': userRole?.toJson(),
      'socailAccounts': socailAccounts?.toJson(),
      'job': job?.toJson(),
      'defaultGroup': defaultGroup?.toJson(),
      'roleID': roleID,
      'roleName': roleName,
      'roleColor': roleColor,
      'koyuncuhak': koyuncuhak,
      'ortakarkadaslar': ortakarkadaslar,
      'ortakarkadasliste': ortakarkadasliste?.map((e) => e.toJson()).toList(),
      'arkadasliste': arkadasliste?.map((e) => e.toJson()).toList(),
      'banHistory': banHistory?.toJson(),
      'registeredDate': registeredDate,
      'registeredDateV2': registeredDateV2,
      'favTeam': favTeam?.toJson(),
      'mevcutoyunsayisi': mevcutoyunsayisi,
      'popularGames': popularGames?.map((e) => e.toJson()).toList(),
    };
  }

  static APILogin? updateclass(Map<String, dynamic> response) {
    if (response['aciklama'] == "Oyuncu bilgileri yanlış!") {
      return null;
    }
    List<Friend> friendlist = [];
    if (response['icerik']['arkadasliste'] != null) {
      for (var friendInfo in response['icerik']['arkadasliste']) {
        friendlist.add(
          Friend(
            oyuncuID: friendInfo['oyuncuID'],
            oyuncuMinnakAvatar: MediaURL(
              bigURL: friendInfo['oyuncuminnakavatar'],
              normalURL: friendInfo['oyuncuminnakavatar'],
              minURL: friendInfo['oyuncuminnakavatar'],
            ),
            oyuncuKullaniciAdi: friendInfo['oyuncukullaniciadi'],
          ),
        );
      }
    }

    List<Friend> commonfriendlist = [];
    if (response['icerik']['ortakarkadasliste'] != null) {
      for (var friendInfo in response['icerik']['ortakarkadasliste']) {
        commonfriendlist.add(
          Friend(
            oyuncuID: friendInfo['oyuncuID'],
            oyuncuMinnakAvatar: MediaURL(
              bigURL: friendInfo['oyuncuminnakavatar'],
              normalURL: friendInfo['oyuncuminnakavatar'],
              minURL: friendInfo['oyuncuminnakavatar'],
            ),
            oyuncuKullaniciAdi: friendInfo['oyuncukullaniciadi'],
          ),
        );
      }
    }
    List<PopularGame> popularGames = [];
    if (response['icerik']['popularGames'] != null) {
      for (var gameInfo in response['icerik']['popularGames']) {
        popularGames.add(
          PopularGame(
            gameID: gameInfo['game_ID'],
            gameName: gameInfo['game_name'],
            gameShortName: gameInfo['game_shortName'],
            gameURL: gameInfo['game_URL'],
            gameScore: gameInfo['game_score'],
            gameMoney: gameInfo['game_money'],
            gameLogo: Media(
              mediaID: gameInfo['game_logo']['media_ID'],
              mediaURL: MediaURL(
                bigURL: gameInfo['game_logo']['media_bigURL'],
                normalURL: gameInfo['game_logo']['media_URL'],
                minURL: gameInfo['game_logo']['media_minURL'],
              ),
            ),
            gameRole: GameRole(
              roleID: gameInfo['game_role']['role_ID'],
              roleName: gameInfo['game_role']['role_name'],
            ),
            gameClan: gameInfo['game_clan'],
          ),
        );
      }
    }

    return APILogin(
      arkadasdurum: response['icerik']['arkadasdurum'],
      cinsiyet: response['icerik']['cinsiyet'],
      arkadasdurumaciklama: response['icerik']['arkadasdurumaciklama'],
      playerID: response['icerik']['playerID'],
      username: response['icerik']['username'],
      firstName: response['icerik']['firstName'],
      lastName: response['icerik']['lastName'],
      displayName: response['icerik']['displayName'],
      displayNameV2: response['icerik']['displayNameV2'],
      displayNameV3: response['icerik']['displayNameV3'],
      url: response['icerik']['URL'],
      kulno: response['icerik']['kulno'],
      burc: response['icerik']['burc'],
      odp: response['icerik']['ODP'],
      level: response['icerik']['level'],
      levelXP: response['icerik']['levelXP'],
      levelColor: response['icerik']['levelColor'],
      avatar: response['icerik']['avatar'] == null
          ? null
          : Media(
              mediaID: response['icerik']['avatar']['media_ID'],
              mediaURL: MediaURL(
                bigURL: response['icerik']['avatar']['media_bigURL'] ??
                    Variables.avatar,
                normalURL: response['icerik']['avatar']['media_URL'] ??
                    Variables.avatar,
                minURL: response['icerik']['avatar']['media_minURL'] ??
                    Variables.avatar,
              ),
            ),
      banner: response['icerik']['banner'] == null
          ? null
          : Media(
              mediaID: response['icerik']['banner']['media_ID'],
              mediaURL: MediaURL(
                bigURL: response['icerik']['banner']['media_bigURL'] ??
                    Variables.banner,
                normalURL: response['icerik']['banner']['media_URL'] ??
                    Variables.banner,
                minURL: response['icerik']['banner']['media_minURL'] ??
                    Variables.banner,
              ),
            ),
      wallpaper: response['icerik']['wallpaper'] == null
          ? null
          : Media(
              mediaID: response['icerik']['wallpaper']['media_ID'],
              mediaURL: MediaURL(
                bigURL: response['icerik']['wallpaper']['media_bigURL'] ??
                    Variables.wallpaper,
                normalURL: response['icerik']['wallpaper']['media_URL'] ??
                    Variables.wallpaper,
                minURL: response['icerik']['wallpaper']['media_minURL'] ??
                    Variables.wallpaper,
              ),
            ),
      detailInfo: response['icerik']['detailInfo'] == null
          ? null
          : APILoginDetailInfo(
              about: response['icerik']['detailInfo']['about'],
              age: response['icerik']['detailInfo']['age'],
              email: response['icerik']['detailInfo']['email'],
              friends: response['icerik']['detailInfo']['friends'],
              posts: response['icerik']['detailInfo']['posts'],
              awards: response['icerik']['detailInfo']['awards'],
              phoneNumber: response['icerik']['detailInfo']['phoneNumber'],
              birthdayDate: response['icerik']['detailInfo']['birthdayDate'],
              inviteCode: response['icerik']['detailInfo']['inviteCode'],
              lastloginDate: response['icerik']['detailInfo']['lastloginDate'],
              lastloginDateV2: response['icerik']['detailInfo']
                  ['lastloginDateV2'],
              lastfailedDate: response['icerik']['detailInfo']
                  ['lastfailedDate'],
              country: response['icerik']['detailInfo']['country'] == null
                  ? null
                  : APICountry(
                      countryID: response['icerik']['detailInfo']['country']
                          ['country_ID'],
                      name: response['icerik']['detailInfo']['country']
                          ['country_name'],
                      code: response['icerik']['detailInfo']['country']
                          ['country_code'],
                      phonecode: response['icerik']['detailInfo']['country']
                          ['country_phoneCode'],
                    ),
              province: response['icerik']['detailInfo']['province'] == null
                  ? null
                  : APIProvince(
                      provinceID: response['icerik']['detailInfo']['province']
                          ['province_ID'],
                      name: response['icerik']['detailInfo']['province']
                          ['province_name'],
                      platecode: response['icerik']['detailInfo']['province']
                          ['province_plateCode'],
                      phonecode: response['icerik']['detailInfo']['province']
                          ['province_phoneCode'],
                    ),
            ),
      userRole: response['icerik']['userRole'] == null
          ? null
          : UserRole(
              roleID: response['icerik']['userRole']['roleID'],
              roleName: response['icerik']['userRole']['roleName'],
              roleCategory: response['icerik']['userRole']['rolecategory'],
              roleColor: response['icerik']['userRole']['roleColor'],
            ),
      socailAccounts: response['icerik']['socailAccounts'] == null
          ? null
          : SocialAccounts(
              facebook: response['icerik']['socailAccounts']['facebook'],
              youtube: response['icerik']['socailAccounts']['youtube'],
              twitch: response['icerik']['socailAccounts']['twitch'],
              instagram: response['icerik']['socailAccounts']['instagram'],
              steam: response['icerik']['socailAccounts']['steam'],
              linkedin: response['icerik']['socailAccounts']['linkedin'],
              reddit: response['icerik']['socailAccounts']['reddit'],
              github: response['icerik']['socailAccounts']['github'],
            ),
      job: response['icerik']['job'] == null
          ? null
          : Job(
              jobID: response['icerik']['job']['job_ID'],
              jobName: response['icerik']['job']['job_name'],
              jobShortName: response['icerik']['job']['job_shortName'],
            ),
      defaultGroup: response['icerik']['defaultGroup'] == null
          ? null
          : DefaultGroup(
              groupID: response['icerik']['defaultGroup']['group_ID'],
              groupName: response['icerik']['defaultGroup']['group_name'],
              groupShortName: response['icerik']['defaultGroup']
                  ['group_shortName'],
              groupURL: response['icerik']['defaultGroup']['group_URL'],
              groupLogo: Media(
                mediaID: response['icerik']['defaultGroup']['group_logo']
                    ['media_ID'],
                mediaURL: MediaURL(
                  bigURL: response['icerik']['defaultGroup']['group_logo']
                      ['media_bigURL'],
                  normalURL: response['icerik']['defaultGroup']['group_logo']
                      ['media_URL'],
                  minURL: response['icerik']['defaultGroup']['group_logo']
                      ['media_minURL'],
                ),
              ),
              groupBanner: Media(
                mediaID: response['icerik']['defaultGroup']['group_banner']
                    ['media_ID'],
                mediaURL: MediaURL(
                  bigURL: response['icerik']['defaultGroup']['group_banner']
                      ['media_bigURL'],
                  normalURL: response['icerik']['defaultGroup']['group_banner']
                      ['media_URL'],
                  minURL: response['icerik']['defaultGroup']['group_banner']
                      ['media_minURL'],
                ),
              ),
              groupWallpaper: Media(
                mediaID: response['icerik']['defaultGroup']['group_wallpaper']
                    ['media_ID'],
                mediaURL: MediaURL(
                  bigURL: response['icerik']['defaultGroup']['group_wallpaper']
                      ['media_bigURL'],
                  normalURL: response['icerik']['defaultGroup']
                      ['group_wallpaper']['media_URL'],
                  minURL: response['icerik']['defaultGroup']['group_wallpaper']
                      ['media_minURL'],
                ),
              ),
            ),
      roleID: response['icerik']['roleID'],
      roleName: response['icerik']['roleName'],
      roleColor: response['icerik']['roleColor'],
      koyuncuhak: response['icerik']['koyuncuhak'],
      ortakarkadaslar: response['icerik']['ortakarkadaslar'],
      ortakarkadasliste: commonfriendlist,
      arkadasliste: friendlist,
      banHistory: response['icerik']['banHistory'] == null
          ? null
          : APILoginBanHistory(
              banStatus: response['icerik']['banHistory']['ban_status'],
              banCount: response['icerik']['banHistory']['ban_count'],
              banReason: response['icerik']['banHistory']['ban_reason'],
              banRemaining: response['icerik']['banHistory']['ban_remaining'],
            ),
      registeredDate: response['icerik']['registeredDate'],
      registeredDateV2: response['icerik']['registeredDateV2'],
      favTeam: response['icerik']['favTeam'] == null
          ? null
          : FavoriteTeam(
              teamID: response['icerik']['favTeam']['team_ID'],
              teamName: response['icerik']['favTeam']['team_name'],
              teamLogo: MediaURL(
                bigURL: response['icerik']['favTeam']['team_logo'],
                normalURL: response['icerik']['favTeam']['team_logo'],
                minURL: response['icerik']['favTeam']['team_logo'],
              ),
            ),
      mevcutoyunsayisi: response['icerik']['mevcutoyunsayisi'],
      popularGames: popularGames,
    );
  }
}

class APILoginDetailInfo {
  String? about;
  int? age;
  String? email;
  int? friends;
  int? posts;
  int? awards;
  String? phoneNumber;
  String? birthdayDate;
  String? inviteCode;
  String? lastloginDate;
  String? lastloginDateV2;
  String? lastfailedDate;
  APICountry? country;
  APIProvince? province;

  APILoginDetailInfo({
    this.about,
    this.age,
    this.email,
    this.friends,
    this.posts,
    this.awards,
    this.phoneNumber,
    this.birthdayDate,
    this.inviteCode,
    this.lastloginDate,
    this.lastloginDateV2,
    this.lastfailedDate,
    this.country,
    this.province,
  });

  factory APILoginDetailInfo.fromJson(Map<String, dynamic> json) {
    return APILoginDetailInfo(
      about: json['about'],
      age: json['age'],
      email: json['email'],
      friends: json['friends'],
      posts: json['posts'],
      awards: json['awards'],
      phoneNumber: json['phoneNumber'],
      birthdayDate: json['birthdayDate'],
      inviteCode: json['inviteCode'],
      lastloginDate: json['lastloginDate'],
      lastloginDateV2: json['lastloginDateV2'],
      lastfailedDate: json['lastfailedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'about': about,
      'age': age,
      'email': email,
      'friends': friends,
      'posts': posts,
      'awards': awards,
      'phoneNumber': phoneNumber,
      'birthdayDate': birthdayDate,
      'inviteCode': inviteCode,
      'lastloginDate': lastloginDate,
      'lastloginDateV2': lastloginDateV2,
      'lastfailedDate': lastfailedDate,
      'country': country?.toJson(),
      'province': province?.toJson(),
    };
  }
}

class APILoginBanHistory {
  int banStatus;
  int banCount;
  String banReason;
  String banRemaining;

  APILoginBanHistory({
    required this.banStatus,
    required this.banCount,
    required this.banReason,
    required this.banRemaining,
  });

  factory APILoginBanHistory.fromJson(Map<String, dynamic> json) {
    return APILoginBanHistory(
      banStatus: json['ban_status'],
      banCount: json['ban_count'],
      banReason: json['ban_reason'],
      banRemaining: json['ban_remaining'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ban_status': banStatus,
      'ban_count': banCount,
      'ban_reason': banReason,
      'ban_remaining': banRemaining,
    };
  }
}

//

class UserRole {
  int roleID;
  String roleName;
  String roleCategory;
  String roleColor;

  UserRole({
    required this.roleID,
    required this.roleName,
    required this.roleCategory,
    required this.roleColor,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      roleID: json['roleID'],
      roleName: json['roleName'],
      roleCategory: json['rolecategory'],
      roleColor: json['roleColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleID': roleID,
      'roleName': roleName,
      'rolecategory': roleCategory,
      'roleColor': roleColor,
    };
  }
}
//

class SocialAccounts {
  String? facebook;
  String? youtube;
  String? twitch;
  String? instagram;
  String? steam;
  String? linkedin;
  String? reddit;
  String? github;

  SocialAccounts({
    this.facebook,
    this.youtube,
    this.twitch,
    this.instagram,
    this.steam,
    this.linkedin,
    this.reddit,
    this.github,
  });

  factory SocialAccounts.fromJson(Map<String, dynamic> json) {
    return SocialAccounts(
      facebook: json['facebook'],
      youtube: json['youtube'],
      twitch: json['twitch'],
      instagram: json['instagram'],
      steam: json['steam'],
      linkedin: json['linkedin'],
      reddit: json['reddit'],
      github: json['github'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'youtube': youtube,
      'twitch': twitch,
      'instagram': instagram,
      'steam': steam,
      'linkedin': linkedin,
      'reddit': reddit,
      'github': github,
    };
  }
}

//

class Job {
  int jobID;
  String jobName;
  String jobShortName;

  Job({
    required this.jobID,
    required this.jobName,
    required this.jobShortName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobID: json['job_ID'],
      jobName: json['job_name'],
      jobShortName: json['job_shortName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_ID': jobID,
      'job_name': jobName,
      'job_shortName': jobShortName,
    };
  }
}

//
class DefaultGroup {
  int? groupID;
  String? groupName;
  String? groupShortName;
  String? groupURL;
  Media? groupLogo;
  Media? groupBanner;
  Media? groupWallpaper;

  DefaultGroup({
    this.groupID,
    this.groupName,
    this.groupShortName,
    this.groupURL,
    this.groupLogo,
    this.groupBanner,
    this.groupWallpaper,
  });

  factory DefaultGroup.fromJson(Map<String, dynamic> json) {
    return DefaultGroup(
      groupID: json['group_ID'],
      groupName: json['group_name'],
      groupShortName: json['group_shortName'],
      groupURL: json['group_URL'],
      groupLogo: json['group_logo'] != null
          ? Media.fromJson(json['group_logo'])
          : null,
      groupBanner: json['group_banner'] != null
          ? Media.fromJson(json['group_banner'])
          : null,
      groupWallpaper: json['group_wallpaper'] != null
          ? Media.fromJson(json['group_wallpaper'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_ID': groupID,
      'group_name': groupName,
      'group_shortName': groupShortName,
      'group_URL': groupURL,
      'group_logo': groupLogo?.toJson(),
      'group_banner': groupBanner?.toJson(),
      'group_wallpaper': groupWallpaper?.toJson(),
    };
  }
}

//

class Friend {
  int oyuncuID;
  MediaURL oyuncuMinnakAvatar;
  String oyuncuKullaniciAdi;

  Friend({
    required this.oyuncuID,
    required this.oyuncuMinnakAvatar,
    required this.oyuncuKullaniciAdi,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      oyuncuID: json['oyuncuID'],
      oyuncuMinnakAvatar: MediaURL.fromJson(json['oyuncuminnakavatar']),
      oyuncuKullaniciAdi: json['oyuncukullaniciadi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oyuncuID': oyuncuID,
      'oyuncuminnakavatar': oyuncuMinnakAvatar.toJson(),
      'oyuncukullaniciadi': oyuncuKullaniciAdi,
    };
  }
}

//

class FavoriteTeam {
  int teamID;
  String teamName;
  MediaURL teamLogo;

  FavoriteTeam({
    required this.teamID,
    required this.teamName,
    required this.teamLogo,
  });

  factory FavoriteTeam.fromJson(Map<String, dynamic> json) {
    return FavoriteTeam(
      teamID: json['team_ID'],
      teamName: json['team_name'],
      teamLogo: MediaURL.fromJson(json['team_logo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_ID': teamID,
      'team_name': teamName,
      'team_logo': teamLogo.toJson(),
    };
  }
}

//
class PopularGame {
  int? gameID;
  String? gameName;
  String? gameShortName;
  String? gameURL;
  int? gameScore;
  int? gameMoney;
  Media? gameLogo;
  GameRole? gameRole;
  dynamic gameClan;

  PopularGame({
    this.gameID,
    this.gameName,
    this.gameShortName,
    this.gameURL,
    this.gameScore,
    this.gameMoney,
    this.gameLogo,
    this.gameRole,
    this.gameClan,
  });

  factory PopularGame.fromJson(Map<String, dynamic> json) {
    return PopularGame(
      gameID: json['game_ID'],
      gameName: json['game_name'],
      gameShortName: json['game_shortName'],
      gameURL: json['game_URL'],
      gameScore: json['game_score'],
      gameMoney: json['game_money'],
      gameLogo:
          json['game_logo'] != null ? Media.fromJson(json['game_logo']) : null,
      gameRole: json['game_role'] != null
          ? GameRole.fromJson(json['game_role'])
          : null,
      gameClan: json['game_clan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_ID': gameID,
      'game_name': gameName,
      'game_shortName': gameShortName,
      'game_URL': gameURL,
      'game_score': gameScore,
      'game_money': gameMoney,
      'game_logo': gameLogo?.toJson(),
      'game_role': gameRole?.toJson(),
      'game_clan': gameClan,
    };
  }
}

class GameRole {
  int? roleID;
  String? roleName;

  GameRole({
    this.roleID,
    this.roleName,
  });

  factory GameRole.fromJson(Map<String, dynamic> json) {
    return GameRole(
      roleID: json['role_ID'],
      roleName: json['role_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_ID': roleID,
      'role_name': roleName,
    };
  }
}
