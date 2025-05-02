import 'package:armoyu_widgets/data/models/user.dart';
import 'package:get/get.dart';

class Player {
  User user;

  // Reaktif değişkenler
  RxBool microphone;
  RxBool microphoneAccess;
  RxBool speaker;
  RxBool speakerAccess;

  Player({
    required this.user,
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
      'user': user.toJson(),

      'microphone': microphone.value, // Reaktif değişkeni kullan
      'microphoneAccess': microphoneAccess.value, // Reaktif değişkeni kullan
      'speaker': speaker.value, // Reaktif değişkeni kullan
      'speakerAccess': speakerAccess.value, // Reaktif değişkeni kullan
    };
  }

  // JSON'dan User nesnesi oluşturmak için bir yöntem
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      user: User.fromJson(json['user']),
      microphone: json['microphone'] ?? false,
      microphoneAccess: json['microphoneAccess'] ?? false,
      speaker: json['speaker'] ?? false,
      speakerAccess: json['speakerAccess'] ?? false,
    );
  }
}

enum Gender { male, female }
