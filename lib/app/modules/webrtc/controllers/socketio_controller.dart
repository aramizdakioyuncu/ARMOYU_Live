import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/internetstatus_model.dart';
import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/data/models/user_model.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketioController extends GetxController {
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

// INPUTS OUTPUST VIDEO
  List<MediaDeviceInfo> devices = [];

  List<MediaDeviceInfo> get audioInputs =>
      devices.where((device) => device.kind == 'audioinput').toList();

  List<MediaDeviceInfo> get audioOutputs =>
      devices.where((device) => device.kind == 'audiooutput').toList();

  List<MediaDeviceInfo> get videoInputs =>
      devices.where((device) => device.kind == 'videoinput').toList();

  var isCallingMe = false.obs;
  var whichuserisCallingMe = "".obs;

  final player = AudioPlayer();
//WEBRTC
  final webrtc.RTCVideoRenderer renderer = RTCVideoRenderer();
  var isStreaming = false.obs;
  RTCPeerConnection? pc1;
  var senders = <RTCRtpSender>[];

//WEBRTC

  final speakingvoices = AudioPlayer();

  var isSoundStreaming = false.obs;

  // videoRenderer for remotePeer
  final remoteRTCVideoRenderer = RTCVideoRenderer();

  // mediaStream for localPeer
  MediaStream? localStream;

  // RTC peer connection
  RTCPeerConnection? _rtcPeerConnection;

  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  @override
  void onInit() {
    groups.value = AppList.groups;

    //Grup Odaları ve Üyelerini İnit yapar
    initgroup();

    initRenderer();
    remoteRTCVideoRenderer.initialize();

    _setupPeerConnection();
    main();

    super.onInit();
  }

  @override
  void onClose() {
    stopFetchingUserList();
    stopPing();
    socket.disconnect();
    super.onClose();
  }

  ///
  _setupPeerConnection() async {
    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });

    // socket!.on("IceCandidate", (data) {
    //   String candidate = data["iceCandidate"]["candidate"];
    //   String sdpMid = data["iceCandidate"]["id"];
    //   int sdpMLineIndex = data["iceCandidate"]["label"];

    //   // add iceCandidate
    //   _rtcPeerConnection!.addCandidate(RTCIceCandidate(
    //     candidate,
    //     sdpMid,
    //     sdpMLineIndex,
    //   ));
    // });

    // // set SDP offer as remoteDescription for peerConnection
    // // await _rtcPeerConnection!.setRemoteDescription(
    // //   RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
    // // );

    // // create SDP answer
    // RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

    // // set SDP answer as localDescription for peerConnection
    // _rtcPeerConnection!.setLocalDescription(answer);

    // // send SDP answer to remote peer over signalling
    // socket!.emit("answerCall", {
    //   "callerId": "1",
    //   "sdpAnswer": answer.toMap(),
    // });

    // // listen for remotePeer mediaTrack event
    // _rtcPeerConnection!.onTrack = (event) {
    //   remoteRTCVideoRenderer.srcObject = event.streams[0];
    // };

    // _rtcPeerConnection!.onIceCandidate =
    //     (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

    // socket.on("callAnswered", (data) async {
    //   // set SDP answer as remoteDescription for peerConnection
    //   await _rtcPeerConnection!.setRemoteDescription(
    //     RTCSessionDescription(
    //       data["sdpAnswer"]["sdp"],
    //       data["sdpAnswer"]["type"],
    //     ),
    //   );

    //   // send iceCandidate generated to remote peer over signalling
    //   for (RTCIceCandidate candidate in rtcIceCadidates) {
    //     socket.emit("IceCandidate", {
    //       "calleeId": "1",
    //       "iceCandidate": {
    //         "id": candidate.sdpMid,
    //         "label": candidate.sdpMLineIndex,
    //         "candidate": candidate.candidate
    //       }
    //     });
    //   }
    // });
  }

  ///
  ///
  Future<Uint8List> loadMusicFileAsBytes(String filePath) async {
    // Cihazın yerel dosya sisteminden müzik dosyasını okuyoruz
    File file = File(filePath);
    return await file.readAsBytes();
  }

  Future<void> stopListening() async {
    if (isSoundStreaming.value) {
      isSoundStreaming.value = false;
    }
  }

  ///

  main() {
    // Socket.IO'ya bağlanma
    socket = IO.io('http://mc.armoyu.com:2021', <String, dynamic>{
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
        // log('Ping süresi: ${pingValue.value} ms');

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
      print('Signaling verisi alındı: $data');
    });

    socket.on("IceCandidate", (data) {
      String candidate = data["iceCandidate"]["candidate"];
      String sdpMid = data["iceCandidate"]["id"];
      int sdpMLineIndex = data["iceCandidate"]["label"];

      // add iceCandidate
      _rtcPeerConnection!.addCandidate(RTCIceCandidate(
        candidate,
        sdpMid,
        sdpMLineIndex,
      ));
    });

    socket.on("callAnswered", (data) async {
      // set SDP answer as remoteDescription for peerConnection
      await _rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(
          data["sdpAnswer"]["sdp"],
          data["sdpAnswer"]["type"],
        ),
      );

      // send iceCandidate generated to remote peer over signalling
      for (RTCIceCandidate candidate in rtcIceCadidates) {
        socket.emit("IceCandidate", {
          "calleeId": "1",
          "iceCandidate": {
            "id": candidate.sdpMid,
            "label": candidate.sdpMLineIndex,
            "candidate": candidate.candidate
          }
        });
      }
    });

    socket.on('INCOMING_CALL', (data) {
      // Signaling verilerini dinleme

      print('Kullanıcı Seni Arıyor: ${data['callerId']}');

      Map offer = data['sdpOffer'];

      isCallingMe.value = true;
      whichuserisCallingMe.value = data['callerId'];
    });
    socket.on('CALL_ACCEPTED', (data) {
      // Signaling verilerini dinleme
      print('Çağrı kabul edildi: $data');
    });
    socket.on('CALL_CLOSED', (data) {
      // Signaling verilerini dinleme
      print('Çağrı reddedildi: $data');
    });

    // Başka biri bağlandığında bildiri al
    socket.on('userConnected', (data) {
      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      log(socketPREFIX + data.toString());
    });
    // Bağlantı başarılı olduğunda
    socket.on('connect', (data) {
      log('${socketPREFIX}Bağlandı');

      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      socketChatStatus.value = true;

      // Kullanıcıyı kaydet
      registerUser(AppList.sessions.first.currentUser.username.toString(),
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

    // Sunucudan gelen mesajları dinleme
    socket.on('chat', (data) {
      try {
        // print('Sunucudan gelen ham veri: $data');
        Message mm = Message.fromJson(data);
        log("$socketPREFIX${mm.user.value.displayname} - ${mm.message}");

        try {
          var selectedGroup = groups.value!
              .firstWhere((group) => group.groupID == mm.room.value.groupID);
          var selectedRoom = selectedGroup.rooms!.firstWhere(
              (room) => room.name.value == mm.room.value.name.value);

          selectedRoom.message.add(mm);

          log("Mesaj eklendi: ${mm.message.value}");
        } catch (e) {
          log("Mesaj ekleme hatası: $e");
        }
      } catch (e) {
        log('${socketPREFIX}Hata (chat): $e');
      }
    });

    socket.on('USER_LIST', (data) {
      try {
        var json = jsonDecode(data);

        log("${socketPREFIX}Member Count ${json.length}");

        //Grup Odaları ve Üyelerini reset yapar
        groups.value = AppList.groups;
        resetgroup();

        List<Map<User, Room?>> tmpUserList = [];

        //Üyeleri Dolaş
        for (var element in json) {
          Room? userRoom;
          if (element['room'] != null) {
            userRoom = Room.fromJson(element['room']);
          }

          User userInfo = User.fromJson(element['clientId']);

          tmpUserList.add({userInfo: userRoom});

          // Tüm grupları dolaş
          for (var groupfetch in groups.value!) {
            //
            bool kullanicivarmi = groupfetch.groupmembers!.any(
              (element) => element.user.value.username == userInfo.username,
            );

            if (!kullanicivarmi) {
              //Kullanıcı YOKSA LİSTEYE EKLE
              groupfetch.groupmembers!.add(
                Groupmember(
                  user: userInfo.obs,
                  description: "-",
                  status: 0,
                  currentRoom: userRoom?.obs,
                ),
              );
            } else {
              //Kullanıcı VARSA ODASINI GÜNCELLEME İŞLEMLERİ
              var a = groupfetch.groupmembers!.firstWhere(
                (element) => element.user.value.username == userInfo.username,
              );

              a.user.value = userInfo;

              if (userRoom != null) {
                if (userRoom.groupID == groupfetch.groupID) {
                  a.currentRoom = userRoom.obs;
                }
              } else {
                a.currentRoom = userRoom?.obs;
              }
            }

            //Kullanıcı bir odadaysa
            if (userRoom != null) {
              try {
                // Kullanıcıların Odaları Listeleniyor
                bool roomExists = groupfetch.rooms!
                    .any((room) => room.name == userRoom!.name);

                // Eğer oda clientde listede yoksa, ekle
                if (!roomExists) {
                  if (userRoom.groupID == groupfetch.groupID) {
                    groupfetch.rooms!.add(userRoom);
                  }
                }
              } catch (e) {
                log('${socketPREFIX}Hata (Kullanıcı Odaları Oluşturulamadı) : $e');
              }
              try {
                // Kullanıcının herhangi bir odada olup olmadığını kontrol ediyoruz
                bool isUserinRoom = groupfetch.rooms!.any(
                  (room) => room.currentMembers.any(
                    (member) => member.username == userInfo.username,
                  ),
                );

                //Kullanıcı bir odada
                if (isUserinRoom) {
                  var currentRoom = groupfetch.rooms!.firstWhere(
                    (room) => room.currentMembers
                        .any((member) => member.username == userInfo.username),
                  );

                  //Kullanıcı bir odada ama doğru odada değil
                  if (currentRoom != userRoom) {
                    //Kullanıcıyı yanlış odadan sil

                    for (var room in groupfetch.rooms!) {
                      room.currentMembers.removeWhere(
                          (member) => member.username == userInfo.username);
                    }

                    //Doğru Gruptaki odaya yerleştir
                    if (userRoom.groupID == groupfetch.groupID) {
                      groupfetch.rooms!
                          .firstWhere((room) => room.name == userRoom!.name)
                          .currentMembers
                          .add(userInfo);
                    }
                  }
                } else {
                  //Kullanıcı herhangi bir odada değil odaya eklenecek

                  //Odaya eklemeden önce yinede gruptaki tüm odalarda Kullanıcının olma ihtimaline karşı silme
                  for (var room in groupfetch.rooms!) {
                    room.currentMembers.removeWhere(
                        (member) => member.username == userInfo.username);
                  }

                  if (userRoom.groupID == groupfetch.groupID) {
                    groupfetch.rooms!
                        .firstWhere((room) => room.name == userRoom!.name)
                        .currentMembers
                        .add(userInfo);
                  }
                }
              } catch (e) {
                log("'${socketPREFIX}Hata (Kullanıcı Odalar) -- $e'");
              }
            } else {
              //Odalarda değilse Sil
              for (var room in groupfetch.rooms!) {
                room.currentMembers.removeWhere(
                    (member) => member.username == userInfo.username);
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

    return this;
  }

//WEBRTC

  Future<void> initRenderer() async {
    pc1 ??= await createPeerConnection({});

    await renderer.initialize();
    await startLocalStream();
    // await _initMediaRecorder();
  }

  Future<void> startLocalStream() async {
    // Kamera ve mikrofon için medya akışı başlatılıyor
    localStream = await webrtc.navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user', // Ön kamerayı kullanmak için
      },
    });

    localStream!.getTracks().forEach((track) async {
      var rtpSender = await pc1?.addTrack(track, localStream!);
      log('track.settings ' + track.getSettings().toString());
      senders.add(rtpSender!);
    });

    // Akış, video render'a atanıyor
    renderer.srcObject = localStream;
    isStreaming.value = true; // Akış başladı
  }

//WEBRTC

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
      Group group, List<Map<User, Room?>> groupCurrentmemberList) {
    // groupCurrentmemberList içindeki User'ları bir sete dönüştür
    var currentUsers =
        groupCurrentmemberList.map((entry) => entry.keys.first).toSet();

    // Aktif Olmayan Kullanıcıları Grupta Çevrimdışı Yap
    group.groupmembers!.removeWhere(
      (element) => !currentUsers
          .any((user) => user.username == element.user.value.username),
    );

    for (Room rooms in group.rooms!) {
      rooms.currentMembers.removeWhere(
        (element) =>
            !currentUsers.any((user) => user.username == element.username),
      );
    }
  }

  // Socket.io ile mesaj gönderme
  void sendMessage(Message data) {
    socket.emit("chat", {data.toJson()});
  }

  // Socket.io birisini arama
  Future<void> callUser(User user) async {
    // Yerel medya akışını RTCPeerConnection'a ekle
    localStream!.getTracks().forEach((track) {
      _rtcPeerConnection!.addTrack(track, localStream!);
    });

    RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();
    await _rtcPeerConnection!.setLocalDescription(offer);

    // RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

    // set SDP offer as remoteDescription for peerConnection
    // await _rtcPeerConnection!.setRemoteDescription(
    //   RTCSessionDescription(offer.toMap()["sdp"], offer.toMap()["type"]),
    // );

    socket.emit("CALL_USER", {user.username, offer.toMap()});
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

  void fetchUserList({int? groupID}) {
    // Sunucudan kullanıcı listesi isteme
    socket.emit('USER_LIST', {
      "groupID": groupID,
    });
  }

  void startPing(Duration interval) {
    pingTimer = Timer.periodic(interval, (timer) {
      pingID.value = DateTime.now().millisecondsSinceEpoch.toString() +
          AppList.sessions.first.currentUser.id.toString();
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
              member.username == AppList.sessions.first.currentUser.username,
        );
      }
    }
  }

  void micOnOff(User user) {
    var speaker = user.speaker;
    var mic = user.microphone;
    mic.value = !mic.value;

    if (mic.value == true && speaker.value == false) {
      speaker.value = true;
    }

    userUpdate(user);
  }

  void speakerOnOff(User user) {
    var speaker = user.speaker;
    var mic = user.microphone;

    speaker.value = !speaker.value;

    mic.value = speaker.value;

    userUpdate(user);
  }

  void changeroom(Room? room) {
    exitroom();

    if (room != null) {
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

  void userUpdate(User user) {
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
  void createRoom(Room room, Group userCurrentgroup) {
    Get.back();
    var currentgroup = findcurrentGroup(userCurrentgroup);

    currentgroup.rooms ??= RxList<Room>();

    currentgroup.rooms!.add(room);
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
            element2.username == AppList.sessions.first.currentUser.username,
      ),
    );
  }

  bool isInRoomanyWhereGroup() {
    return groups.value!.any(
      (element) => element.rooms!.any(
        (element2) => element2.currentMembers.any(
          (element3) =>
              element3.username == AppList.sessions.first.currentUser.username,
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
              element3.username == AppList.sessions.first.currentUser.username,
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
              element2.username == AppList.sessions.first.currentUser.username,
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
                  member.username ==
                  AppList.sessions.first.currentUser.username,
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
