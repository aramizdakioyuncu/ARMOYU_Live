import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/media_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';

class Group {
  final int groupID;
  final String name;
  final String description;
  final Media logo;
  final List<Groupmember> groupmembers;
  final List<Room> rooms;

  Group({
    required this.groupID,
    required this.name,
    required this.description,
    required this.logo,
    required this.groupmembers,
    required this.rooms,
  });
}
