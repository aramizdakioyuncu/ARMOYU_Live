import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsChangeWidget {
  static Widget groups(int index,
      {required Function onTap, required Rx selectedPage}) {
    return _GroupNavIcon(
        index: index, onTap: onTap, selectedPage: selectedPage);
  }
}

class _GroupNavIcon extends StatefulWidget {
  final int index;
  final Function onTap;
  final Rx selectedPage;

  const _GroupNavIcon(
      {required this.index, required this.onTap, required this.selectedPage});

  @override
  State<_GroupNavIcon> createState() => _GroupNavIconState();
}

class _GroupNavIconState extends State<_GroupNavIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = widget.selectedPage.value - 1 == widget.index;
      return SizedBox(
        height: 52,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 3,
              height: isSelected ? 32 : (_hovered ? 16 : 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(3)),
              ),
            ),
            const SizedBox(width: 9),
            Tooltip(
              message: AppList.groups[widget.index].name,
              preferBelow: false,
              waitDuration: const Duration(milliseconds: 400),
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: GestureDetector(
                  onTap: () async => await widget.onTap(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          isSelected || _hovered ? 14 : 22),
                      color: const Color(0xFF1E1E1E),
                      border: isSelected
                          ? Border.all(
                              color: Colors.red.withValues(alpha: 0.7),
                              width: 2)
                          : null,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: AppList
                          .groups[widget.index].logo.mediaURL.minURL.value,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.group,
                          color: Colors.white54, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
