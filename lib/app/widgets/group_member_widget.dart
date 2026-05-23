import 'package:armoyu_desktop/app/data/models/group_member_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMemberWidget {
  static Widget listtile(Groupmember member) {
    final socketio = Get.find<SocketioControllerV2>();
    return _MemberTile(member: member, socketio: socketio);
  }
}

class _MemberTile extends StatefulWidget {
  final Groupmember member;
  final SocketioControllerV2 socketio;

  const _MemberTile({required this.member, required this.socketio});

  @override
  State<_MemberTile> createState() => _MemberTileState();
}

class _MemberTileState extends State<_MemberTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => widget.socketio.callUser(widget.member.user.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: _hovered
                  ? const Color(0xFF1E1E1E)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2A2A2A),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.member.user.value.user.avatar!
                              .mediaURL.minURL.value,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.white54,
                              size: 18),
                        ),
                      ),
                    ),
                    // Online indicator
                    Positioned(
                      right: -1,
                      bottom: -1,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade400,
                          border: const Border.fromBorderSide(BorderSide(
                              color: Color(0xFF111111), width: 1.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.member.user.value.user.displayName!.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _hovered
                              ? Colors.white
                              : const Color(0xFFCCCCCC),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        widget.member.currentRoom.value == null
                            ? widget.member.description
                            : widget.member.currentRoom.value!.name.value,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
