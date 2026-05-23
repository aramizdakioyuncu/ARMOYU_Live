import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIBlockingAdd {
  int blockID;
  UserInfo blockeduser;
  String date;

  APIBlockingAdd({
    required this.blockID,
    required this.blockeduser,
    required this.date,
  });
}
