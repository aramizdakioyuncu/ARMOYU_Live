import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class NewRegisteredUsersAPI {
  final String displayname;
  final MediaURL avatar;
  final int level;
  final String levelcolor;

  final String xp;
  final String url;
  final bool isme;

  NewRegisteredUsersAPI({
    required this.displayname,
    required this.avatar,
    required this.level,
    required this.levelcolor,
    required this.xp,
    required this.url,
    required this.isme,
  });
}
