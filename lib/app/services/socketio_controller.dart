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
import 'package:armoyu_desktop/app/utils/applist.dart';
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
          print("Microphone: ${mic.label} ${mic.deviceId}");
        }
      }

      return microphones;
    } catch (e) {
      if (kDebugMode) {
        print("Error listing microphones: $e");
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
        print("Using new microphone: $deviceId");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error selecting microphone: $e");
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
    socket = IO.io('http://socket.armoyu.com:2021', <String, dynamic>{
      // socket = IO.io('http://localhost:2021', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Her 1 saniyede bir kullanıcı listesini iste
    startFetchingUserList(const Duration(minutes: 1));
    // Her 1 saniyede bir kullanıcı listesini iste

    startPing(const Duration(seconds: 2));
    // Ping değerini güncelle
    socket.on('ping', (data) {
      // Burada data yerine ping zamanı verilmez.
      pingValue.value = data; // Bu satırda hata var
      log('${socketPREFIX}Ping: ${pingValue.value} ms'); // Log ile göster
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
        // log('Pong yanıtı alındı: $pingId');
        log('Live📡Ping süresi: ${pingValue.value} ms');

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
        print('Signaling verisi alındı: $data');
      }
    });

    //WEBRTC

    // 'offer' olayını dinle
    socket.on('offer', (data) {
      if (kDebugMode) {
        print('Received offer');
      }
      if (data is Map<String, dynamic>) {
        var offer = webrtc.RTCSessionDescription(
          data['sdp'], // SDP verisini al
          data['type'], // Offer veya Answer tipi
        );

        final homecontroller = Get.find<HomeController>();
        // Peer connection'ı remote description olarak ayarlıyoruz
        homecontroller.peerConnection!.setRemoteDescription(offer).then((_) {
          // Remote description ayarlandıktan sonra cevabı oluştur

          homecontroller.createAnswer(offer);
        }).catchError((e) {
          if (kDebugMode) {
            print("Error setting remote description: $e");
          }
        });
      }
    });

    // 'answer' olayını dinle
    socket.on('answer', (data) async {
      if (kDebugMode) {
        print('Received answer');
      }
      // Gelen "answer" ile ilgili işlemler

      var answer = webrtc.RTCSessionDescription(
        data['sdp'], // SDP verisini al
        data['type'], // Offer veya Answer tipi
      );

      final homecontroller = Get.find<HomeController>();
      // Gelen "answer"ı remote description olarak ayarlıyoruz
      try {
        await homecontroller.peerConnection!.setRemoteDescription(answer);
      } catch (e) {
        if (kDebugMode) {
          print("Error setting remote description for answer: $e");
        }
      }
    });

    // 'candidate' olayını dinle
    socket.on('candidate', (data) async {
      if (kDebugMode) {
        print('Received candidate: $data');
      }
      // Gelen "candidate" ile ilgili işlemler
      var candidate = webrtc.RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      // Gelen candidate'ı peer connection'a ekliyoruz
      final homecontroller = Get.find<HomeController>();

      try {
        await homecontroller.peerConnection!.addCandidate(candidate);
      } catch (e) {
        if (kDebugMode) {
          print("Error adding candidate: $e");
        }
      }
      // Gelen "candidate" ile ilgili işlemleri burada yapabilirsiniz
    });

    //WEBRTC

    socket.on('INCOMING_CALL', (data) {
      // Signaling verilerini dinleme

      if (kDebugMode) {
        print('Kullanıcı Seni Arıyor: ${data['callerId']}');
      }

      isCallingMe.value = true;
      whichuserisCallingMe.value = data['callerId'];
    });

    socket.on('CALL_ACCEPTED', (data) {
      // Signaling verilerini dinleme
      if (kDebugMode) {
        print('Çağrı kabul edildi: $data');
      }
    });

    socket.on('CALL_CLOSED', (data) {
      // Signaling verilerini dinleme
      if (kDebugMode) {
        print('Çağrı reddedildi: $data');
      }
    });

    // Başka biri bağlandığında bildiri al
    socket.on('userConnected', (data) {
      if (data != null) {
        log(socketPREFIX + data.toString());
      }
    });
    // Bağlantı başarılı olduğunda
    socket.on('connect', (data) {
      log('${socketPREFIX}Bağlandı');

      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      socketChatStatus.value = true;

      // Kullanıcıyı kaydet
      if (AppList.sessions.isEmpty) return;
      registerUser(
          AppList.sessions.first.currentUser.user.userName!.value.toString(),
          AppList.sessions.first.currentUser.toJson());
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
        final Player user = Player.fromJson(data['user']);
        final Room room = Room.fromJson(data['room']);

        final int groupId = room.groupID;
        final UserEntryActivityType type =
            UserEntryActivityType.values.byName(data["type"]);

        final List<Group> myGroups = AppList.groups;
        if (!myGroups.any((g) => g.groupID == groupId)) {
          return; // Grup bulunamadı
        }

        final Group group =
            groups.value!.firstWhere((g) => g.groupID == groupId);

        Room? destRoom =
            group.rooms?.firstWhereOrNull((r) => r.roomID == room.roomID);

        final int? currentUserId =
            AppList.sessions.first.currentUser.user.userID;

        if (type == UserEntryActivityType.join) {
          if (destRoom == null) {
            group.rooms?.add(room);
            destRoom = room;
          }

          Groupmember groupMember = group.groupmembers!.firstWhere(
              (gm) => gm.user.value.user.userID == user.user.userID);
          groupMember.currentRoom.value = destRoom;

          if (user.user.userID == currentUserId) {
            return;
          }

          destRoom.removeUserFromRooms(user);
          destRoom.currentMembers.add(user);
        } else if (type == UserEntryActivityType.leave) {
          if (destRoom == null) {
            group.rooms?.add(room);
            destRoom = room;
          }

          Groupmember groupMember = group.groupmembers!.firstWhere(
              (gm) => gm.user.value.user.userID == user.user.userID);
          groupMember.currentRoom.value = null;
          destRoom.removeUserFromRooms(user);
        }

        room.currentMembers.refresh();
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
        // print('Sunucudan gelen ham veri: $data');
        Message mm = Message.fromJson(data);
        log("$socketPREFIX${mm.user.value.user.displayName!.value} - ${mm.message}");

        try {
          var selectedGroup = groups.value!
              .firstWhere((group) => group.groupID == mm.room.value?.groupID);
          var selectedRoom = selectedGroup.rooms!.firstWhere(
              (room) => room.name.value == mm.room.value?.name.value);

          selectedRoom.message.add(mm);

          log("Mesaj eklendi: ${mm.message.value}");
        } catch (e) {
          log("Mesaj ekleme hatası: $e");
        }
      } catch (e) {
        log('${socketPREFIX}Hata (chat): $e');
      }
    });

    // // Sunucudan gelen sesleri dinleme
    // socket.on('audio', (base64Audio) {
    //   try {
    //     // print('Sunucudan gelen ham veri: $data');
    //     Uint8List audioBytes = base64Decode(base64Audio);

    //     // //Çalışıyor Kesik Geliyor
    //     AudioPlayerService.playBase64Audio(audioBytes);
    //   } catch (e) {
    //     log('${socketPREFIX}Hata (chat): $e');
    //   }
    // });

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

    socket.on('USER_LIST', (data) {
      try {
        var json = jsonDecode(data);

        log("${socketPREFIX}Member Count ${json.length}");

        List<Map<Player, Room?>> tmpUserList = [];

        //Üyeleri Dolaş
        for (var element in json) {
          Room? userRoom;
          if (element['room'] != null) {
            userRoom = Room.fromJson(element['room']);
          }

          Player userInfo = Player.fromJson(element['clientId']);

          tmpUserList.add({userInfo: userRoom});

          // Tüm grupları dolaş
          for (var groupfetch in groups.value!) {
            //
            bool kullanicivarmi = groupfetch.groupmembers!.any(
              (element) =>
                  element.user.value.user.userName == userInfo.user.userName,
            );

            if (!kullanicivarmi) {
              //Kullanıcı YOKSA LİSTEYE EKLE
              groupfetch.groupmembers!.add(
                Groupmember(
                  user: userInfo.obs,
                  description: "-",
                  status: 0,
                ),
              );
            } else {
              //Kullanıcı VARSA ODASINI GÜNCELLEME İŞLEMLERİ
              var groupMember = groupfetch.groupmembers!.firstWhere(
                (element) =>
                    element.user.value.user.userID == userInfo.user.userID,
              );

              log("Oda adı ${groupMember.currentRoom.value?.name}");

              groupMember.user.value = userInfo;
              groupMember.currentRoom.value = userRoom;
              groupfetch.groupmembers?.refresh();
              groups.refresh();
            }

            //Kullanıcı bir odada mı
            if (userRoom != null) {
              try {
                // Kullanıcıların Odaları Listeleniyor
                bool roomExists = groupfetch.rooms!
                    .any((room) => room.roomID == userRoom!.roomID);

                // Eğer oda clientde listede yoksa, ekle
                if (!roomExists) {
                  if (userRoom.groupID == groupfetch.groupID) {
                    groupfetch.rooms!.add(userRoom);
                  }
                }
              } catch (e) {
                log('${socketPREFIX}Hata (Kullanıcı Odaları Oluşturulamadı) : $e');
              }
              // try {
              //   // Kullanıcının herhangi bir odada olup olmadığını kontrol ediyoruz
              //   bool isUserinRoom = groupfetch.rooms!.any(
              //     (room) => room.currentMembers.any(
              //       (member) => member.username == userInfo.username,
              //     ),
              //   );

              //   //Kullanıcı bir odada
              //   if (isUserinRoom) {
              //     var currentRoom = groupfetch.rooms!.firstWhere(
              //       (room) => room.currentMembers
              //           .any((member) => member.username == userInfo.username),
              //     );

              //     //Kullanıcı bir odada ama doğru odada değil
              //     if (currentRoom != userRoom) {
              //       //Kullanıcıyı yanlış odadan sil

              //       for (var room in groupfetch.rooms!) {
              //         room.currentMembers.removeWhere(
              //             (member) => member.username == userInfo.username);
              //       }

              //       //Doğru Gruptaki odaya yerleştir
              //       if (userRoom.groupID == groupfetch.groupID) {
              //         groupfetch.rooms!
              //             .firstWhere((room) => room.name == userRoom!.name)
              //             .currentMembers
              //             .add(userInfo);
              //       }
              //     }
              //   } else {
              //     //Kullanıcı herhangi bir odada değil odaya eklenecek

              //     //Odaya eklemeden önce yinede gruptaki tüm odalarda Kullanıcının olma ihtimaline karşı silme
              //     for (var room in groupfetch.rooms!) {
              //       room.currentMembers.removeWhere(
              //           (member) => member.username == userInfo.username);
              //     }

              //     if (userRoom.groupID == groupfetch.groupID) {
              //       groupfetch.rooms!
              //           .firstWhere((room) => room.name == userRoom!.name)
              //           .currentMembers
              //           .add(userInfo);
              //     }
              //   }
              // } catch (e) {
              //   log("'${socketPREFIX}Hata (Kullanıcı Odalar) -- $e'");
              // }
            } else {
              //Odalarda değilse Sil
              for (var room in groupfetch.rooms!) {
                room.currentMembers.removeWhere(
                    (member) => member.user.userID == userInfo.user.userID);
              }
            }

            //
            //Online olmayan Kullanıcıları listeden sil
            try {
              if (groupfetch.groupmembers!.isNotEmpty) {
                removeNonMatchingUsers(groupfetch, tmpUserList);
              }
            } catch (e) {
              log('${socketPREFIX}Hata (removeNonMatchingUsers) : $e');
            }
          }
        }
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

  // Socket.io ile mesaj gönderme
  Future<void> sendMessage(String messageValue, Room room) async {
    GroupRoomChatsSendResponse response =
        await ARMOYU.service.groupServices.groupRoomChatSend(
      roomID: room.roomID,
      content: messageValue,
    );

    if (!response.result.status) {
      return;
    }

    GroupRoomChat chat = response.response!;

    var selectedGroup =
        groups.value!.firstWhere((group) => group.groupID == room.groupID);
    var selectedRoom = selectedGroup.rooms!
        .firstWhere((r) => r.roomID == room.roomID);

    Message message = Message(
      id: chat.chatID,
      user: AppList.sessions.first.currentUser,
      message: messageValue,
      datetime: chat.date,
      room: room,
    );
    selectedRoom.message.add(message);

    socket.emit("chat", message.toJson());
  }

  void sendAudio(Uint8List base64Audio) {
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
    socket.emit('REGISTER', {
      'name': name,
      'clientId': clientId,
      "groups": AppList.groups.map((g) => g.groupID).toList(),
    });
  }

  Future<void> fetchUserList({int? groupID}) async {
    // Sunucudan kullanıcı listesi isteme

    GroupUsersResponse response =
        await ARMOYU.service.groupServices.groupusersFetch(groupID: groupID);

    if (!response.result.status) {
      return;
    }

    Group group =
        AppList.groups.firstWhere((group) => group.groupID == groupID);

    group.groupmembers = RxList([]);
    for (UserInfo element in response.response!.user) {
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

    socket.emit('USER_LIST', {
      "groupID": groupID,
    });
  }

  void startPing(Duration interval) {
    pingTimer = Timer.periodic(interval, (timer) {
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
    var speaker = user.speaker;
    var mic = user.microphone;
    mic.value = !mic.value;

    if (mic.value == true && speaker.value == false) {
      speaker.value = true;
    }

    userUpdate(user);
  }

  void speakerOnOff(Player user) {
    var speaker = user.speaker;
    var mic = user.microphone;

    speaker.value = !speaker.value;

    mic.value = speaker.value;

    userUpdate(user);
  }

  void changeroom(Room? room) {
    exitroom();

    if (room != null) {
      roomchats(room);
      room.currentMembers.add(AppList.sessions.first.currentUser);
      player.play(AssetSource("sounds/join_room.wav"));
    } else {
      player.play(AssetSource("sounds/leave_room.wav"));
    }

    try {
      log("oda değiştirildi");

      socket.emit('changeRoom', room?.toJson());
    } catch (e) {
      log("${socketPREFIX}Hata(changeRoom) $e");
    }
  }

  roomchats(Room room) async {
    GroupRoomChatsResponse response =
        await ARMOYU.service.groupServices.groupRoomChats(
      roomID: room.roomID,
    );

    if (!response.result.status) {
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
    var currentgroup = findcurrentGroup(userCurrentgroup);

    currentgroup.rooms ??= RxList<Room>();

    GroupCreateRoomResponse response = await ARMOYU.service.groupServices
        .groupRoomCreate(groupID: currentgroup.groupID, roomName: roomName);

    if (!response.result.status) {
      return;
    }

    currentgroup.rooms!.add(
      Room(
        groupID: currentgroup.groupID,
        roomID: response.response!.roomID,
        name: response.response!.name,
        limit: response.response!.limit,
        type: response.response!.type,
      ),
    );
  }

  Future<void> deleteRoom(Room room, Group userCurrentgroup) async {
    var currentgroup = findcurrentGroup(userCurrentgroup);

    currentgroup.rooms ??= RxList<Room>();

    ServiceResult response =
        await ARMOYU.service.groupServices.groupRoomDelete(roomID: room.roomID);

    if (!response.status) {
      return;
    }

    currentgroup.rooms!
        .removeWhere((selectedroom) => room.roomID == selectedroom.roomID);
  }

  bool isInRoom(Group userCurrentgroup) {
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
    return groups.value!.any(
      (element) => element.rooms!.any(
        (element2) => element2.currentMembers.any(
          (element3) =>
              element3.user.userName!.value ==
              AppList.sessions.first.currentUser.user.userName!.value,
        ),
      ),
    );
  }

  Group findcurrentGroup(Group userCurrentgroup) {
    return groups.value!.firstWhere(
      (element) => element == userCurrentgroup,
    );
  }

  Group findanyWhereGroup() {
    return groups.value!.firstWhere(
      (element) => element.rooms!.any(
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
