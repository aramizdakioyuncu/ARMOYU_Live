import 'package:armoyu_desktop/app/data/models/message_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageWidget {
  static Widget chatfield(Message message) {
    return _MessageItem(message: message);
  }
}

class _MessageItem extends StatefulWidget {
  final Message message;
  const _MessageItem({required this.message});

  @override
  State<_MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<_MessageItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _hovered
            ? const Color(0xFF161616)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2A2A2A),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.message.user.value.user.avatar!.mediaURL
                      .minURL.value,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const Icon(Icons.person,
                      color: Colors.white54, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.message.user.value.user.displayName!.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(widget.message.datetime),
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Message text
                  Obx(() => Text(
                        widget.message.message.value,
                        style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      )),
                  // Media
                  if (widget.message.media != null &&
                      widget.message.media!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                          ),
                          itemCount: widget.message.media!.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  "https://storage.aramizdakioyuncu.com/galeri/profilresimleri/11357profilresimufaklik1668362839.webp",
                            );
                          },
                        ),
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

  String _formatDate(dynamic datetime) {
    try {
      final dt = datetime is DateTime
          ? datetime
          : DateTime.tryParse(datetime.toString());
      if (dt == null) return "";
      final now = DateTime.now();
      if (dt.day == now.day &&
          dt.month == now.month &&
          dt.year == now.year) {
        return "bugün ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      }
      return "${dt.day}.${dt.month}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return datetime.toString();
    }
  }
}
