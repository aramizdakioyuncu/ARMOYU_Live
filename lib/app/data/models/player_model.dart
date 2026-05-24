import 'package:armoyu_widgets/data/models/user.dart';
import 'package:get/get.dart';

class Player {
  User user;

  // Reaktif değişkenler
  RxBool microphone;
  RxBool microphoneAccess;
  RxBool speaker;
  RxBool speakerAccess;
  RxBool camera;
  // Ses yayını aktif mi (başkalarının mikrofon aktivitesi için)
  RxBool isSpeaking;

  Player({
    required this.user,
    bool microphone = false,
    bool microphoneAccess = false,
    bool speaker = false,
    bool speakerAccess = false,
    bool camera = false,
    bool isSpeaking = false,
  })  : microphone = RxBool(microphone),
        microphoneAccess = RxBool(microphoneAccess),
        speaker = RxBool(speaker),
        speakerAccess = RxBool(speakerAccess),
        camera = RxBool(camera),
        isSpeaking = RxBool(isSpeaking);

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'microphone': microphone.value,
      'microphoneAccess': microphoneAccess.value,
      'speaker': speaker.value,
      'speakerAccess': speakerAccess.value,
      'camera': camera.value,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      user: User.fromJson(json['user']),
      microphone: json['microphone'] ?? false,
      microphoneAccess: json['microphoneAccess'] ?? false,
      speaker: json['speaker'] ?? false,
      speakerAccess: json['speakerAccess'] ?? false,
      camera: json['camera'] ?? false,
    );
  }
}

enum Gender { male, female }
