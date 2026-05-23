import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class SuperLigAPI {
  final String teamname;
  final MediaURL? teamlogo;
  final int playedmatchcount;

  final int avarage;
  final int point;

  SuperLigAPI({
    required this.teamname,
    this.teamlogo,
    required this.playedmatchcount,
    required this.avarage,
    required this.point,
  });
}
