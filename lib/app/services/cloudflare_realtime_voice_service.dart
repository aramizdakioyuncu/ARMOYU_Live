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
  static const _localAudioPollInterval = Duration(milliseconds: 100);
  static const _audioLevelThreshold = 0.02;
  static const _audioEnergyThreshold = 0.00015;
  static const _quietSamplesBeforeStop = 2;
  static const _socketAckTimeout = Duration(seconds: 10);

  io.Socket? _socket;
  webrtc.RTCPeerConnection? _peerConnection;
  webrtc.MediaStream? _localStream;
  webrtc.MediaStream? _cameraStream;
  webrtc.RTCRtpSender? _localAudioSender;
  webrtc.RTCRtpSender? _localVideoSender;
  Room? _currentRoom;
  String? _sessionId;
  String? _localAudioTrackName;
  String? _localVideoTrackName;
  bool _restoreCameraAfterJoin = false;
  bool _localSpeaking = false;
  int _quietAudioSamples = 0;
  double? _lastAudioEnergy;
  double? _lastAudioDuration;
  Timer? _localSpeakingTimer;
  final _subscribingTrackNames = <String>{};
  final _subscribedTrackNames = <String>{};
  Future<void> _negotiationQueue = Future.value();

  final _remoteVideoUserByMid = <String, int>{};
  final _pendingVideoUserIds = <int>[];

  final isConnecting = false.obs;
  final isJoined = false.obs;
  final cameraEnabled = false.obs;
  final localVideoReady = false.obs;
  final connectionState = Rxn<webrtc.RTCPeerConnectionState>();
  final remoteStreams = <webrtc.MediaStream>[].obs;
  final localVideoRenderer = webrtc.RTCVideoRenderer();
  final remoteVideoRenderersByUser = <int, webrtc.RTCVideoRenderer>{}.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(_ensureLocalVideoRenderer());
  }

  @override
  void onClose() {
    unawaited(leave(sendEvent: false));
    if (localVideoReady.value) {
      localVideoRenderer.dispose();
    }
    super.onClose();
  }

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
    socket.on('voice:track-removed', _handleTrackRemoved);
  }

  Future<void> preWarm() async {
    if (_peerConnection != null || _socket == null || AppList.sessions.isEmpty) {
      return;
    }
    try {
      await _ensurePeerConnection();
    } catch (e) {
      log('${_prefix}preWarm hatası: $e');
    }
  }

  Future<void> join(Room room, {bool restoreCamera = false}) async {
    if (_socket == null || AppList.sessions.isEmpty) {
      return;
    }

    if (_currentRoom?.roomID == room.roomID && isJoined.value) {
      return;
    }

    if (_currentRoom != null || isJoined.value) {
      log('${_prefix}join: oda değişikliği, eski session kapatılıyor');
      await leave(sendEvent: true, stopLocalMedia: false);
    } else {
      log('${_prefix}join: ilk katılım / pre-warm, session sıfırlanıyor');
      _sessionId = null;
      _localAudioTrackName = null;
      _localVideoTrackName = null;
      isConnecting.value = false;
    }
    _currentRoom = room;
    _restoreCameraAfterJoin = restoreCamera;
    isConnecting.value = true;

    try {
      await _ensurePeerConnection();
      log('${_prefix}join: PC hazır, offer oluşturuluyor');
      final offer = await _peerConnection!.createOffer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });
      await _peerConnection!.setLocalDescription(offer);

      _socket!.emitWithAck(
        'voice:join',
        {
          'groupID': room.groupID,
          'roomID': room.roomID,
          'sessionDescription': offer.toMap(),
        },
        ack: (data) {
          log('${_prefix}voice:join ack alındı');
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

    final shouldRestoreCamera = cameraEnabled.value;
    await _closePeerConnection(stopLocal: true);
    _sessionId = null;
    _localAudioTrackName = null;
    _localVideoTrackName = null;
    isJoined.value = false;
    await join(room, restoreCamera: shouldRestoreCamera);
  }

  Future<void> leave({bool sendEvent = true, bool stopLocalMedia = true}) async {
    if (sendEvent) {
      _socket?.emit('voice:leave');
    }

    await _closePeerConnection(stopLocal: stopLocalMedia);
    _sessionId = null;
    _localAudioTrackName = null;
    _localVideoTrackName = null;
    _currentRoom = null;
    isConnecting.value = false;
    isJoined.value = false;
    cameraEnabled.value = false;
    _restoreCameraAfterJoin = false;
  }

  void setMicrophoneEnabled(bool enabled) {
    for (final track in _localStream?.getAudioTracks() ?? []) {
      track.enabled = enabled;
    }
    if (enabled) {
      _startLocalSpeakingMonitor();
    } else {
      _setLocalSpeaking(false, notifyServer: true);
    }
  }

  void setSpeakerEnabled(bool enabled) {
    for (final stream in remoteStreams) {
      for (final track in stream.getAudioTracks()) {
        track.enabled = enabled;
      }
    }
  }

  Future<bool> setCameraEnabled(bool enabled) async {
    if (enabled) {
      var success = false;
      await _queueNegotiation(() async {
        success = await _enableCamera();
      });
      return success;
    }

    await _stopLocalCamera(sendCloseEvent: true);
    return true;
  }

  Future<void> _ensureLocalVideoRenderer() async {
    if (localVideoReady.value) {
      return;
    }
    await localVideoRenderer.initialize();
    localVideoReady.value = true;
  }

  Future<void> _ensurePeerConnection() async {
    if (_peerConnection != null) {
      return;
    }

    // Oda değişikliğinde mevcut mic stream'i yeniden kullan; getUserMedia gecikmesini atla
    _localStream ??= await webrtc.navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    _peerConnection = await webrtc.createPeerConnection({
      'iceServers': _iceServers,
    });

    final currentUser = AppList.sessions.first.currentUser;
    for (final track in _localStream!.getAudioTracks()) {
      track.enabled = currentUser.microphone.value;
      _localAudioSender = await _peerConnection!.addTrack(track, _localStream!);
    }
    _startLocalSpeakingMonitor();

    _peerConnection!.onTrack = (event) {
      if (event.streams.isEmpty) {
        return;
      }

      final stream = event.streams.first;
      if (!remoteStreams.any((item) => item.id == stream.id)) {
        remoteStreams.add(stream);
      }

      if (event.track.kind == 'video') {
        unawaited(_attachRemoteVideoRenderer(event, stream));
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

  Future<bool> _enableCamera() async {
    if (cameraEnabled.value) {
      return true;
    }
    if (_socket == null ||
        _sessionId == null ||
        _currentRoom == null ||
        AppList.sessions.isEmpty) {
      return false;
    }

    try {
      await _ensurePeerConnection();
      await _ensureLocalVideoRenderer();

      _cameraStream = await webrtc.navigator.mediaDevices.getUserMedia({
        'audio': false,
        'video': true,
      });

      final videoTracks = _cameraStream!.getVideoTracks();
      if (videoTracks.isEmpty) {
        throw StateError('Kamera video track olusturmadi');
      }

      _localVideoSender =
          await _peerConnection!.addTrack(videoTracks.first, _cameraStream!);
      localVideoRenderer.srcObject = _cameraStream;
      cameraEnabled.value = true;

      final currentUser = AppList.sessions.first.currentUser;
      final userID =
          currentUser.user.userID ?? currentUser.user.userName?.value;
      _localVideoTrackName =
          'room-${_currentRoom!.groupID}-${_currentRoom!.roomID}-user-$userID-camera';

      await _publishLocalTrack(
        kind: 'video',
        trackName: _localVideoTrackName!,
        sender: _localVideoSender,
      );
      return true;
    } catch (e) {
      log('${_prefix}Kamera acilamadi: $e');
      await _stopLocalCamera(sendCloseEvent: false);
      return false;
    }
  }

  Future<void> _stopLocalCamera({required bool sendCloseEvent}) async {
    final trackName = _localVideoTrackName;
    if (!cameraEnabled.value && trackName == null && _cameraStream == null) {
      return;
    }

    if (sendCloseEvent && trackName != null && _sessionId != null) {
      _socket?.emit('voice:close-track', {
        'sessionId': _sessionId,
        'trackName': trackName,
      });
    }

    if (_localVideoSender != null && _peerConnection != null) {
      await _peerConnection!.removeTrack(_localVideoSender!);
      await _localVideoSender?.dispose();
    }

    for (final track in _cameraStream?.getTracks() ?? []) {
      await track.stop();
    }
    await _cameraStream?.dispose();

    _cameraStream = null;
    _localVideoSender = null;
    _localVideoTrackName = null;
    if (localVideoReady.value) {
      localVideoRenderer.srcObject = null;
    }
    cameraEnabled.value = false;
  }

  Future<void> _publishLocalAudioTrack() async {
    if (_socket == null ||
        _peerConnection == null ||
        _sessionId == null ||
        _currentRoom == null ||
        _localAudioTrackName != null) {
      return;
    }

    final currentUser = AppList.sessions.first.currentUser;
    final userID = currentUser.user.userID ?? currentUser.user.userName?.value;
    _localAudioTrackName =
        'room-${_currentRoom!.groupID}-${_currentRoom!.roomID}-user-$userID-mic';

    await _publishLocalTrack(
      kind: 'audio',
      trackName: _localAudioTrackName!,
      sender: _localAudioSender,
    );
  }

  Future<void> _publishLocalTrack({
    required String kind,
    required String trackName,
    required webrtc.RTCRtpSender? sender,
  }) async {
    if (_socket == null ||
        _peerConnection == null ||
        _sessionId == null ||
        _currentRoom == null) {
      return;
    }

    final offer = await _peerConnection!.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': true,
    });
    await _peerConnection!.setLocalDescription(offer);

    final mid = await _midForSender(sender) ?? _midForKind(offer.sdp, kind);
    final trackPayload = <String, dynamic>{
      'location': 'local',
      'trackName': trackName,
      'kind': kind,
    };
    if (mid != null && mid.isNotEmpty) {
      trackPayload['mid'] = mid;
    }

    final payload = await _emitWithAckMap('voice:publish-offer', {
      'sessionId': _sessionId,
      'roomID': _currentRoom!.roomID,
      'groupID': _currentRoom!.groupID,
      'trackName': trackName,
      'kind': kind,
      'sessionDescription': offer.toMap(),
      'tracks': [trackPayload],
    });
    if (_isErrorPayload(payload)) {
      throw StateError(
        'Track publish basarisiz: ${payload?['message'] ?? payload}',
      );
    }

    final sessionDescription = _asMap(payload?['sessionDescription']);
    if (sessionDescription != null) {
      await _setRemoteDescription(sessionDescription);
    }
    log('${_prefix}Track publish edildi: $kind $trackName');
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

    if (_sessionId == sessionId && isJoined.value) {
      return;
    }

    _sessionId = sessionId;
    isJoined.value = true;
    isConnecting.value = false;
    log('${_prefix}session alındı: $sessionId');

    final sessionDescription = _asMap(payload['sessionDescription']);
    _queueNegotiation(() async {
      log('${_prefix}publish audio başlıyor');
      if (sessionDescription != null) {
        await _setRemoteDescription(sessionDescription);
      }
      await _publishLocalAudioTrack();
      setMicrophoneEnabled(AppList.sessions.first.currentUser.microphone.value);
      setSpeakerEnabled(AppList.sessions.first.currentUser.speaker.value);
      if (_restoreCameraAfterJoin) {
        _restoreCameraAfterJoin = false;
        await _enableCamera();
      }
    });

    final existingTracks = payload['existingTracks'];
    log('${_prefix}mevcut track sayısı: ${existingTracks is List ? existingTracks.length : 0}');
    if (existingTracks is List && existingTracks.isNotEmpty) {
      _subscribeToTracksBatch(existingTracks);
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

  void _handleTrackRemoved(dynamic data) {
    final payload = _asMap(data);
    final trackName = payload?['trackName']?.toString();
    final userId = _userIdFromTrackName(trackName);

    // Track adını temizle; aksi hâlde aynı adla yeniden katılan kullanıcıya
    // abone olunamaz (_subscribeToTrack erken dönüyor)
    if (trackName != null) {
      _subscribedTrackNames.remove(trackName);
    }

    if (_kindFromTrack(payload) == 'video' && userId != null) {
      unawaited(_removeRemoteVideoRenderer(userId));
    }

    if (kDebugMode) {
      log('${_prefix}Track removed: track=$trackName session=${payload?['sessionId']}');
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
    final kind = _kindFromTrack(track);

    if (remoteSessionId == null ||
        remoteSessionId == _sessionId ||
        trackName == null ||
        trackName == _localAudioTrackName ||
        trackName == _localVideoTrackName ||
        _subscribingTrackNames.contains(trackName) ||
        _subscribedTrackNames.contains(trackName)) {
      return;
    }

    _subscribingTrackNames.add(trackName);
    _queueNegotiation(() async {
      try {
        final payload = await _emitWithAckMap('voice:subscribe', {
          'sessionId': _sessionId,
          'remoteSessionId': remoteSessionId,
          'trackName': trackName,
          'kind': kind,
        });
        await _applySubscribeOffer(payload);
        _subscribedTrackNames.add(trackName);
      } finally {
        _subscribingTrackNames.remove(trackName);
      }
    });
  }

  void _subscribeToTracksBatch(List<dynamic> rawTracks) {
    if (_socket == null || _sessionId == null) return;

    final validTracks = rawTracks
        .map(_asMap)
        .where((t) {
          if (t == null) return false;
          final remoteSessionId =
              t['sessionId']?.toString() ?? t['remoteSessionId']?.toString();
          final trackName = t['trackName']?.toString();
          return remoteSessionId != null &&
              remoteSessionId != _sessionId &&
              trackName != null &&
              trackName != _localAudioTrackName &&
              trackName != _localVideoTrackName &&
              !_subscribingTrackNames.contains(trackName) &&
              !_subscribedTrackNames.contains(trackName);
        })
        .cast<Map<String, dynamic>>()
        .toList();

    if (validTracks.isEmpty) return;

    for (final t in validTracks) {
      _subscribingTrackNames.add(t['trackName'].toString());
    }

    _queueNegotiation(() async {
      try {
        final batchPayload = validTracks
            .map((t) => {
                  'trackName': t['trackName'],
                  'remoteSessionId':
                      t['sessionId']?.toString() ?? t['remoteSessionId']?.toString(),
                  'kind': _kindFromTrack(t),
                })
            .toList();

        final result = await _emitWithAckMap('voice:subscribe-batch', {
          'sessionId': _sessionId,
          'tracks': batchPayload,
        });

        if (result == null || result['sessionDescription'] == null) return;

        final responseTracks = result['tracks'] as List? ?? [];
        for (final t in validTracks) {
          _registerRemoteVideoMapping({
            ...t,
            'tracks': responseTracks,
          });
        }

        await _setRemoteDescription(_asMap(result['sessionDescription'])!);
        final answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        _socket!.emit('voice:subscribe-answer', {
          'sessionId': _sessionId,
          'sessionDescription': answer.toMap(),
        });

        for (final t in validTracks) {
          _subscribedTrackNames.add(t['trackName'].toString());
        }
        log('${_prefix}Batch subscribe tamamlandı: ${validTracks.length} track');
      } finally {
        for (final t in validTracks) {
          _subscribingTrackNames.remove(t['trackName'].toString());
        }
      }
    });
  }

  Future<void> _applySubscribeOffer(Map<String, dynamic>? payload) async {
    if (_isErrorPayload(payload)) {
      throw StateError(
        'Track subscribe basarisiz: ${payload?['message'] ?? payload}',
      );
    }

    final sessionDescription = _asMap(payload?['sessionDescription']);
    if (sessionDescription == null || _socket == null || _sessionId == null) {
      return;
    }

    _registerRemoteVideoMapping(payload!);
    await _setRemoteDescription(sessionDescription);
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    _socket!.emit('voice:subscribe-answer', {
      'sessionId': _sessionId,
      'sessionDescription': answer.toMap(),
    });
    log('${_prefix}Track subscribe edildi: ${payload['trackName']}');
  }

  void _registerRemoteVideoMapping(Map<String, dynamic> payload) {
    final trackName = payload['trackName']?.toString();
    if (_kindFromTrack(payload) != 'video' || trackName == null) {
      return;
    }

    final userId = _userIdFromTrackName(trackName);
    if (userId == null) {
      return;
    }

    var mapped = false;
    final tracks = payload['tracks'];
    if (tracks is List) {
      for (final rawTrack in tracks) {
        final track = _asMap(rawTrack);
        final mid = track?['mid']?.toString();
        final responseTrackName = track?['trackName']?.toString();
        if (mid != null &&
            mid.isNotEmpty &&
            (responseTrackName == null || responseTrackName == trackName)) {
          _remoteVideoUserByMid[mid] = userId;
          mapped = true;
        }
      }
    }

    if (!mapped) {
      _pendingVideoUserIds.add(userId);
    }
  }

  Future<void> _attachRemoteVideoRenderer(
    webrtc.RTCTrackEvent event,
    webrtc.MediaStream stream,
  ) async {
    final mid = event.transceiver?.mid;
    int? userId = mid == null ? null : _remoteVideoUserByMid[mid];
    if (userId == null && _pendingVideoUserIds.isNotEmpty) {
      userId = _pendingVideoUserIds.removeAt(0);
    }
    if (userId == null) {
      return;
    }

    final existing = remoteVideoRenderersByUser[userId];
    if (existing != null) {
      existing.srcObject = stream;
      remoteVideoRenderersByUser.refresh();
      return;
    }

    final renderer = webrtc.RTCVideoRenderer();
    await renderer.initialize();
    renderer.srcObject = stream;
    remoteVideoRenderersByUser[userId] = renderer;
  }

  Future<void> _removeRemoteVideoRenderer(int userId) async {
    final renderer = remoteVideoRenderersByUser.remove(userId);
    remoteVideoRenderersByUser.refresh();
    renderer?.srcObject = null;
    await renderer?.dispose();
  }

  Future<void> _queueNegotiation(Future<void> Function() action) {
    _negotiationQueue = _negotiationQueue.then((_) => action()).catchError((e) {
      log('${_prefix}Negotiation hatası: $e');
    });
    return _negotiationQueue;
  }

  Future<Map<String, dynamic>?> _emitWithAckMap(
    String event,
    Map<String, dynamic> payload,
  ) {
    if (_socket == null) {
      return Future.value(null);
    }

    final completer = Completer<Map<String, dynamic>?>();
    _socket!.emitWithAck(
      event,
      payload,
      ack: (data) {
        if (!completer.isCompleted) {
          completer.complete(_asMap(data));
        }
      },
    );

    return completer.future.timeout(
      _socketAckTimeout,
      onTimeout: () {
        log('$_prefix$event ack zaman asimi');
        return null;
      },
    );
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

  Future<String?> _midForSender(webrtc.RTCRtpSender? sender) async {
    if (_peerConnection == null || sender == null) {
      return null;
    }

    final transceivers = await _peerConnection!.getTransceivers();
    for (final transceiver in transceivers) {
      if (transceiver.sender.senderId == sender.senderId ||
          transceiver.sender.track?.id == sender.track?.id) {
        return transceiver.mid;
      }
    }
    return null;
  }

  String? _midForKind(String? sdp, String kind) {
    if (sdp == null) {
      return null;
    }

    String? currentKind;
    for (final line in sdp.split(RegExp(r'\r?\n'))) {
      if (line.startsWith('m=')) {
        currentKind = line.startsWith('m=$kind') ? kind : null;
      }
      if (currentKind == kind && line.startsWith('a=mid:')) {
        return line.substring('a=mid:'.length).trim();
      }
    }
    return null;
  }

  String _kindFromTrack(Map<String, dynamic>? track) {
    final kind = track?['kind']?.toString();
    if (kind == 'audio' || kind == 'video') {
      return kind!;
    }

    final trackName = track?['trackName']?.toString() ?? '';
    if (trackName.endsWith('-camera') || trackName.endsWith('-cam')) {
      return 'video';
    }
    return 'audio';
  }

  int? _userIdFromTrackName(String? trackName) {
    if (trackName == null) {
      return null;
    }

    final match = RegExp(r'-user-(\d+)-').firstMatch(trackName);
    if (match == null) {
      return null;
    }
    return int.tryParse(match.group(1)!);
  }

  Future<void> _closePeerConnection({required bool stopLocal}) async {
    // Speaking monitor ve sender her zaman sıfırlanır; yeni PC ile yeniden başlatılır
    _stopLocalSpeakingMonitor();
    _localAudioSender = null;

    if (stopLocal) {
      _setLocalSpeaking(false, notifyServer: true);
      await _stopLocalCamera(sendCloseEvent: false);
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
    _remoteVideoUserByMid.clear();
    _pendingVideoUserIds.clear();
    _subscribingTrackNames.clear();
    _subscribedTrackNames.clear();
    // Kuyruktaki eski negotiation'lar yeni session'ı bloke etmesin
    _negotiationQueue = Future.value();

    for (final renderer in remoteVideoRenderersByUser.values) {
      renderer.srcObject = null;
      await renderer.dispose();
    }
    remoteVideoRenderersByUser.clear();
  }

  void _startLocalSpeakingMonitor() {
    if (_localSpeakingTimer != null || _localAudioSender == null) {
      return;
    }

    _localSpeakingTimer = Timer.periodic(
      _localAudioPollInterval,
      (_) => unawaited(_sampleLocalAudioLevel()),
    );
  }

  void _stopLocalSpeakingMonitor() {
    _localSpeakingTimer?.cancel();
    _localSpeakingTimer = null;
    _quietAudioSamples = 0;
    _lastAudioEnergy = null;
    _lastAudioDuration = null;
  }

  Future<void> _sampleLocalAudioLevel() async {
    if (_localAudioSender == null ||
        AppList.sessions.isEmpty ||
        !AppList.sessions.first.currentUser.microphone.value) {
      _setLocalSpeaking(false, notifyServer: true);
      return;
    }

    try {
      final stats = await _localAudioSender!.getStats();
      bool speaking = false;

      for (final report in stats) {
        final values = report.values;
        final audioLevel =
            _numberValue(values['audioLevel'] ?? values['audioInputLevel']);
        if (audioLevel != null) {
          final normalizedLevel =
              audioLevel > 1 ? audioLevel / 32768 : audioLevel;
          if (normalizedLevel >= _audioLevelThreshold) {
            speaking = true;
            break;
          }
        }

        final totalEnergy = _numberValue(values['totalAudioEnergy']);
        final totalDuration = _numberValue(values['totalSamplesDuration']);
        if (totalEnergy != null && totalDuration != null) {
          final previousEnergy = _lastAudioEnergy;
          final previousDuration = _lastAudioDuration;
          _lastAudioEnergy = totalEnergy;
          _lastAudioDuration = totalDuration;

          if (previousEnergy != null && previousDuration != null) {
            final energyDelta = totalEnergy - previousEnergy;
            final durationDelta = totalDuration - previousDuration;
            if (durationDelta > 0 &&
                energyDelta / durationDelta >= _audioEnergyThreshold) {
              speaking = true;
              break;
            }
          }
        }
      }

      if (speaking) {
        _quietAudioSamples = 0;
        _setLocalSpeaking(true, notifyServer: true);
        return;
      }

      _quietAudioSamples += 1;
      if (_quietAudioSamples >= _quietSamplesBeforeStop) {
        _setLocalSpeaking(false, notifyServer: true);
      }
    } catch (e) {
      if (kDebugMode) {
        log('${_prefix}Mikrofon seviyesi okunamadi: $e');
      }
    }
  }

  void _setLocalSpeaking(bool speaking, {required bool notifyServer}) {
    if (AppList.sessions.isEmpty) {
      return;
    }

    if (_localSpeaking == speaking &&
        AppList.sessions.first.currentUser.isSpeaking.value == speaking) {
      return;
    }

    _localSpeaking = speaking;
    AppList.sessions.first.currentUser.isSpeaking.value = speaking;

    if (notifyServer && _socket != null && _currentRoom != null) {
      _socket!.emit(speaking ? 'AUDIO_START' : 'AUDIO_STOP');
    }
  }

  double? _numberValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  bool _isErrorPayload(Map<String, dynamic>? payload) {
    return payload == null ||
        payload['status'] == 'error' ||
        payload['code'] != null ||
        payload['error'] != null;
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
