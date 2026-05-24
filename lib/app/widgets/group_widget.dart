import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/modules/home/_main/controllers/home_controller.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:armoyu_desktop/app/widgets/group_member_widget.dart';
import 'package:armoyu_desktop/app/widgets/message_sendfield.dart';
import 'package:armoyu_desktop/app/widgets/message_widget.dart';
import 'package:armoyu_desktop/app/widgets/room_create_widget.dart';
import 'package:armoyu_desktop/app/widgets/room_widget.dart';
import 'package:armoyu_desktop/app/widgets/ui/app_ui.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';

class GroupWidget {
  static Widget pageDetail(BuildContext context, Group group) {
    return _GroupPage(group: group);
  }
}

class _GroupPage extends StatefulWidget {
  final Group group;

  const _GroupPage({required this.group});

  @override
  State<_GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<_GroupPage> {
  final mainScrollController = ScrollController();
  final membersScrollController = ScrollController();
  final chattextcontroller = TextEditingController().obs;
  late final SocketioControllerV2 socketio;
  late final HomeController homeController;

  Group get group => widget.group;

  @override
  void initState() {
    super.initState();
    socketio = Get.find<SocketioControllerV2>();
    homeController = Get.find<HomeController>();
  }

  @override
  void dispose() {
    mainScrollController.dispose();
    membersScrollController.dispose();
    chattextcontroller.value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;

    return Row(
      children: [
        // ── Sol sidebar ─────────────────────────────────────────────
        SizedBox(
          width: 240,
          child: Container(
            color: surfaceColor,
            child: Column(
              children: [
                // Grup başlığı
                _GroupHeader(group: group, socketio: socketio),

                // Kanal listesi
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    children: [
                      // Grup banner
                      _GroupBanner(group: group, socketio: socketio),

                      const SizedBox(height: 8),

                      // Kanal başlığı
                      AppSectionLabel(
                        label: "KANALLAR",
                        trailing: AppIconAction(
                          icon: Icons.add,
                          tooltip: "Kanal Oluştur",
                          size: 24,
                          iconSize: 16,
                          onTap: () => RoomCreateWidget.showAlertDialog(
                              context, group, socketio),
                        ),
                      ),

                      // Odalar
                      Obx(() => Column(
                            children: List.generate(
                              socketio.findcurrentGroup(group).rooms!.length,
                              (index) => Obx(() => RoomWidget.roomfield(
                                    group,
                                    socketio
                                        .findcurrentGroup(group)
                                        .rooms![index],
                                  )),
                            ),
                          )),
                    ],
                  ),
                ),

                // Alt kullanıcı menüsü
                Bottomusermenu.field(AppList.sessions.first.currentUser),
              ],
            ),
          ),
        ),

        // ── Ana içerik ──────────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // İçerik başlık bar
              _ContentHeader(
                  group: group,
                  socketio: socketio,
                  homeController: homeController),

              // İçerik
              Expanded(
                child: Obx(() {
                  if (!socketio.isInRoom(group)) {
                    return _EmptyRoomState(group: group);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video/Chat alanı
                      Expanded(
                        child: Column(
                          children: [
                            // Video bölümü
                            _VideoSection(
                              socketio: socketio,
                              group: group,
                            ),

                            // Mesajlar
                            Expanded(
                              child: Obx(() => Stack(
                                    children: [
                                      RawScrollbar(
                                        thickness: 4,
                                        controller: mainScrollController,
                                        radius: const Radius.circular(4),
                                        thumbVisibility: true,
                                        child: ListView.builder(
                                          reverse: true,
                                          controller: mainScrollController,
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 4),
                                          itemCount: socketio
                                              .findmyRoom(group)!
                                              .message
                                              .length,
                                          itemBuilder: (context, index) {
                                            final messages = socketio
                                                .findmyRoom(group)!
                                                .message;
                                            return MessageWidget.chatfield(
                                                messages[messages.length -
                                                    index -
                                                    1]);
                                          },
                                        ),
                                      ),
                                      // Bağlantı uyarısı
                                      Obx(() => socketio.socketChatStatus.value
                                          ? const SizedBox.shrink()
                                          : Positioned(
                                              bottom: 8,
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF1E1E1E),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: Colors.red
                                                            .withValues(
                                                                alpha: 0.4)),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .signal_cellular_connected_no_internet_0_bar_rounded,
                                                        color: Colors.red,
                                                        size: 14,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        "Bağlantı zayıf",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                    ],
                                  )),
                            ),

                            // Mesaj yazma alanı
                            Obx(() => socketio.isInRoom(group)
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 16),
                                    child: MessageSendfield.field1(
                                      chattextcontroller: chattextcontroller,
                                      onsubmitted: (value) {
                                        socketio.sendMessage(
                                            value,
                                            socketio
                                                .findmyRoomanyWhereGroup()!);
                                        chattextcontroller.value.clear();
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ),

                      // Üye paneli
                      Obx(() => Visibility(
                            visible: homeController.showMembers.value,
                            child: socketio
                                        .findcurrentGroup(group)
                                        .groupmembers ==
                                    null
                                ? const SizedBox.shrink()
                                : _MembersPanel(
                                    group: group,
                                    socketio: socketio,
                                    scrollController: membersScrollController,
                                  ),
                          )),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Alt bileşenler ──────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final Group group;
  final SocketioControllerV2 socketio;

  const _GroupHeader({required this.group, required this.socketio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final mutedColor = textColor.withValues(alpha: 0.58);
    final borderColor = theme.dividerColor.withValues(alpha: 0.35);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              group.name,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: mutedColor, size: 20),
            color: surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: borderColor),
            ),
            onSelected: (value) {
              if (value == "takviye") {
                Get.toNamed("/turbo",
                    parameters: {"group": group.groupID.toString()});
              }
              if (value == "olustur") {
                RoomCreateWidget.showAlertDialog(Get.context!, group, socketio);
              }
            },
            itemBuilder: (_) => [
              _menuItem("takviye", "Sunucu Takviyesi", Icons.bolt_outlined),
              _menuItem(
                  "davet", "Arkadaşlarını Davet Et", Icons.person_add_outlined),
              _menuItem("ayarlar", "Sunucu Ayarları", Icons.settings_outlined),
              _menuItem("olustur", "Kanal Oluştur", Icons.add_circle_outline),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, String label, IconData icon) {
    return PopupMenuItem(
      value: value,
      height: 36,
      child: Builder(
        builder: (context) {
          final textColor = Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).colorScheme.onSurface;

          return Row(
            children: [
              Icon(icon, size: 15, color: textColor.withValues(alpha: 0.58)),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(color: textColor, fontSize: 13),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupBanner extends StatelessWidget {
  final Group group;
  final SocketioControllerV2 socketio;

  const _GroupBanner({required this.group, required this.socketio});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RoomCreateWidget.showAlertDialog(context, group, socketio),
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF1A1A1A),
          image: DecorationImage(
            image: CachedNetworkImageProvider(group.logo.mediaURL.minURL.value),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1. Seviye",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.2,
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      color: Colors.red,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentHeader extends StatelessWidget {
  final Group group;
  final SocketioControllerV2 socketio;
  final HomeController homeController;

  const _ContentHeader(
      {required this.group,
      required this.socketio,
      required this.homeController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final mutedColor = textColor.withValues(alpha: 0.58);
    final borderColor = theme.dividerColor.withValues(alpha: 0.35);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Obx(() {
            if (!socketio.isInRoom(group)) {
              return Row(children: [
                Icon(Icons.group_outlined, color: mutedColor, size: 18),
                const SizedBox(width: 8),
                Text(group.name,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ]);
            }
            final room = socketio.findmyRoom(group)!;
            return Row(children: [
              Icon(
                room.type == RoomType.text
                    ? Icons.tag_rounded
                    : Icons.volume_up_rounded,
                color: mutedColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Obx(() => Text(
                    room.name.value,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )),
            ]);
          }),
          const Spacer(),
          _HeaderBtn(icon: Icons.notifications_none_rounded, onTap: () {}),
          _HeaderBtn(icon: Icons.push_pin_outlined, onTap: () {}),
          Obx(() => _HeaderBtn(
                icon: Icons.group_outlined,
                active: homeController.showMembers.value,
                onTap: () => homeController.showMembers.value =
                    !homeController.showMembers.value,
              )),
          const SizedBox(width: 4),
          const SizedBox(
            width: 110,
            height: 28,
            child: AppSearchField(),
          ),
          _HeaderBtn(icon: Icons.help_outline_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _HeaderBtn extends StatefulWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _HeaderBtn(
      {required this.icon, this.active = false, required this.onTap});

  @override
  State<_HeaderBtn> createState() => _HeaderBtnState();
}

class _HeaderBtnState extends State<_HeaderBtn> {
  @override
  Widget build(BuildContext context) {
    return AppIconAction(
      icon: widget.icon,
      active: widget.active,
      onTap: widget.onTap,
      size: 32,
      iconSize: 18,
    );
  }
}

class _VideoSection extends StatelessWidget {
  final SocketioControllerV2 socketio;
  final Group group;

  const _VideoSection({required this.socketio, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    final textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final borderColor = theme.dividerColor.withValues(alpha: 0.35);

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Obx(() {
              final room = socketio.findmyRoom(group);
              final members = room?.currentMembers ?? <Player>[].obs;
              if (members.isEmpty) {
                return const SizedBox.shrink();
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    members.length,
                    (index) => _ParticipantMediaTile(
                      member: members[index],
                      socketio: socketio,
                      width: members.length == 1 ? 280 : 220,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      borderColor: borderColor,
                    ),
                  ),
                ),
              );
            }),
          ),
          // Kontrol butonları
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: surfaceColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => _VoiceBtn(
                          icon: AppList.sessions.first.currentUser.microphone
                                      .value ==
                                  true
                              ? Icons.mic_outlined
                              : Icons.mic_off_outlined,
                          active: AppList
                              .sessions.first.currentUser.microphone.value,
                          isDestructive: AppList.sessions.first.currentUser
                                  .microphone.value !=
                              true,
                          onTap: () => socketio
                              .micOnOff(AppList.sessions.first.currentUser),
                        )),
                    const SizedBox(width: 6),
                    Obx(() => _VoiceBtn(
                          icon: AppList.sessions.first.currentUser.speaker
                                      .value ==
                                  true
                              ? Icons.headphones_outlined
                              : Icons.headset_off_outlined,
                          active:
                              AppList.sessions.first.currentUser.speaker.value,
                          isDestructive: AppList
                                  .sessions.first.currentUser.speaker.value !=
                              true,
                          onTap: () => socketio
                              .speakerOnOff(AppList.sessions.first.currentUser),
                        )),
                    const SizedBox(width: 6),
                    Obx(() => _VoiceBtn(
                          icon:
                              AppList.sessions.first.currentUser.camera.value ==
                                      true
                                  ? Icons.videocam_outlined
                                  : Icons.videocam_off_outlined,
                          active:
                              AppList.sessions.first.currentUser.camera.value,
                          isDestructive:
                              AppList.sessions.first.currentUser.camera.value !=
                                  true,
                          onTap: () => socketio
                              .cameraOnOff(AppList.sessions.first.currentUser),
                        )),
                    const SizedBox(width: 6),
                    _VoiceBtn(
                      icon: Icons.call_end_rounded,
                      isDestructive: true,
                      onTap: () => socketio.changeroom(null),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantMediaTile extends StatelessWidget {
  final Player member;
  final SocketioControllerV2 socketio;
  final double width;
  final Color surfaceColor;
  final Color textColor;
  final Color borderColor;

  const _ParticipantMediaTile({
    required this.member,
    required this.socketio,
    required this.width,
    required this.surfaceColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final voiceService = socketio.voiceService;
    final currentUserId = AppList.sessions.first.currentUser.user.userID;
    final memberUserId = member.user.userID;
    final isSelf = memberUserId == currentUserId;

    return Obx(() {
      final renderer = isSelf
          ? (voiceService.cameraEnabled.value &&
                  voiceService.localVideoReady.value
              ? voiceService.localVideoRenderer
              : null)
          : voiceService.remoteVideoRenderersByUser[memberUserId];
      final hasVideo = renderer != null;

      return Container(
        height: 180,
        width: width,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: hasVideo
                  ? webrtc.RTCVideoView(
                      renderer,
                      mirror: isSelf,
                      objectFit: webrtc
                          .RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                  : _ParticipantAvatar(member: member, textColor: textColor),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 8,
              child: Text(
                member.user.displayName?.value ??
                    member.user.userName?.value ??
                    "",
                style: TextStyle(
                  color: hasVideo ? Colors.white : textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  shadows: hasVideo
                      ? const [Shadow(color: Colors.black, blurRadius: 8)]
                      : null,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (member.microphone.value != true)
                    _MediaBadge(icon: Icons.mic_off_outlined),
                  if (member.speaker.value != true)
                    _MediaBadge(icon: Icons.headset_off_outlined),
                  if (hasVideo) _MediaBadge(icon: Icons.videocam_outlined),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ParticipantAvatar extends StatelessWidget {
  final Player member;
  final Color textColor;

  const _ParticipantAvatar({required this.member, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: textColor.withValues(alpha: 0.08),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: member.user.avatar!.mediaURL.minURL.value,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _MediaBadge extends StatelessWidget {
  final IconData icon;

  const _MediaBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.55),
      ),
      child: Icon(icon, size: 13, color: Colors.white),
    );
  }
}

class _VoiceBtn extends StatefulWidget {
  final IconData icon;
  final bool active;
  final bool isDestructive;
  final VoidCallback onTap;

  const _VoiceBtn(
      {required this.icon,
      this.active = true,
      this.isDestructive = false,
      required this.onTap});

  @override
  State<_VoiceBtn> createState() => _VoiceBtnState();
}

class _VoiceBtnState extends State<_VoiceBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    Color bg = widget.isDestructive
        ? Colors.red
        : (widget.active ? const Color(0xFF2A2A2A) : const Color(0xFF333333));
    if (_hovered && !widget.isDestructive) {
      bg = const Color(0xFF3A3A3A);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
          child: Icon(
            widget.icon,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _EmptyRoomState extends StatelessWidget {
  final Group group;
  const _EmptyRoomState({required this.group});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A1A),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: group.logo.mediaURL.minURL.value,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            group.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bir kanala katılarak sohbet etmeye başla",
            style: TextStyle(color: Color(0xFF666666), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MembersPanel extends StatelessWidget {
  final Group group;
  final SocketioControllerV2 socketio;
  final ScrollController scrollController;

  const _MembersPanel(
      {required this.group,
      required this.socketio,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final sectionTextColor =
        (theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface)
            .withValues(alpha: 0.48);

    return Container(
      width: 240,
      color: surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "ÜYELEr",
              style: TextStyle(
                color: sectionTextColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => RawScrollbar(
                  thickness: 4,
                  controller: scrollController,
                  radius: const Radius.circular(4),
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount:
                        socketio.findcurrentGroup(group).groupmembers!.length,
                    itemBuilder: (context, index) {
                      return Obx(() => GroupMemberWidget.listtile(
                            socketio
                                .findcurrentGroup(group)
                                .groupmembers![index],
                          ));
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
