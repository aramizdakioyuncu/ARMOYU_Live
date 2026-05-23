import 'package:armoyu_desktop/app/data/models/group_model.dart';
import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:armoyu_desktop/app/theme/app_theme_tokens.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomWidget {
  static Widget roomfield(Group group, Room room) {
    final socketio = Get.find<SocketioControllerV2>();
    return _RoomItem(group: group, room: room, socketio: socketio);
  }
}

class _RoomItem extends StatefulWidget {
  final Group group;
  final Room room;
  final SocketioControllerV2 socketio;

  const _RoomItem(
      {required this.group, required this.room, required this.socketio});

  @override
  State<_RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<_RoomItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onSecondaryTapDown: (details) => _showContextMenu(context, details),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: () => widget.socketio.changeroom(widget.room),
              child: Obx(() {
                final isActive = widget.socketio.isInRoom(widget.group) &&
                    widget.socketio.findmyRoom(widget.group)?.roomID ==
                        widget.room.roomID;
                final itemColor = isActive
                    ? tokens.accentSoft
                    : _hovered
                        ? tokens.text.withValues(alpha: 0.08)
                        : Colors.transparent;
                final contentColor = isActive
                    ? tokens.text
                    : (_hovered ? tokens.text : tokens.textMuted);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: itemColor,
                    borderRadius: BorderRadius.circular(tokens.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.room.type == RoomType.text
                            ? Icons.tag_rounded
                            : Icons.volume_up_rounded,
                        size: 16,
                        color: contentColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Obx(() => Text(
                              widget.room.name.value,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: contentColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ),
                      Obx(() {
                        final count = widget.room.currentMembers.length;
                        if (count == 0) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: tokens.surfaceMuted,
                            borderRadius:
                                BorderRadius.circular(tokens.radiusLg),
                          ),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              color: tokens.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        // Odadaki üyeler
        Obx(() => Column(
              children: List.generate(
                  widget.room.currentMembers.length,
                  (index) => _RoomMemberTile(
                        member: widget.room.currentMembers[index],
                        socketio: widget.socketio,
                      )),
            )),
      ],
    );
  }

  void _showContextMenu(BuildContext context, TapDownDetails details) {
    final tokens = AppThemeTokens.of(context);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx + 1,
        details.globalPosition.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Text(
            'Düzenle',
            style: TextStyle(color: tokens.text, fontSize: 13),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Text('Sil',
                  style: TextStyle(color: Colors.red, fontSize: 13)),
              const Spacer(),
              Icon(Icons.delete_outline,
                  color: Colors.red.withValues(alpha: 0.8), size: 16),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete') {
        widget.socketio.deleteRoom(widget.room, widget.group);
      }
      if (value != null) {
        debugPrint("Seçilen: $value");
      }
    });
  }
}

class _RoomMemberTile extends StatefulWidget {
  final dynamic member;
  final SocketioControllerV2 socketio;

  const _RoomMemberTile({required this.member, required this.socketio});

  @override
  State<_RoomMemberTile> createState() => _RoomMemberTileState();
}

class _RoomMemberTileState extends State<_RoomMemberTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.socketio.callUser(widget.member),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(left: 24, right: 8, top: 1, bottom: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _hovered
                ? tokens.text.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(tokens.radiusSm),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Obx(() => Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tokens.surfaceMuted,
                          border: widget.socketio.isSoundStreaming.value
                              ? Border.all(
                                  color: Colors.amber.withValues(alpha: 0.8),
                                  width: 1.5)
                              : null,
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget
                                .member.user.avatar!.mediaURL.minURL.value,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() => Text(
                      widget.member.user.displayName!.value,
                      style: TextStyle(
                        fontSize: 12,
                        color: _hovered ? tokens.text : tokens.textMuted,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ),
              Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.member.microphone.value != true)
                        Icon(Icons.mic_off_outlined,
                            size: 13,
                            color: widget.member.microphoneAccess.value
                                ? Colors.red
                                : tokens.textSubtle),
                      if (widget.member.speaker.value != true)
                        Icon(Icons.headset_off_outlined,
                            size: 13,
                            color: widget.member.speakerAccess.value
                                ? Colors.red
                                : tokens.textSubtle),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
