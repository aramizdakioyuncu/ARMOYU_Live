import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIBlockingRemove {
  int blockID;
  UserInfo blockeduser;
  String date;

  APIBlockingRemove({
    required this.blockID,
    required this.blockeduser,
    required this.date,
  });
}
