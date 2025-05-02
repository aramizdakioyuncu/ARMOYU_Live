import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/my_group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class HomeController extends GetxController {
  final socketio = Get.put(SocketioControllerV2());

  var selectedPage = 0.obs;
  final pageController = PageController(initialPage: 0);

  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  webrtc.MediaStream? remoteStream;

  webrtc.MediaStream? screenStream; // Ekran akışı için bir stream
  // Video renderer'ı burada tanımlıyoruz
  var localRenderer = webrtc.RTCVideoRenderer().obs;
  var remoteRenderer = webrtc.RTCVideoRenderer().obs;

  List<webrtc.MediaStream> remoteStreams = [];
  var remoteRenderers = <webrtc.RTCVideoRenderer>[].obs; // Dinamik liste

  // Bağlantı durumu için reaktif bir değişken ekliyoruz
  var connectionState = Rx<webrtc.RTCPeerConnectionState?>(null);

  var showMembers = false.obs;

  @override
  void onInit() {
    super.onInit();

    localRenderer.value.initialize();
    remoteRenderer.value.initialize();

    windowManager.setResizable(true);
    init();
    fetchgroup();
  }

  @override
  void onClose() {
    localRenderer.value.dispose();
    for (var renderer in remoteRenderers) {
      renderer.dispose();
    }

    super.onClose();
  }

  fetchgroup() async {
    APIMyGroupListResponse response =
        await ARMOYU.service.profileServices.myGroups();

    AppList.groups.value = [];

    for (APIMyGroupList element in response.response!) {
      AppList.groups.add(
        Group(
          groupID: element.groupID,
          name: element.groupName,
          description: element.groupDescription,
          logo: Media(
            mediaID: element.groupLogo.mediaID,
            mediaType: MediaType.image,
            mediaURL: MediaURL(
              bigURL: Rx(element.groupLogo.mediaURL.bigURL),
              normalURL: Rx(element.groupLogo.mediaURL.normalURL),
              minURL: Rx(element.groupLogo.mediaURL.minURL),
            ),
          ),
          rooms: RxList<Room>([]),
        ),
      );
    }
  }

  void showAlertDialog(BuildContext context, SocketioControllerV2 socketio) {
    var textController = TextEditingController().obs;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Grup Oluştur'),
          content: const Text('Oluşturduğun Grup anlık gözükür.'),
          actions: <Widget>[
            TextField(
              controller: textController.value,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  child: const Text('Kapat'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  child: const Text('Oluştur'),
                  onPressed: () {
                    AppList.groups.add(
                      Group(
                        rooms: <Room>[].obs,
                        groupID: 13,
                        name: textController.value.text,
                        description: "dgfkljsdgjsdlkgjsedl",
                        logo: Media(
                          mediaID: 0,
                          mediaType: MediaType.image,
                          mediaURL: MediaURL(
                            bigURL: Rx(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/220px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg",
                            ),
                            normalURL: Rx(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/220px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg",
                            ),
                            minURL: Rx(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/220px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg",
                            ),
                          ),
                        ),
                      ),
                    );
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> init() async {
    localStream = await webrtc.navigator.mediaDevices.getUserMedia({
      "audio": true,
      "video": true,
    });

    // Akışı bir renderer ile yerel videoda göster
    localRenderer.value.srcObject = localStream;

    peerConnection = await webrtc.createPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    });

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });

    peerConnection!.onIceCandidate = (candidate) {
      socketio.sendCandidate(candidate.toMap());
    };

    peerConnection!.onTrack = (event) async {
      if (event.track.kind == 'audio') {
        // Gelen ses akışını burada işleyebilirsiniz
        log('Gelen ses verisi: ${event.streams[0]}');
      }

      if (event.track.kind == 'video') {
        // Gelen video stream'ini almak
        remoteStream = event.streams[0];
        remoteRenderer.value.srcObject = remoteStream;

        remoteStreams.add(event.streams[0]);
        await addRemoteRenderer(event.streams[0]);
      }

      log('//**//');
    };

    peerConnection!.onConnectionState = (state) {
      log("Connection state: $state");
      connectionState.value = state; // Bağlantı durumunu güncelliyoruz
    };
  }

  Future<void> addRemoteRenderer(webrtc.MediaStream stream) async {
    var newRenderer = webrtc.RTCVideoRenderer();
    await newRenderer.initialize();
    newRenderer.srcObject = stream;
    remoteRenderers.add(newRenderer);
  }

  // Ekran paylaşımını başlatma
  Future<void> startScreenSharing() async {
    webrtc.SourceType sourceType = webrtc.SourceType.Screen;

    var sources = await webrtc.desktopCapturer.getSources(types: [sourceType]);
    for (var element in sources) {
      if (kDebugMode) {
        print(
            'name: ${element.name}, id: ${element.id}, type: ${element.type}');
      }
    }

    try {
      // Ekranları listelemek için tüm medya cihazlarını alıyoruz
      final devices = await webrtc.navigator.mediaDevices.enumerateDevices();

      // Ekran cihazlarını filtreliyoruz
      final screenDevices =
          devices.where((device) => device.kind == 'videoinput').toList();
      for (webrtc.MediaDeviceInfo device in screenDevices) {
        if (kDebugMode) {
          print(device.label);
        }
      }
      if (screenDevices.isEmpty) {
        if (kDebugMode) {
          print('Ekran cihazı bulunamadı!');
        }
        return;
      }

      // İlk monitörü seçiyoruz
      final firstMonitorDeviceId = screenDevices.first.deviceId;

      // Ekran paylaşımını başlatıyoruz
      // Ekran paylaşımı başlatıyoruz, birinci monitörü seçiyoruz
      screenStream = await webrtc.navigator.mediaDevices.getDisplayMedia({
        "video": {
          "deviceId": firstMonitorDeviceId,
        },
      });
      // Ekran akışını peer connection'a ekliyoruz
      screenStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, screenStream!);
      });

      if (kDebugMode) {
        print("Ekran paylaşımı başladı");
      }

      // Eğer ekran paylaşımını yerel video olarak da göstermek isterseniz
      // video renderer'ı güncelleyebilirsiniz.
    } catch (e) {
      if (kDebugMode) {
        print("Ekran paylaşımı başlatılamadı: $e");
      }
    }
  }

  // Ekran paylaşımını durdurma
  Future<void> stopScreenSharing() async {
    try {
      // Ekran paylaşımını durduruyoruz
      screenStream?.getTracks().forEach((track) {
        track.stop();
      });

      if (kDebugMode) {
        print("Ekran paylaşımı durduruldu");
      }

      // Peer connection'dan ekran akışını kaldırmak isterseniz
      screenStream?.getTracks().forEach((track) {
        // peerConnection!.removeTrack(track);
      });

      // Yerel video akışına geri dönebiliriz
      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Ekran paylaşımı durdurulamadı: $e");
      }
    }
  }

  Future<void> selectMicrophone() async {
    try {
      final mediaDevices =
          await webrtc.navigator.mediaDevices.enumerateDevices();
      final audioDevices =
          mediaDevices.where((device) => device.kind == 'audioinput').toList();

      if (audioDevices.isNotEmpty) {
        final secondMicrophoneId = audioDevices[1].deviceId; // İkinci mikrofon
        final newStream = await webrtc.navigator.mediaDevices.getUserMedia({
          'audio': {'deviceId': secondMicrophoneId},
          'video': true
        });

        // Stream'i güncelleme ve peer connection'a ekleme
        localStream = newStream;
        localRenderer.value.srcObject = localStream;

        newStream.getTracks().forEach((track) {
          peerConnection!.addTrack(track, newStream);
        });

        if (kDebugMode) {
          print("Yeni mikrofon kullanılıyor: $secondMicrophoneId");
        }
      } else {
        if (kDebugMode) {
          print("Mikrofon bulunamadı!");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Mikrofon seçimi hatası: $e");
      }
    }
  }

  Future<void> createOffer() async {
    webrtc.RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    socketio.sendOffer(offer.toMap());
  }

  Future<void> createAnswer(webrtc.RTCSessionDescription offer) async {
    await peerConnection!.setRemoteDescription(offer);
    webrtc.RTCSessionDescription answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);
    socketio.sendAnswer(answer.toMap());
  }
}
