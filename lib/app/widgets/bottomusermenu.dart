import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomusermenu {
  static Widget field(Player user) {
    final socketio = Get.find<SocketioControllerV2>();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E),
        border: Border(top: BorderSide(color: Color(0xFF222222))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Voice status bar (odadayken görünür)
          Obx(() {
            if (!socketio.isInRoomanyWhereGroup()) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade400,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green.withValues(alpha: 0.5),
                            blurRadius: 4)
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Seste",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3),
                        ),
                        Text(
                          "${socketio.findanyWhereGroup().name} / ${socketio.findmyRoomanyWhereGroup()?.name ?? ""}",
                          style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  _SmallIconBtn(
                    icon: Icons.info_outline_rounded,
                    onTap: () {},
                  ),
                  _SmallIconBtn(
                    icon: Icons.call_end_rounded,
                    color: Colors.red,
                    onTap: () {
                      socketio.exitroom();
                      socketio.changeroom(null);
                    },
                  ),
                ],
              ),
            );
          }),

          // Kullanıcı bilgisi
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF2A2A2A),
                    foregroundImage: CachedNetworkImageProvider(
                      user.user.avatar!.mediaURL.minURL.value,
                    ),
                  ),
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade400,
                        border: const Border.fromBorderSide(
                            BorderSide(color: Color(0xFF0E0E0E), width: 1.5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          user.user.userName!.value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        )),
                    Text(
                      "#${user.user.userID}",
                      style: const TextStyle(
                          color: Color(0xFF666666), fontSize: 10),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => _SmallIconBtn(
                        icon: user.microphone.value
                            ? Icons.mic_outlined
                            : Icons.mic_off_outlined,
                        color: user.microphone.value
                            ? const Color(0xFF888888)
                            : Colors.red,
                        onTap: () => socketio.micOnOff(user),
                      )),
                  Obx(() => _SmallIconBtn(
                        icon: user.speaker.value
                            ? Icons.headphones_outlined
                            : Icons.headset_off_outlined,
                        color: user.speaker.value
                            ? const Color(0xFF888888)
                            : Colors.red,
                        onTap: () => socketio.speakerOnOff(user),
                      )),
                  _SmallIconBtn(
                    icon: Icons.settings_outlined,
                    onTap: () => Get.toNamed("/settings"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallIconBtn extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _SmallIconBtn(
      {required this.icon, this.color, required this.onTap});

  @override
  State<_SmallIconBtn> createState() => _SmallIconBtnState();
}

class _SmallIconBtnState extends State<_SmallIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color:
                _hovered ? const Color(0xFF2A2A2A) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 16,
            color: widget.color ?? const Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}
