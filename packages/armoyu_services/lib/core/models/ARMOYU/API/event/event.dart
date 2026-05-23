import 'package:armoyu_services/core/models/ARMOYU/user.dart';

class APIEvent {
  int eventID;
  bool status;
  String link;
  String foto;
  String? fotoDetail;
  String name;
  int gameID;
  String gameName;
  String gameBanner;
  String gameLogo;
  List<UserInfo> organizer;
  String type;
  String date;
  String participantType;
  int participantLimit;
  int participantGroupPlayerLimit;
  int participantCurrent;
  String location;
  String description;
  String rules;

  APIEvent({
    required this.eventID,
    required this.status,
    required this.link,
    required this.foto,
    required this.fotoDetail,
    required this.name,
    required this.gameID,
    required this.gameName,
    required this.gameBanner,
    required this.gameLogo,
    required this.organizer,
    required this.type,
    required this.date,
    required this.participantType,
    required this.participantLimit,
    required this.participantGroupPlayerLimit,
    required this.participantCurrent,
    required this.location,
    required this.description,
    required this.rules,
  });

  // JSON'dan APIEvent nesnesi oluşturma
  factory APIEvent.fromJson(Map<String, dynamic> json) {
    return APIEvent(
      eventID: json['eventID'],
      status: json['status'],
      link: json['link'],
      foto: json['foto'],
      fotoDetail: json['fotoDetail'],
      name: json['name'],
      gameID: json['gameID'],
      gameName: json['gameName'],
      gameBanner: json['gameBanner'],
      gameLogo: json['gameLogo'],
      organizer: (json['organizer'] as List<dynamic>)
          .map((player) => UserInfo.fromJson(player))
          .toList(),
      type: json['type'],
      date: json['date'],
      participantType: json['participantType'],
      participantLimit: json['participantLimit'],
      participantGroupPlayerLimit: json['participantGroupPlayerLimit'],
      participantCurrent: json['participantCurrent'],
      location: json['location'],
      description: json['description'],
      rules: json['rules'],
    );
  }

  // APIEvent nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'eventID': eventID,
      'status': status,
      'link': link,
      'foto': foto,
      'fotoDetail': fotoDetail,
      'name': name,
      'gameID': gameID,
      'gameName': gameName,
      'gameBanner': gameBanner,
      'gameLogo': gameLogo,
      'organizer': organizer.map((e) => e.toJson()).toList(),
      'type': type,
      'date': date,
      'participantType': participantType,
      'participantLimit': participantLimit,
      'participantGroupPlayerLimit': participantGroupPlayerLimit,
      'participantCurrent': participantCurrent,
      'location': location,
      'description': description,
      'rules': rules,
    };
  }
}
