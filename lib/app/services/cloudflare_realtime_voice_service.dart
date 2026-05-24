import 'dart:async';
import 'dart:developer';

import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CloudflareRealtimeVoiceService extends GetxService {
  static const _prefix = '||VOICE|| -> ';
  static const _iceServers = [
    {'urls': 'stun:stun.cloudflare.com:3478'},
  ];

  io.Socket? _socket;
  webrtc.RTCPeerConnection? _peerConnection;
  webrtc.MediaStream? _localStream;
  Room? _currentRoom;
  String? _sessionId;
  String? _localTrackName;
  Future<void> _negotiationQueue = Future.value();

  final isConnecting = false.obs;
  final isJoined = false.obs;
  final connectionState = Rxn<webrtc.RTCPeerConnectionState>();
  final remoteStreams = <webrtc.MediaStream>[].obs;

  void attachSocket(io.Socket socket) {
    _socket = socket;

    socket.off('voice:session');
    socket.off('voice:publish-answer');
    socket.off('voice:track-added');
    socket.off('voice:subscribe-offer');
    socket.off('voice:track-removed');

    socket.on('voice:session', _handleSession);
    socket.on('voice:publish-answer', _handlePublishAnswer);
    socket.on('voice:track-added', _handleTrackAdded);
    socket.on('voice:subscribe-offer', _handleSubscribeOffer);
    socket.on('voice:track-removed', _handleTrackRemoved);
  }

  Future<void> join(Room room) async {
    if (_socket == null || AppList.sessions.isEmpty) {
      return;
    }

    if (_currentRoom?.roomID == room.roomID && isJoined.value) {
      return;
    }

    await leave(sendEvent: _currentRoom != null);
    _currentRoom = room;
    isConnecting.value = true;

    try {
      await _ensurePeerConnection();
      _socket!.emitWithAck(
        'voice:join',
        {
          'groupID': room.groupID,
          'roomID': room.roomID,
        },
        ack: (data) {
          _handleSession(data);
        },
      );
    } catch (e) {
      log('${_prefix}Odaya sesli katılım başlatılamadı: $e');
      await leave(sendEvent: true);
    }
  }

  Future<void> rejoinAfterReconnect() async {
    final room = _currentRoom;
    if (room == null) {
      return;
    }

    await _closePeerConnection(stopLocal: true);
    _sessionId = null;
    _localTrackName = null;
    isJoined.value = false;
    await join(room);
  }

  Future<void> leave({bool sendEvent = true}) async {
    if (sendEvent) {
      _socket?.emit('voice:leave');
    }

    await _closePeerConnection(stopLocal: true);
    _sessionId = null;
    _localTrackName = null;
    _currentRoom = null;
    isConnecting.value = false;
    isJoined.value = false;
  }

  void setMicrophoneEnabled(bool enabled) {
    for (final track in _localStream?.getAudioTracks() ?? []) {
      track.enabled = enabled;
    }
  }

  void setSpeakerEnabled(bool enabled) {
    for (final stream in remoteStreams) {
      for (final track in stream.getAudioTracks()) {
        track.enabled = enabled;
      }
    }
  }

  Future<void> _ensurePeerConnection() async {
    if (_peerConnection != null) {
      return;
    }

    _localStream = await webrtc.navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    _peerConnection = await webrtc.createPeerConnection({
      'iceServers': _iceServers,
    });

    for (final track in _localStream!.getAudioTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }

    _peerConnection!.onTrack = (event) {
      if (event.track.kind != 'audio' || event.streams.isEmpty) {
        return;
      }

      final stream = event.streams.first;
      if (!remoteStreams.any((item) => item.id == stream.id)) {
        remoteStreams.add(stream);
      }

      if (AppList.sessions.isNotEmpty &&
          AppList.sessions.first.currentUser.speaker.value == false) {
        setSpeakerEnabled(false);
      }
    };

    _peerConnection!.onConnectionState = (state) {
      connectionState.value = state;
      if (kDebugMode) {
        log('${_prefix}Connection state: $state');
      }
    };
  }

  Future<void> _publishLocalAudioTrack() async {
    if (_socket == null ||
        _peerConnection == null ||
        _sessionId == null ||
        _currentRoom == null ||
        _localTrackName != null) {
      return;
    }

    final currentUser = AppList.sessions.first.currentUser;
    final userID = currentUser.user.userID ?? currentUser.user.userName?.value;
    _localTrackName =
        'room-${_currentRoom!.groupID}-${_currentRoom!.roomID}-user-$userID-mic';

    final offer = await _peerConnection!.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': false,
    });
    await _peerConnection!.setLocalDescription(offer);

    _socket!.emitWithAck(
      'voice:publish-offer',
      {
        'sessionId': _sessionId,
        'roomID': _currentRoom!.roomID,
        'groupID': _currentRoom!.groupID,
        'trackName': _localTrackName,
        'sessionDescription': offer.toMap(),
        'tracks': [
          {
            'location': 'local',
            'trackName': _localTrackName,
            'kind': 'audio',
            'mid': '0',
          }
        ],
      },
      ack: (data) {
        _handlePublishAnswer(data);
      },
    );
  }

  void _handleSession(dynamic data) {
    final payload = _asMap(data);
    if (payload == null) {
      return;
    }

    final sessionId = payload['sessionId']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      log('${_prefix}voice:session sessionId eksik: $payload');
      return;
    }

    _sessionId = sessionId;
    isJoined.value = true;
    isConnecting.value = false;

    unawaited(_publishLocalAudioTrack());

    final existingTracks = payload['existingTracks'];
    if (existingTracks is List) {
      for (final track in existingTracks) {
        _subscribeToTrack(track);
      }
    }
  }

  void _handlePublishAnswer(dynamic data) {
    final payload = _asMap(data);
    final sessionDescription = _asMap(payload?['sessionDescription']);
    if (sessionDescription == null) {
      return;
    }

    _queueNegotiation(() async {
      await _setRemoteDescription(sessionDescription);
    });
  }

  void _handleTrackAdded(dynamic data) {
    final payload = _asMap(data);
    if (payload == null) {
      return;
    }

    final remoteSessionId = payload['sessionId']?.toString() ??
        payload['remoteSessionId']?.toString();
    if (remoteSessionId == null || remoteSessionId == _sessionId) {
      return;
    }

    _subscribeToTrack(payload);
  }

  void _handleSubscribeOffer(dynamic data) {
    final payload = _asMap(data);
    final sessionDescription = _asMap(payload?['sessionDescription']);
    if (sessionDescription == null || _socket == null || _sessionId == null) {
      return;
    }

    _queueNegotiation(() async {
      await _setRemoteDescription(sessionDescription);
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      _socket!.emit('voice:subscribe-answer', {
        'sessionId': _sessionId,
        'sessionDescription': answer.toMap(),
      });
    });
  }

  void _handleTrackRemoved(dynamic data) {
    final payload = _asMap(data);
    if (kDebugMode) {
      log('${_prefix}Track removed: $payload');
    }
  }

  void _subscribeToTrack(dynamic rawTrack) {
    final track = _asMap(rawTrack);
    if (track == null || _socket == null || _sessionId == null) {
      return;
    }

    final remoteSessionId =
        track['sessionId']?.toString() ?? track['remoteSessionId']?.toString();
    final trackName = track['trackName']?.toString();

    if (remoteSessionId == null ||
        remoteSessionId == _sessionId ||
        trackName == null ||
        trackName == _localTrackName) {
      return;
    }

    _socket!.emitWithAck(
      'voice:subscribe',
      {
        'sessionId': _sessionId,
        'remoteSessionId': remoteSessionId,
        'trackName': trackName,
        'kind': 'audio',
      },
      ack: (data) {
        _handleSubscribeOffer(data);
      },
    );
  }

  void _queueNegotiation(Future<void> Function() action) {
    _negotiationQueue = _negotiationQueue.then((_) => action()).catchError((e) {
      log('${_prefix}Negotiation hatası: $e');
    });
  }

  Future<void> _setRemoteDescription(Map<String, dynamic> description) async {
    if (_peerConnection == null) {
      return;
    }

    final sdp = description['sdp']?.toString();
    final type = description['type']?.toString();
    if (sdp == null || type == null) {
      return;
    }

    await _peerConnection!.setRemoteDescription(
      webrtc.RTCSessionDescription(sdp, type),
    );
  }

  Future<void> _closePeerConnection({required bool stopLocal}) async {
    if (stopLocal) {
      for (final track in _localStream?.getTracks() ?? []) {
        await track.stop();
      }
      await _localStream?.dispose();
      _localStream = null;
    }

    await _peerConnection?.close();
    await _peerConnection?.dispose();
    _peerConnection = null;
    connectionState.value = null;
    remoteStreams.clear();
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return null;
  }
}
