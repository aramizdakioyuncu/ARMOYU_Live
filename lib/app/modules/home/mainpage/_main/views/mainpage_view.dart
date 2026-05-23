import 'package:armoyu_desktop/app/modules/home/mainpage/_main/controllers/mainpage_controller.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/chat/controllers/chat_controller.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/chat/views/chat_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/events/views/events_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/friends/views/friends_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/library/views/library_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/turbo/views/turbo_view.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/bottomusermenu.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainpageView extends StatelessWidget {
  const MainpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainpageController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final sidebarWidth = constraints.maxWidth < 1200 ? 200.0 : 240.0;
        final theme = Theme.of(context);
        final surfaceColor =
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
        final textColor =
            theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
        final dividerColor = theme.dividerColor.withValues(alpha: 0.35);
        final sectionTextColor = textColor.withValues(alpha: 0.48);

        return Row(
          children: [
            SizedBox(
              width: sidebarWidth,
              child: Container(
                color: surfaceColor,
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: dividerColor),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ana Sayfa",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          children: [
                            _NavSection(
                              items: [
                                _NavItem(
                                  icon: Icons.celebration_outlined,
                                  label: "Etkinlik",
                                  index: 0,
                                  selectedIndex:
                                      controller.homeSelectedPage.value,
                                  onTap: () => controller
                                      .pageviewController.value
                                      .jumpToPage(0),
                                ),
                                _NavItem(
                                  icon: Icons.gamepad_outlined,
                                  label: "Kitaplık",
                                  index: 1,
                                  selectedIndex:
                                      controller.homeSelectedPage.value,
                                  onTap: () => controller
                                      .pageviewController.value
                                      .jumpToPage(1),
                                ),
                                _NavItem(
                                  icon: Icons.bolt_outlined,
                                  label: "Turbo",
                                  index: 2,
                                  selectedIndex:
                                      controller.homeSelectedPage.value,
                                  onTap: () => controller
                                      .pageviewController.value
                                      .jumpToPage(2),
                                ),
                                _NavItem(
                                  icon: Icons.people_outline_rounded,
                                  label: "Arkadaşlar",
                                  index: 3,
                                  selectedIndex:
                                      controller.homeSelectedPage.value,
                                  onTap: () => controller
                                      .pageviewController.value
                                      .jumpToPage(3),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "DİREKT MESAJLAR",
                                    style: TextStyle(
                                      color: sectionTextColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const Spacer(),
                                  _IconAction(
                                    icon: Icons.add,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            if (controller.chatList.value == null)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              )
                            else
                              ...List.generate(
                                controller.chatList.value!.length,
                                (index) {
                                  final chatINFO =
                                      controller.chatList.value![index];
                                  final chatcontroller =
                                      Get.put(ChatController());
                                  return _DmItem(
                                    chatINFO: chatINFO,
                                    chatcontroller: chatcontroller,
                                    controller: controller,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (AppList.sessions.isNotEmpty)
                      Bottomusermenu.field(AppList.sessions.first.currentUser),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageviewController.value,
                onPageChanged: (value) {
                  controller.homeSelectedPage.value = value;
                },
                children: const [
                  EventsView(),
                  LibraryView(),
                  TurboView(),
                  FriendsView(),
                  ChatView(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NavSection extends StatelessWidget {
  final List<Widget> items;
  const _NavSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(children: items);
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedIndex == widget.index;
    final theme = Theme.of(context);
    final textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final selectedBackground =
        theme.colorScheme.primary.withValues(alpha: 0.16);
    final hoverBackground = textColor.withValues(alpha: 0.08);
    final mutedColor = textColor.withValues(alpha: 0.58);
    final hoverColor = textColor.withValues(alpha: 0.78);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedBackground
                : _hovered
                    ? hoverBackground
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: isSelected
                    ? textColor
                    : (_hovered ? hoverColor : mutedColor),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? textColor
                      : (_hovered ? hoverColor : mutedColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DmItem extends StatefulWidget {
  final APIChatList chatINFO;
  final ChatController chatcontroller;
  final MainpageController controller;

  const _DmItem({
    required this.chatINFO,
    required this.chatcontroller,
    required this.controller,
  });

  @override
  State<_DmItem> createState() => _DmItemState();
}

class _DmItemState extends State<_DmItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = widget.controller.homeSelectedPage.value == 4 &&
          widget.chatINFO.sohbetTuru ==
              widget.chatcontroller.chat.value?.sohbetTuru &&
          widget.chatINFO.kullAdi == widget.chatcontroller.chat.value?.kullAdi;
      final theme = Theme.of(context);
      final textColor =
          theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
      final selectedBackground =
          theme.colorScheme.primary.withValues(alpha: 0.16);
      final hoverBackground = textColor.withValues(alpha: 0.08);
      final mutedColor = textColor.withValues(alpha: 0.58);
      final hoverColor = textColor.withValues(alpha: 0.78);
      final avatarBackground = textColor.withValues(alpha: 0.10);
      final borderColor =
          theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;

      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () {
            widget.controller.pageviewController.value.jumpToPage(4);
            widget.chatcontroller.changeChat(widget.chatINFO);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            margin: const EdgeInsets.symmetric(vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedBackground
                  : _hovered
                      ? hoverBackground
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
                        color: avatarBackground,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.chatINFO.chatImage.mediaURL.minURL,
                          fit: BoxFit.cover,
                        ),
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
                            BorderSide(color: borderColor, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.chatINFO.adSoyad,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? textColor
                          : (_hovered ? hoverColor : mutedColor),
                      overflow: TextOverflow.ellipsis,
                    ),
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

class _IconAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconAction({required this.icon, required this.onTap});

  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ??
        Theme.of(context).colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: _hovered
                ? textColor.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(widget.icon,
              size: 14,
              color: _hovered ? textColor : textColor.withValues(alpha: 0.52)),
        ),
      ),
    );
  }
}
