import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/internetstatus_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/modules/home/_main/controllers/home_controller.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/services/audio_model.dart';
import 'package:armoyu_desktop/app/services/audioplayer_service.dart';
import 'package:armoyu_desktop/app/services/cloudflare_realtime_voice_service.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room_chat.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart' show UserInfo;
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
// import 'package:armoyu_services/core/models/ARMOYU/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum UserEntryActivityType { join, leave }

class SocketioControllerV2 extends GetxController {
  var groups = Rxn<List<Group>>(null);

  late IO.Socket socket;
  var socketChatStatus = false.obs;

  Timer? userListTimer;
  Timer? pingTimer;
  var pingID = "".obs;

  var pingValue = 0.obs; // Ping değerini reaktif hale getirdik
  DateTime? lastPingTime; // Son ping zamanı
  String socketPREFIX = "||SOCKET|| -> ";

  var internetConnectionStatus = InternetType.good.obs;

  var isCallingMe = false.obs;
  var whichuserisCallingMe = "".obs;

  final player = AudioPlayer();
  final voiceService = Get.put(CloudflareRealtimeVoiceService());
//WEBRTC
  var isStreaming = false.obs;
  webrtc.RTCSessionDescription? tempoffer;

//WEBRTC

  final speakingvoices = AudioPlayer();

  var isSoundStreaming = false.obs;

  @override
  void onInit() {
    groups.value = AppList.groups;

    //Grup Odaları ve Üyelerini İnit yapar
    initgroup();

    // remoteRTCVideoRenderer.initialize();

    // _setupPeerConnection();
    main();

    super.onInit();
  }

  @override
  void onClose() {
    stopFetchingUserList();
    stopPing();
    unawaited(voiceService.leave(sendEvent: false));
    player.dispose();
    speakingvoices.dispose();
    socket.disconnect();
    super.onClose();
  }

  //WEBRTC

  Future<List<webrtc.MediaDeviceInfo>?> listMicrophones() async {
    try {
      // Cihazdaki tüm medya cihazlarını al
      List<webrtc.MediaDeviceInfo> devices =
          await webrtc.navigator.mediaDevices.enumerateDevices();

      // Mikrofonları filtrele
      List<webrtc.MediaDeviceInfo> microphones =
          devices.where((device) => device.kind == 'audioinput').toList();

      for (var mic in microphones) {
        if (kDebugMode) {
          log("Microphone: ${mic.label} ${mic.deviceId}");
        }
      }

      return microphones;
    } catch (e) {
      if (kDebugMode) {
        log("Error listing microphones: $e");
      }
    }
    return null;
  }

  Future<void> selectMicrophone(String deviceId) async {
    try {
      // Mikrofonu seçmek için MediaStream oluştur
      final homecontroller = Get.find<HomeController>();
      homecontroller.localStream =
          await webrtc.navigator.mediaDevices.getUserMedia({
        'audio': {'deviceId': deviceId},
      });

      // Seçilen mikrofonla MediaStream'ı kullanabilirsiniz
      // Örneğin, bu stream'i RTCPeerConnection ile kullanabilirsiniz

      // Yeni mikrofon ile MediaStream oluştur
      final newStream = await webrtc.navigator.mediaDevices.getUserMedia({
        'audio': {'deviceId': deviceId},
      });

      // Eski ses track'lerini durdur
      homecontroller.localStream?.getTracks().forEach((track) {
        if (track.kind == 'audio') {
          track.stop(); // Eski mikrofonu durdur
        }
      });

      // Yeni stream'i güncelle
      homecontroller.localStream = newStream;
      // Yeni mikrofonun track'lerini peerConnection'a ekle
      newStream.getTracks().forEach((track) {
        homecontroller.peerConnection!.addTrack(track, newStream);
      });

      if (kDebugMode) {
        log("Using new microphone: $deviceId");
      }
    } catch (e) {
      if (kDebugMode) {
        log("Error selecting microphone: $e");
      }
    }
  }

  void sendOffer(dynamic offer) {
    socket.emit("offer", offer);
  }

  void sendAnswer(dynamic answer) {
    socket.emit("answer", answer);
  }

  void sendCandidate(dynamic candidate) {
    socket.emit("candidate", candidate);
  }

  //WEBRTC

  main() {
    // Socket.IO'ya bağlanma
    socket = IO.io('https://livesocket.armoyu.com', <String, dynamic>{
      // socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    voiceService.attachSocket(socket);

    startPing(const Duration(seconds: 2));
    // Ping değerini güncelle
    socket.on('ping', (data) {
      // Burada data yerine ping zamanı verilmez.
      pingValue.value = data; // Bu satırda hata var
    });

    // Pong mesajını dinle
    socket.on('pong', (data) {
      // data içinde ping ID'sini al

      String pingId = data['id'];
      if (pingId != pingID.value) {
        log("PING ID eşleşmedi: Beklenen ${pingID.value}, gelen $pingId");

        return;
      }

      DateTime pongReceivedTime = DateTime.now(); // Pong zamanı
      if (lastPingTime != null) {
        // Ping süresini hesapla
        pingValue.value =
            pongReceivedTime.difference(lastPingTime!).inMilliseconds;

        if (pingValue.value < 80) {
          internetConnectionStatus.value = InternetType.good;
        } else if (pingValue.value < 200) {
          internetConnectionStatus.value = InternetType.normal;
        } else {
          internetConnectionStatus.value = InternetType.weak;
        }
      }
    });

    socket.on('signaling', (data) {
      // Signaling verilerini dinleme
      if (kDebugMode) {
        log('Signaling verisi alındı: $data');
      }
    });

    //WEBRTC

    // 'offer' olayını dinle
    socket.on('offer', (data) {
      if (kDebugMode) {
        log('Received offer');
      }
      if (data is Map<String, dynamic>) {
        var offer = webrtc.RTCSessionDescription(
          data['sdp'], // SDP verisini al
          data['type'], // Offer veya Answer tipi
        );

        final homecontroller = Get.find<HomeController>();
        if (homecontroller.peerConnection == null) {
          log('${socketPREFIX}Offer alındı ama aktif peerConnection yok.');
          return;
        }
        // Peer connection'ı remote description olarak ayarlıyoruz
        homecontroller.peerConnection!.setRemoteDescription(offer).then((_) {
          // Remote description ayarlandıktan sonra cevabı oluştur

          homecontroller.createAnswer(offer);
        }).catchError((e) {
          if (kDebugMode) {
            log("Error setting remote description: $e");
          }
        });
      }
    });

    // 'answer' olayını dinle
    socket.on('answer', (data) async {
      if (kDebugMode) {
        log('Received answer');
      }
      // Gelen "answer" ile ilgili işlemler

      var answer = webrtc.RTCSessionDescription(
        data['sdp'], // SDP verisini al
        data['type'], // Offer veya Answer tipi
      );

      final homecontroller = Get.find<HomeController>();
      if (homecontroller.peerConnection == null) {
        log('${socketPREFIX}Answer alındı ama aktif peerConnection yok.');
        return;
      }
      // Gelen "answer"ı remote description olarak ayarlıyoruz
      try {
        await homecontroller.peerConnection!.setRemoteDescription(answer);
      } catch (e) {
        if (kDebugMode) {
          log("Error setting remote description for answer: $e");
        }
      }
    });

    // 'candidate' olayını dinle
    socket.on('candidate', (data) async {
      if (kDebugMode) {
        log('Received candidate: $data');
      }
      // Gelen "candidate" ile ilgili işlemler
      var candidate = webrtc.RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      // Gelen candidate'ı peer connection'a ekliyoruz
      final homecontroller = Get.find<HomeController>();
      if (homecontroller.peerConnection == null) {
        log('${socketPREFIX}Candidate alındı ama aktif peerConnection yok.');
        return;
      }

      try {
        await homecontroller.peerConnection!.addCandidate(candidate);
      } catch (e) {
        if (kDebugMode) {
          log("Error adding candidate: $e");
        }
      }
      // Gelen "candidate" ile ilgili işlemleri burada yapabilirsiniz
    });

    //WEBRTC

    socket.on('INCOMING_CALL', (data) {
      // Signaling verilerini dinleme

      if (kDebugMode) {
        log('Kullanıcı Seni Arıyor: ${data['callerId']}');
      }

      isCallingMe.value = true;
      whichuserisCallingMe.value = data['callerId'];
    });

    socket.on('CALL_ACCEPTED', (data) {
      // Signaling verilerini dinleme
      if (kDebugMode) {
        log('Çağrı kabul edildi: $data');
      }
    });

    socket.on('CALL_CLOSED', (data) {
      // Signaling verilerini dinleme
      if (kDebugMode) {
        log('Çağrı reddedildi: $data');
      }
    });

    // Başka biri bağlandığında bildiri al
    socket.on('userConnected', (data) {
      if (data != null) {
        log(socketPREFIX + data.toString());
      }
    });
    // Bağlantı başarılı olduğunda (ilk bağlantı + yeniden bağlantı)
    socket.on('connect', (data) {
      log('${socketPREFIX}Bağlandı');
      socketChatStatus.value = true;

      if (AppList.sessions.isEmpty) return;

      // Kullanıcıyı kaydet
      registerUser(
        AppList.sessions.first.currentUser.user.userName!.value.toString(),
        AppList.sessions.first.currentUser.toJson(),
      );

      // Yeniden bağlanmada oda bilgisini geri gönder (sunucu state'i sıfırlar)
      final currentRoom = findmyRoomanyWhereGroup();
      if (currentRoom != null) {
        log('${socketPREFIX}Yeniden bağlantı: oda geri gönderiliyor (${currentRoom.name.value})');
        socket.emitWithAck('changeRoom', currentRoom.toJson(), ack: (data) {
          log('${socketPREFIX}changeRoom (reconnect) ack: $data ${_stateLog()}');
        });
      }
      unawaited(voiceService.rejoinAfterReconnect());
    });

    // Bağlantı kesildiğinde
    socket.on('disconnect', (data) {
      try {
        log('$socketPREFIX$data');
      } catch (e) {
        log('${socketPREFIX}Hata (disconnect): $e');
      }
      log('${socketPREFIX}Bağlantı kesildi');
      socketChatStatus.value = false;
    });

    // Grubua girildiğinde/çıkıldığında ve odaya girildiğinde/çıkıldığında client bu verilerle güncellenecek
    socket.on('user_entry_activity', (data) {
      try {
        final rawUser = data['user'];
        if (rawUser is! Map) {
          return;
        }

        final Player user = Player.fromJson(
          rawUser.map((key, value) => MapEntry(key.toString(), value)),
        );
        if (user.user.userID == null) {
          return;
        }

        final UserEntryActivityType type =
            UserEntryActivityType.values.byName(data["type"]);

        final rawRoom = data['room'];
        Room? room;
        if (rawRoom is Map) {
          room = Room.fromJson(
            rawRoom.map((key, value) => MapEntry(key.toString(), value)),
          );
        }

        if (room == null) {
          if (type == UserEntryActivityType.leave) {
            _removeUserFromAllRooms(user.user.userID!);
          }
          return;
        }

        final eventRoom = room;
        final int groupId = eventRoom.groupID;
        final List<Group> myGroups = AppList.groups;
        if (!myGroups.any((g) => g.groupID == groupId)) {
          return; // Grup bulunamadı
        }

        final Group group =
            groups.value!.firstWhere((g) => g.groupID == groupId);

        Room? destRoom =
            group.rooms?.firstWhereOrNull((r) => r.roomID == eventRoom.roomID);

        final int? currentUserId =
            AppList.sessions.first.currentUser.user.userID;

        if (type == UserEntryActivityType.join) {
          if (destRoom == null) {
            group.rooms?.add(eventRoom);
            destRoom = eventRoom;
          }

          // Üye listede yoksa ekle
          Groupmember? groupMember = group.groupmembers!.firstWhereOrNull(
              (gm) => gm.user.value.user.userID == user.user.userID);
          if (groupMember == null) {
            groupMember =
                Groupmember(user: user.obs, description: '-', status: 0);
            group.groupmembers!.add(groupMember);
          }
          groupMember.currentRoom.value = destRoom;

          if (user.user.userID == currentUserId) {
            return;
          }

          destRoom.removeUserFromRooms(user);
          destRoom.currentMembers.add(user);
        } else if (type == UserEntryActivityType.leave) {
          if (destRoom == null) {
            group.rooms?.add(eventRoom);
            destRoom = eventRoom;
          }

          Groupmember? groupMember = group.groupmembers!.firstWhereOrNull(
              (gm) => gm.user.value.user.userID == user.user.userID);
          groupMember?.currentRoom.value = null;
          destRoom.removeUserFromRooms(user);
        }

        destRoom?.currentMembers.refresh();
        group.groupmembers?.refresh();
        group.rooms?.refresh();
        groups.refresh();
      } catch (e) {
        log('${socketPREFIX}Hata (user_entry_activity): $e');
      }
    });

    // Sunucudan gelen mesajları dinleme
    socket.on('chat', (data) {
      try {
        Message mm = Message.fromJson(data);
        log('$socketPREFIX[CHAT] ${mm.user.value.user.displayName?.value} — ${mm.message.value}');

        final roomID = mm.room.value?.roomID;
        final groupID = mm.room.value?.groupID;
        if (roomID == null || groupID == null) return;

        final selectedGroup = groups.value?.firstWhereOrNull(
          (group) => group.groupID == groupID,
        );
        if (selectedGroup == null) return;

        final selectedRoom = selectedGroup.rooms
            ?.firstWhereOrNull((room) => room.roomID == roomID);
        if (selectedRoom == null) return;

        selectedRoom.message.add(mm);
      } catch (e) {
        log('${socketPREFIX}Hata (chat): $e');
      }
    });

    List<Uint8List> audioChunks = []; // Ses parçalarını saklamak için liste
    int totalAudioSize = 0; // Toplam ses verisinin boyutu (bytes cinsinden)
    double maxSize = 44100 * 2 * 2 * 0.5 * 0.5;

    socket.on('audio', (data) {
      try {
        AudioModel audio = AudioModel.fromJson(data);

        //Kendinden gelen sesi engelle
        // if (audio.userID == AppList.sessions.first.currentUser.id!) {
        //   return;
        // }

        // Ses verisini listeye ekle
        audioChunks.add(audio.base64Audio);
        totalAudioSize += audio.base64Audio.length;

        // Eğer toplam ses verisi belirli bir boyuta ulaştıysa (örneğin 1 saniyelik veri)
        if (totalAudioSize >= maxSize) {
          // Tüm veriyi birleştir
          Uint8List mergedAudio =
              Uint8List.fromList(audioChunks.expand((e) => e).toList());

          // Veriyi oynat
          AudioPlayerService.playBase64Audio(mergedAudio);

          // Veriyi temizle
          audioChunks.clear();
          totalAudioSize = 0;
        }
      } catch (e) {
        log('Hata (audio): $e');
      }
    });

    // ─── CHANNEL: kanala katılan kullanıcı ──────────────────────────────────
    socket.on('channel_user_joined', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        final bool micMuted = data['micMuted'] ?? false;
        final bool speakerOff = data['speakerOff'] ?? false;
        final bool cameraOn = data['cameraOn'] ?? user.camera.value;
        user.microphone.value = !micMuted;
        user.speaker.value = !speakerOff;
        user.camera.value = cameraOn;

        if (user.user.userID == null) return;

        for (final group in groups.value ?? []) {
          // Üyeyi groupmembers'a ekle/güncelle
          Groupmember? gm = _findMember(group.groupmembers, user.user.userID);
          if (gm == null) {
            gm = Groupmember(user: user.obs, description: '-', status: 0);
            group.groupmembers?.add(gm);
          } else {
            gm.user.value.microphone.value = user.microphone.value;
            gm.user.value.speaker.value = user.speaker.value;
            gm.user.value.camera.value = user.camera.value;
          }

          // Kullanıcıyı odanın currentMembers listesine ekle
          for (final room in group.rooms ?? []) {
            if (room.currentMembers
                .any((m) => m.user.userID == user.user.userID)) {
              continue;
            }
            // Bu odaya mı katıldı? data['room'] varsa karşılaştır
            final rawRoom = data['room'];
            if (rawRoom != null) {
              final joinedRoomID =
                  (rawRoom['roomUUID'] ?? rawRoom['roomID']) as int?;
              if (joinedRoomID != null && room.roomID == joinedRoomID) {
                room.currentMembers.add(user);
                gm.currentRoom.value = room;
              }
            }
          }

          group.groupmembers?.refresh();
          group.rooms?.refresh();
        }
        groups.refresh();
        log('${socketPREFIX}Kanala katıldı: ${user.user.displayName?.value}');
      } catch (e) {
        log('${socketPREFIX}Hata (channel_user_joined): $e');
      }
    });

    // ─── CHANNEL: kanaldan ayrılan kullanıcı ────────────────────────────────
    socket.on('channel_user_left', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        if (user.user.userID == null) return;

        _updateUserSpeaking(user.user.userID!, false);

        for (final group in groups.value ?? []) {
          final gm = _findMember(group.groupmembers, user.user.userID);
          gm?.currentRoom.value = null;
          for (final room in group.rooms ?? []) {
            room.currentMembers
                .removeWhere((m) => m.user.userID == user.user.userID);
          }
          group.groupmembers?.refresh();
          group.rooms?.refresh();
        }
        groups.refresh();
        log('${socketPREFIX}Kanaldan ayrıldı: ${user.user.displayName?.value}');
      } catch (e) {
        log('${socketPREFIX}Hata (channel_user_left): $e');
      }
    });

    // ─── CHANNEL: kanala katılınca mevcut üye listesi ────────────────────────
    socket.on('channel_user_list', (data) {
      try {
        final List<dynamic> members = data as List<dynamic>;
        final currentRoom = findmyRoomanyWhereGroup();
        for (final memberData in members) {
          if (memberData['clientId'] == null) continue;
          final Player user =
              Player.fromJson(memberData['clientId'] as Map<String, dynamic>);
          if (user.user.userID == null) continue;
          final bool micMuted = memberData['micMuted'] ?? false;
          final bool speakerOff = memberData['speakerOff'] ?? false;
          final bool cameraOn = memberData['cameraOn'] ?? user.camera.value;
          final bool isStreaming = memberData['isStreaming'] ?? false;
          user.microphone.value = !micMuted;
          user.speaker.value = !speakerOff;
          user.camera.value = cameraOn;
          _updateUserMicState(user.user.userID!, !micMuted);
          _updateUserSpeakerState(user.user.userID!, !speakerOff);
          _updateUserCameraState(user.user.userID!, cameraOn);
          _updateUserSpeaking(user.user.userID!, isStreaming);

          Room? userRoom;
          final rawRoom = memberData['room'];
          if (rawRoom is Map) {
            userRoom = Room.fromJson(
              rawRoom.map((key, value) => MapEntry(key.toString(), value)),
            );
          }
          userRoom ??= currentRoom;
          if (userRoom == null) continue;

          final group = groups.value?.firstWhereOrNull(
            (item) => item.groupID == userRoom!.groupID,
          );
          if (group == null) continue;

          Groupmember? gm = _findMember(group.groupmembers, user.user.userID);
          if (gm == null) {
            gm = Groupmember(user: user.obs, description: '-', status: 0);
            group.groupmembers?.add(gm);
          } else {
            gm.user.value.microphone.value = user.microphone.value;
            gm.user.value.speaker.value = user.speaker.value;
            gm.user.value.camera.value = user.camera.value;
          }

          Room? targetRoom = group.rooms
              ?.firstWhereOrNull((room) => room.roomID == userRoom!.roomID);
          if (targetRoom == null) {
            group.rooms?.add(userRoom);
            targetRoom = userRoom;
          }

          for (final room in group.rooms ?? <Room>[]) {
            room.currentMembers.removeWhere(
                (member) => member.user.userID == user.user.userID);
          }
          targetRoom.currentMembers.add(user);
          gm.currentRoom.value = targetRoom;
          group.groupmembers?.refresh();
          group.rooms?.refresh();
        }
        log('${socketPREFIX}Kanal üyeleri güncellendi (${members.length} kişi)');
      } catch (e) {
        log('${socketPREFIX}Hata (channel_user_list): $e');
      }
    });

    // ─── MİC DURUMU değişti ──────────────────────────────────────────────────
    socket.on('user_mic_state', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        final bool micMuted = data['micMuted'] ?? false;
        if (user.user.userID == null) return;
        _updateUserMicState(user.user.userID!, !micMuted);
        log('${socketPREFIX}Mic: ${user.user.displayName?.value} -> ${micMuted ? "MUTED" : "UNMUTED"}');
      } catch (e) {
        log('${socketPREFIX}Hata (user_mic_state): $e');
      }
    });

    // ─── HOPARLÖR DURUMU değişti ──────────────────────────────────────────────
    socket.on('user_speaker_state', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        final bool speakerOff = data['speakerOff'] ?? false;
        if (user.user.userID == null) return;
        _updateUserSpeakerState(user.user.userID!, !speakerOff);
        log('${socketPREFIX}Speaker: ${user.user.displayName?.value} -> ${speakerOff ? "OFF" : "ON"}');
      } catch (e) {
        log('${socketPREFIX}Hata (user_speaker_state): $e');
      }
    });

    // ─── KAMERA DURUMU değişti ───────────────────────────────────────────────
    socket.on('user_camera_state', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        final bool cameraOn = data['cameraOn'] ?? false;
        if (user.user.userID == null) return;
        _updateUserCameraState(user.user.userID!, cameraOn);
        log('${socketPREFIX}Camera: ${user.user.displayName?.value} -> ${cameraOn ? "ON" : "OFF"}');
      } catch (e) {
        log('${socketPREFIX}Hata (user_camera_state): $e');
      }
    });

    // ─── SES YAYINI başladı ───────────────────────────────────────────────────
    socket.on('audio_start', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        if (user.user.userID == null) return;
        _updateUserSpeaking(user.user.userID!, true);
      } catch (e) {
        log('${socketPREFIX}Hata (audio_start): $e');
      }
    });

    // ─── SES YAYINI durdu ─────────────────────────────────────────────────────
    socket.on('audio_stop', (data) {
      try {
        final Player user =
            Player.fromJson(data['user'] as Map<String, dynamic>);
        if (user.user.userID == null) return;
        _updateUserSpeaking(user.user.userID!, false);
      } catch (e) {
        log('${socketPREFIX}Hata (audio_stop): $e');
      }
    });

    // ─── ODA SİLİNDİ (başkası sildi) ────────────────────────────────────────
    socket.on('room_deleted', (data) {
      try {
        final roomData = data['room'] as Map<String, dynamic>;
        final groupID = roomData['groupID'] as int;
        final roomID = roomData['roomID'] as int;

        final group =
            groups.value?.firstWhereOrNull((g) => g.groupID == groupID);
        if (group == null) return;

        group.rooms?.removeWhere((r) => r.roomID == roomID);
        group.rooms?.refresh();

        log('$socketPREFIX[ROOM_DELETED] ${roomData['name']} (group $groupID)');
      } catch (e) {
        log('${socketPREFIX}Hata (room_deleted): $e');
      }
    });

    // ─── ODA OLUŞTURULDU (başkası oluşturdu) ────────────────────────────────
    socket.on('room_created', (data) {
      try {
        final roomData = data['room'] as Map<String, dynamic>;
        final groupID = roomData['groupID'] as int;

        final group =
            groups.value?.firstWhereOrNull((g) => g.groupID == groupID);
        if (group == null) return;

        final roomID = roomData['roomID'] as int;
        if (group.rooms?.any((r) => r.roomID == roomID) == true) return;

        group.rooms?.add(Room(
          groupID: groupID,
          roomID: roomID,
          name: roomData['name'] as String,
          limit: roomData['limit'] as int?,
          type: RoomType.values[roomData['type'] as int],
        ));
        group.rooms?.refresh();

        log('$socketPREFIX[ROOM_CREATED] ${roomData['name']} (group $groupID)');
      } catch (e) {
        log('${socketPREFIX}Hata (room_created): $e');
      }
    });

    socket.on('USER_LIST', (data) {
      try {
        var json = jsonDecode(data);
        log("${socketPREFIX}Member Count ${json.length}");

        // Online kullanıcı ID seti — sonunda offline olanları temizlemek için
        final Set<int?> onlineIds = {};

        for (var element in json) {
          Room? userRoom;
          if (element['room'] != null) {
            userRoom = Room.fromJson(element['room']);
          }

          Player userInfo = Player.fromJson(element['clientId']);
          onlineIds.add(userInfo.user.userID);

          for (var groupfetch in groups.value!) {
            final groupMember =
                _findMember(groupfetch.groupmembers, userInfo.user.userID);
            if (groupMember == null) continue;

            // Profil ve oda bilgisini güncelle
            groupMember.user.value = userInfo;
            groupMember.currentRoom.value = userRoom;

            // Kullanıcıyı bu gruptaki tüm odalardan çıkar
            for (var room in groupfetch.rooms!) {
              room.currentMembers
                  .removeWhere((m) => m.user.userID == userInfo.user.userID);
            }

            if (userRoom != null && userRoom.groupID == groupfetch.groupID) {
              // Oda listede yoksa ekle
              if (!groupfetch.rooms!.any((r) => r.roomID == userRoom!.roomID)) {
                groupfetch.rooms!.add(userRoom);
              }
              // Doğru odaya yerleştir
              final targetRoom = groupfetch.rooms!
                  .firstWhereOrNull((r) => r.roomID == userRoom!.roomID);
              if (targetRoom != null &&
                  !targetRoom.currentMembers
                      .any((m) => m.user.userID == userInfo.user.userID)) {
                targetRoom.currentMembers.add(userInfo);
              }
            }
          }
        }

        // Offline olan üyelerin oda bilgisini ve room.currentMembers'ını temizle
        for (var groupfetch in groups.value!) {
          for (var member in groupfetch.groupmembers ?? <Groupmember>[]) {
            if (!onlineIds.contains(member.user.value.user.userID)) {
              member.currentRoom.value = null;
            }
          }
          for (var room in groupfetch.rooms ?? <Room>[]) {
            room.currentMembers
                .removeWhere((m) => !onlineIds.contains(m.user.userID));
          }
          groupfetch.groupmembers?.refresh();
        }
        groups.refresh();
      } catch (e) {
        log('${socketPREFIX}Hata (USER_LIST): $e');
      }
    });

    // Otomatik olarak bağlanma
    socket.connect();

    // return this;
  }

  void initgroup() {
    // Tüm grupları dolaş
    for (var groupfetch in groups.value!) {
      //
      // Eğer groupmembers null veya boşsa, yeni bir RxList oluştur
      groupfetch.groupmembers ??= RxList<Groupmember>();

      //Eğer Grup Odaları null ise bir Listeye dönüştür
      groupfetch.rooms ??= RxList<Room>();
    }
  }

  void resetgroup() {
    // Tüm grupları dolaş
    for (var groupfetch in groups.value!) {
      //
      // Eğer groupmembers null veya boşsa, yeni bir RxList oluştur
      groupfetch.groupmembers = RxList<Groupmember>();
    }
  }

  void removeNonMatchingUsers(
      Group group, List<Map<Player, Room?>> groupCurrentmemberList) {
    // groupCurrentmemberList içindeki User'ları bir sete dönüştür
    var currentUsers =
        groupCurrentmemberList.map((entry) => entry.keys.first).toSet();

    // Aktif Olmayan Kullanıcıları Grupta Çevrimdışı Yap
    group.groupmembers!.removeWhere(
      (element) => !currentUsers.any(
          (user) => user.user.userName == element.user.value.user.userName),
    );

    for (Room rooms in group.rooms!) {
      rooms.currentMembers.removeWhere(
        (element) => !currentUsers
            .any((user) => user.user.userName == element.user.userName),
      );
    }
  }

  // ─── YARDIMCI: kullanıcı state güncellemeleri ────────────────────────────

  // RxList üzerinde firstWhereOrNull extension'ı çalışmadığı için for-loop ile arama
  String _stateLog() {
    if (AppList.sessions.isEmpty) return '[no session]';
    final u = AppList.sessions.first.currentUser;
    final room = findmyRoomanyWhereGroup();
    final mic = u.microphone.value ? 'mic:on' : 'mic:off';
    final spk = u.speaker.value ? 'spk:on' : 'spk:off';
    final cam = u.camera.value ? 'cam:on' : 'cam:off';
    final roomName = room?.name.value ?? 'no room';
    return '[$mic | $spk | $cam | $roomName]';
  }

  Groupmember? _findMember(RxList<Groupmember>? members, int? userID) {
    if (members == null || userID == null) return null;
    for (final m in members) {
      if (m.user.value.user.userID == userID) return m;
    }
    return null;
  }

  void _updateUserMicState(int userID, bool micActive) {
    if (groups.value == null) return;
    for (final group in groups.value!) {
      for (final member in group.groupmembers ?? <Groupmember>[]) {
        if (member.user.value.user.userID == userID) {
          member.user.value.microphone.value = micActive;
        }
      }
      for (final room in group.rooms ?? <Room>[]) {
        for (final player in room.currentMembers) {
          if (player.user.userID == userID) {
            player.microphone.value = micActive;
          }
        }
      }
    }
  }

  void _updateUserSpeakerState(int userID, bool speakerOn) {
    if (groups.value == null) return;
    for (final group in groups.value!) {
      for (final member in group.groupmembers ?? <Groupmember>[]) {
        if (member.user.value.user.userID == userID) {
          member.user.value.speaker.value = speakerOn;
        }
      }
      for (final room in group.rooms ?? <Room>[]) {
        for (final player in room.currentMembers) {
          if (player.user.userID == userID) {
            player.speaker.value = speakerOn;
          }
        }
      }
    }
  }

  void _updateUserCameraState(int userID, bool cameraOn) {
    if (groups.value == null) return;
    for (final group in groups.value!) {
      for (final member in group.groupmembers ?? <Groupmember>[]) {
        if (member.user.value.user.userID == userID) {
          member.user.value.camera.value = cameraOn;
        }
      }
      for (final room in group.rooms ?? <Room>[]) {
        for (final player in room.currentMembers) {
          if (player.user.userID == userID) {
            player.camera.value = cameraOn;
          }
        }
      }
    }
  }

  void _updateUserSpeaking(int userID, bool speaking) {
    if (groups.value == null) return;
    for (final group in groups.value!) {
      for (final member in group.groupmembers ?? <Groupmember>[]) {
        if (member.user.value.user.userID == userID) {
          member.user.value.isSpeaking.value = speaking;
        }
      }
      for (final room in group.rooms ?? <Room>[]) {
        for (final player in room.currentMembers) {
          if (player.user.userID == userID) {
            player.isSpeaking.value = speaking;
          }
        }
      }
    }
  }

  void _removeUserFromAllRooms(int userID) {
    if (groups.value == null) return;

    for (final group in groups.value!) {
      for (final member in group.groupmembers ?? <Groupmember>[]) {
        if (member.user.value.user.userID == userID) {
          member.currentRoom.value = null;
          member.user.value.isSpeaking.value = false;
        }
      }

      for (final room in group.rooms ?? <Room>[]) {
        room.currentMembers
            .removeWhere((player) => player.user.userID == userID);
      }

      group.groupmembers?.refresh();
      group.rooms?.refresh();
    }
    groups.refresh();
  }

  // Socket.io ile mesaj gönderme
  Future<void> sendMessage(String messageValue, Room room) async {
    final normalizedMessage = messageValue.trim();
    if (normalizedMessage.isEmpty || AppList.sessions.isEmpty) {
      return;
    }

    GroupRoomChatsSendResponse response;
    try {
      response = await ARMOYU.service.groupServices.groupRoomChatSend(
        roomID: room.roomID,
        content: normalizedMessage,
      );
    } catch (e) {
      log('${socketPREFIX}Hata (sendMessage): $e');
      return;
    }

    if (!response.result.status || response.response == null) {
      return;
    }

    GroupRoomChat chat = response.response!;

    var selectedGroup =
        groups.value!.firstWhere((group) => group.groupID == room.groupID);
    var selectedRoom =
        selectedGroup.rooms!.firstWhere((r) => r.roomID == room.roomID);

    Message message = Message(
      id: chat.chatID,
      user: AppList.sessions.first.currentUser,
      message: normalizedMessage,
      datetime: chat.date,
      room: room,
    );
    selectedRoom.message.add(message);

    socket.emit("chat", message.toJson());
  }

  void sendAudio(Uint8List base64Audio) {
    if (AppList.sessions.isEmpty ||
        AppList.sessions.first.currentUser.user.userID == null) {
      return;
    }

    AudioModel audiomodel = AudioModel(
      userID: AppList.sessions.first.currentUser.user.userID!,
      base64Audio: base64Audio,
    );

    socket.emit("audio", audiomodel.toJson());
  }

  // Socket.io birisini arama
  Future<void> callUser(Player user) async {
    // Yerel medya akışını RTCPeerConnection'a ekle
    // localStream!.getTracks().forEach((track) {
    //   _rtcPeerConnection!.addTrack(track, localStream!);
    // });

    // RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();
    // await _rtcPeerConnection!.setLocalDescription(offer);

    // RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

    // set SDP offer as remoteDescription for peerConnection
    // await _rtcPeerConnection!.setRemoteDescription(
    //   RTCSessionDescription(offer.toMap()["sdp"], offer.toMap()["type"]),
    // );

    // socket.emit("CALL_USER", {user.username, offer.toMap()});
  }

  // Socket.io  arama reddetme
  void closecall(String username) {
    socket.emit("CLOSE_CALL", username);

    whichuserisCallingMe.value = "";
    isCallingMe.value = false;
  }

  // Socket.io  arama açma
  void acceptcall(String username) {
    socket.emit("ACCEPT_CALL", username);

    whichuserisCallingMe.value = "";
    isCallingMe.value = false;
  }

  // Kullanıcıyı sunucuya kaydetme
  void registerUser(String name, dynamic clientId) {
    socket.emitWithAck('REGISTER', {
      'name': name,
      'clientId': clientId,
      "groups": AppList.groups.map((g) => g.groupID).toList(),
    }, ack: (data) {
      log('${socketPREFIX}REGISTER ack: $data ${_stateLog()}');
    });
  }

  Future<void> fetchUserList({int? groupID}) async {
    if (groupID == null) {
      for (final group in AppList.groups) {
        await fetchUserList(groupID: group.groupID);
      }
      return;
    }

    // Sunucudan kullanıcı listesi isteme

    GroupUsersResponse response;
    try {
      response =
          await ARMOYU.service.groupServices.groupusersFetch(groupID: groupID);
    } catch (e) {
      log('${socketPREFIX}Hata (fetchUserList): $e');
      return;
    }

    if (!response.result.status || response.response == null) {
      return;
    }

    Group? group =
        AppList.groups.firstWhereOrNull((group) => group.groupID == groupID);
    if (group == null) {
      return;
    }

    group.groupmembers ??= RxList([]);

    final apiIds = response.response!.user.map((e) => e.userID).toSet();

    // Listeden ayrılanları kaldır (API'de artık yok)
    group.groupmembers!.removeWhere(
      (m) => !apiIds.contains(m.user.value.user.userID),
    );

    for (UserInfo element in response.response!.user) {
      final existing = _findMember(group.groupmembers, element.userID);
      if (existing != null) {
        // Var olan üyenin profil bilgisini güncelle, oda/socket state'i koru
        existing.user.value.user.userName?.value = element.username ?? '';
        existing.user.value.user.displayName?.value = element.displayname;
        existing.user.value.user.avatar?.mediaURL.minURL.value =
            element.avatar.minURL;
        existing.user.value.user.avatar?.mediaURL.normalURL.value =
            element.avatar.normalURL;
        existing.user.value.user.avatar?.mediaURL.bigURL.value =
            element.avatar.bigURL;
      } else {
        // Yeni üye ekle
        group.groupmembers!.add(
          Groupmember(
            user: Player(
              user: User(
                userID: element.userID,
                userName: Rx(element.username!),
                displayName: Rx(element.displayname),
                avatar: Media(
                  mediaID: 0,
                  mediaType: MediaType.image,
                  mediaURL: MediaURL(
                    bigURL: Rx(element.avatar.bigURL),
                    normalURL: Rx(element.avatar.normalURL),
                    minURL: Rx(element.avatar.minURL),
                  ),
                ),
              ),
            ).obs,
            description: element.role.toString(),
            status: 1,
          ),
        );
      }
    }

    group.groupmembers!.refresh();

    socket.emit('USER_LIST', {
      "groupID": groupID,
    });
  }

  void startPing(Duration interval) {
    pingTimer = Timer.periodic(interval, (timer) {
      if (AppList.sessions.isEmpty ||
          AppList.sessions.first.currentUser.user.userID == null) {
        return;
      }

      pingID.value = DateTime.now().millisecondsSinceEpoch.toString() +
          AppList.sessions.first.currentUser.user.userID.toString();
      // log('Ping gönderiliyor... ID: ${pingID.value}');

      lastPingTime = DateTime.now();
      socket.emit('ping', {'id': pingID.value}); // ID ile ping gönder
    });
  }

  void stopPing() {
    // Timer durdurma (iptal etme)
    if (pingTimer != null) {
      pingTimer!.cancel();
      pingTimer = null;
    }
  }

  void exitroom() {
    if (groups.value == null || AppList.sessions.isEmpty) {
      return;
    }

    for (var groupInfo in groups.value!) {
      //Oda yoksa bakma
      if (groupInfo.rooms == null) {
        continue;
      }
      for (var room in groupInfo.rooms!) {
        room.currentMembers.removeWhere(
          (member) =>
              member.user.userName!.value ==
              AppList.sessions.first.currentUser.user.userName!.value,
        );
      }
    }
  }

  void micOnOff(Player user) {
    final newMicState = !user.microphone.value;
    final event = newMicState ? 'MIC_UNMUTE' : 'MIC_MUTE';

    socket.emitWithAck(event, null, ack: (data) {
      user.microphone.value = newMicState;
      voiceService.setMicrophoneEnabled(newMicState);
      if (newMicState && user.speaker.value == false) {
        user.speaker.value = true;
        voiceService.setSpeakerEnabled(true);
      }
      userUpdate(user);
      log('$socketPREFIX$event ack: $data ${_stateLog()}');
    });
  }

  void speakerOnOff(Player user) {
    final newSpeakerState = !user.speaker.value;
    final event = newSpeakerState ? 'SPEAKER_UNMUTE' : 'SPEAKER_MUTE';

    socket.emitWithAck(event, null, ack: (data) {
      user.speaker.value = newSpeakerState;
      voiceService.setSpeakerEnabled(newSpeakerState);
      userUpdate(user);
      log('$socketPREFIX$event ack: $data ${_stateLog()}');
    });
  }

  Future<void> cameraOnOff(Player user) async {
    final newCameraState = !user.camera.value;
    final success = await voiceService.setCameraEnabled(newCameraState);
    if (!success) {
      log('${socketPREFIX}Kamera durumu değiştirilemedi ${_stateLog()}');
      return;
    }

    user.camera.value = newCameraState;
    _updateUserCameraState(user.user.userID ?? -1, newCameraState);
    userUpdate(user);
    log('${socketPREFIX}CAMERA_${newCameraState ? "ON" : "OFF"} ${_stateLog()}');
  }

  void changeroom(Room? room) {
    if (AppList.sessions.isEmpty) {
      return;
    }

    exitroom();
    if (room == null) {
      unawaited(voiceService.leave());
    }

    if (room != null) {
      roomchats(room);
      room.currentMembers.add(AppList.sessions.first.currentUser);
      player.play(AssetSource("sounds/join_room.wav"));
    } else {
      // Kanaldan çıkıldığında ses yayınını durdur
      socket.emit('AUDIO_STOP');
      player.play(AssetSource("sounds/leave_room.wav"));
    }

    try {
      log('${socketPREFIX}changeRoom -> ${room?.name.value ?? 'null'}');
      socket.emitWithAck('changeRoom', room?.toJson(), ack: (data) {
        log('${socketPREFIX}changeRoom ack: $data ${_stateLog()}');
        if (room != null && data is Map && data['status'] == 'ok') {
          unawaited(
            voiceService.join(
              room,
              restoreCamera: AppList.sessions.first.currentUser.camera.value,
            ),
          );
        }
      });
    } catch (e) {
      log('${socketPREFIX}Hata(changeRoom) $e');
    }
  }

  Future<void> roomchats(Room room) async {
    GroupRoomChatsResponse response;
    try {
      response = await ARMOYU.service.groupServices.groupRoomChats(
        roomID: room.roomID,
      );
    } catch (e) {
      log('${socketPREFIX}Hata (roomchats): $e');
      return;
    }

    if (!response.result.status || response.response == null) {
      return;
    }

    room.message.value = [];
    for (GroupRoomChat element in response.response!) {
      Group groupINFO =
          AppList.groups.firstWhere((group) => group.groupID == room.groupID);
      Groupmember? senderINFO = groupINFO.groupmembers!.firstWhereOrNull(
          (user) => user.user.value.user.userID == element.sender);
      room.message.add(
        Message(
          id: element.chatID,
          user: Player(
            user: User(
              userID: element.sender,
              displayName: senderINFO == null
                  ? "Çıkarılan Kullanıcı".obs
                  : senderINFO.user.value.user.displayName,
              avatar: Media(
                mediaID: 0,
                mediaType: MediaType.image,
                mediaURL: MediaURL(
                  bigURL: Rx(
                    "https://storage.aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png",
                  ),
                  normalURL: Rx(
                    "https://storage.aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png",
                  ),
                  minURL: Rx(
                    "https://storage.aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png",
                  ),
                ),
              ),
            ),
          ),
          message: element.content,
          datetime: element.date,
          room: room,
        ),
      );
    }
  }

  void userUpdate(Player user) {
    try {
      log("Bilgiler Güncellendi");

      socket.emit('profileUpdate', user.toJson());
    } catch (e) {
      log("${socketPREFIX}Hata(changeRoom) $e");
    }
  }

////////
  void startFetchingUserList(Duration interval) {
    fetchUserList();

    userListTimer = Timer.periodic(interval, (timer) {
      fetchUserList();
    });
  }

  void stopFetchingUserList() {
    // Timer durdurma (iptal etme)
    if (userListTimer != null) {
      userListTimer!.cancel();
      userListTimer = null;
    }
  }

  //
  Future<void> createRoom(String roomName, Group userCurrentgroup) async {
    Get.back();
    final normalizedName = roomName.trim();
    if (normalizedName.isEmpty) {
      return;
    }

    var currentgroup = findcurrentGroup(userCurrentgroup);

    currentgroup.rooms ??= RxList<Room>();

    GroupCreateRoomResponse response;
    try {
      response = await ARMOYU.service.groupServices.groupRoomCreate(
        groupID: currentgroup.groupID,
        roomName: normalizedName,
      );
    } catch (e) {
      log('${socketPREFIX}Hata (createRoom): $e');
      return;
    }

    if (!response.result.status || response.response == null) {
      return;
    }

    final newRoom = Room(
      groupID: currentgroup.groupID,
      roomID: response.response!.roomID,
      name: response.response!.name,
      limit: response.response!.limit,
      type: response.response!.type,
    );
    currentgroup.rooms!.add(newRoom);

    socket.emit('room_created', newRoom.toJson());
  }

  Future<void> deleteRoom(Room room, Group userCurrentgroup) async {
    var currentgroup = findcurrentGroup(userCurrentgroup);

    currentgroup.rooms ??= RxList<Room>();

    ServiceResult response;
    try {
      response = await ARMOYU.service.groupServices
          .groupRoomDelete(roomID: room.roomID);
    } catch (e) {
      log('${socketPREFIX}Hata (deleteRoom): $e');
      return;
    }

    if (!response.status) {
      return;
    }

    currentgroup.rooms!
        .removeWhere((selectedroom) => room.roomID == selectedroom.roomID);

    socket.emit('room_deleted', room.toJson());
  }

  bool isInRoom(Group userCurrentgroup) {
    if (AppList.sessions.isEmpty) {
      return false;
    }

    var currentgroup = findcurrentGroup(userCurrentgroup);

    // Oda listesi null veya boş mu kontrol edin
    if (currentgroup.rooms == null || currentgroup.rooms!.isEmpty) {
      return false; // Oda yoksa false döner
    }

    return currentgroup.rooms!.any(
      (element) => element.currentMembers.any(
        (element2) =>
            element2.user.userName!.value ==
            AppList.sessions.first.currentUser.user.userName!.value,
      ),
    );
  }

  bool isInRoomanyWhereGroup() {
    if (groups.value == null || AppList.sessions.isEmpty) {
      return false;
    }

    return groups.value!.any(
      (element) => (element.rooms ?? <Room>[].obs).any(
        (element2) => element2.currentMembers.any(
          (element3) =>
              element3.user.userName!.value ==
              AppList.sessions.first.currentUser.user.userName!.value,
        ),
      ),
    );
  }

  Group findcurrentGroup(Group userCurrentgroup) {
    return groups.value?.firstWhereOrNull(
          (element) => element == userCurrentgroup,
        ) ??
        userCurrentgroup;
  }

  Group findanyWhereGroup() {
    return groups.value!.firstWhere(
      (element) => (element.rooms ?? <Room>[].obs).any(
        (element2) => element2.currentMembers.any(
          (element3) =>
              element3.user.userName!.value ==
              AppList.sessions.first.currentUser.user.userName!.value,
        ),
      ),
    );
  }

  Room? findmyRoom(Group userCurrentgroup) {
    var currentgroup = findcurrentGroup(userCurrentgroup);

    if (isInRoom(userCurrentgroup) == true) {
      return currentgroup.rooms!.firstWhere(
        (element) => element.currentMembers.any(
          (element2) =>
              element2.user.userName!.value ==
              AppList.sessions.first.currentUser.user.userName!.value,
        ),
      );
    }

    return null;
  }

  Room? findmyRoomanyWhereGroup() {
    if (isInRoomanyWhereGroup() == true) {
      for (var group in groups.value!) {
        try {
          // Eğer kullanıcı bu grubun odalarından birindeyse o odayı döndür
          var room = group.rooms!.firstWhere(
            (room) => room.currentMembers.any(
              (member) =>
                  member.user.userName!.value ==
                  AppList.sessions.first.currentUser.user.userName!.value,
            ),
          );
          return room; // Kullanıcının bulunduğu odayı bulunca döndür
        } catch (e) {
          // Odalar arasında bulamazsa, döngü devam eder
          continue;
        }
      }
    }
    return null;
  }
}
