import 'package:armoyu_desktop/app/data/models/internetstatus_model.dart';
import 'package:armoyu_desktop/app/data/models/player_model.dart';
import 'package:armoyu_desktop/app/services/socketio_controller.dart';
import 'package:armoyu_desktop/app/widgets/ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bottomusermenu {
  static Widget field(Player user) {
    final socketio = Get.find<SocketioControllerV2>();

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final surfaceColor =
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
        final textColor =
            theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
        final mutedColor = textColor.withValues(alpha: 0.58);
        final borderColor = theme.dividerColor.withValues(alpha: 0.35);
        final embeddedSurfaceColor = textColor.withValues(alpha: 0.06);

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(top: BorderSide(color: borderColor)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Voice status bar (odadayken görünür)
              Obx(() {
                if (!socketio.isInRoomanyWhereGroup()) {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: embeddedSurfaceColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
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
                              blurRadius: 4,
                            )
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
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              "${socketio.findanyWhereGroup().name} / ${socketio.findmyRoomanyWhereGroup()?.name ?? ""}",
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        final status =
                            socketio.internetConnectionStatus.value;
                        final ping = socketio.pingValue.value;
                        return Tooltip(
                          message: '$ping ms',
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: Icon(
                              status.icon.icon,
                              color: status.color,
                              size: 16,
                            ),
                          ),
                        );
                      }),
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
                        backgroundColor: textColor.withValues(alpha: 0.10),
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
                            border: Border.fromBorderSide(
                              BorderSide(color: surfaceColor, width: 1.5),
                            ),
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
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        Text(
                          "#${user.user.userID}",
                          style: TextStyle(color: mutedColor, fontSize: 10),
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
                            color:
                                user.microphone.value ? mutedColor : Colors.red,
                            onTap: () => socketio.micOnOff(user),
                          )),
                      Obx(() => _SmallIconBtn(
                            icon: user.speaker.value
                                ? Icons.headphones_outlined
                                : Icons.headset_off_outlined,
                            color: user.speaker.value ? mutedColor : Colors.red,
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
      },
    );
  }
}

class _SmallIconBtn extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _SmallIconBtn({required this.icon, this.color, required this.onTap});

  @override
  State<_SmallIconBtn> createState() => _SmallIconBtnState();
}

class _SmallIconBtnState extends State<_SmallIconBtn> {
  @override
  Widget build(BuildContext context) {
    return AppIconAction(
      icon: widget.icon,
      onTap: widget.onTap,
      color: widget.color,
      size: 28,
      iconSize: 16,
    );
  }
}
