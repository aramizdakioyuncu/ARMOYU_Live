import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIBlockingList {
  int blockID;
  UserInfo blockeduser;
  String date;

  APIBlockingList({
    required this.blockID,
    required this.blockeduser,
    required this.date,
  });
}
