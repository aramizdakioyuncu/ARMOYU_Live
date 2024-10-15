import 'package:get/get.dart';
import 'media_model.dart'; // Media modelini uygun dosyadan import edin

class User {
  int? id;

  String? firstname;
  String? lastname;
  String? username;
  String? displayname;
  String? email;
  String? phonenumber;
  String? serialNumber;
  Media? avatar;
  Gender? gender;

  // Reaktif değişkenler
  RxBool microphone;
  RxBool microphoneAccess;
  RxBool speaker;
  RxBool speakerAccess;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.displayname,
    this.email,
    this.phonenumber,
    this.serialNumber,
    this.avatar,
    this.gender,
    bool microphone = false, // Varsayılan değer
    bool microphoneAccess = false, // Varsayılan değer
    bool speaker = false, // Varsayılan değer
    bool speakerAccess = false, // Varsayılan değer
  })  : microphone = RxBool(microphone),
        microphoneAccess = RxBool(microphoneAccess),
        speaker = RxBool(speaker),
        speakerAccess = RxBool(speakerAccess);

  // User nesnesini JSON'a dönüştürmek için bir yöntem
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'displayname': displayname,
      'email': email,
      'phonenumber': phonenumber,
      'serialNumber': serialNumber,
      'avatar': avatar?.toJson(),
      'microphone': microphone.value, // Reaktif değişkeni kullan
      'microphoneAccess': microphoneAccess.value, // Reaktif değişkeni kullan
      'speaker': speaker.value, // Reaktif değişkeni kullan
      'speakerAccess': speakerAccess.value, // Reaktif değişkeni kullan
    };
  }

  // JSON'dan User nesnesi oluşturmak için bir yöntem
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      displayname: json['displayname'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      serialNumber: json['serialNumber'],
      avatar: json['avatar'] != null ? Media.fromJson(json['avatar']) : null,
      gender: json['gender'] != null ? Gender.values[json['gender']] : null,
      microphone: json['microphone'] ?? false,
      microphoneAccess: json['microphoneAccess'] ?? false,
      speaker: json['speaker'] ?? false,
      speakerAccess: json['speakerAccess'] ?? false,
    );
  }
}

enum Gender { male, female }
