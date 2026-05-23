import 'package:armoyu_desktop/app/data/models/room_model.dart';
import 'package:armoyu_desktop/app/modules/home/_main/controllers/home_controller.dart';
import 'package:armoyu_desktop/app/modules/home/explore/views/explore_view.dart';
import 'package:armoyu_desktop/app/modules/home/mainpage/_main/views/mainpage_view.dart';
import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:armoyu_desktop/app/widgets/group_widget.dart';
import 'package:armoyu_desktop/app/widgets/groups_change_widget.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/group/group_room.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Column(
            children: [
              AppbarWidget.buildAppBar(),
              Expanded(
                child: Row(
                  children: [
                    _GroupRail(controller: controller),
                    Expanded(
                      child: Obx(() => PageView(
                            controller: controller.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (value) {
                              controller.selectedPage.value = value;
                            },
                            children: [
                              const MainpageView(),
                              const ExploreView(),
                              ...List.generate(
                                AppList.groups.length,
                                (index) => GroupWidget.pageDetail(
                                  context,
                                  AppList.groups[index],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Incoming call notification overlay
          Obx(() => controller.socketio.isCallingMe.value == true
              ? _IncomingCallCard(controller: controller)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _GroupRail extends StatelessWidget {
  final HomeController controller;
  const _GroupRail({required this.controller});

  Future<void> _loadGroup(BuildContext context, int index) async {
    final groupID = AppList.groups[index].groupID;

    controller.pageController.jumpToPage(index + 2);
    controller.selectedPage.value = index + 1;

    controller.socketio.fetchUserList(groupID: groupID);

    final GroupRoomsResponse response =
        await ARMOYU.service.groupServices.groupRoomsFetch(groupID: groupID);

    AppList.groups[index].rooms!.value = [];
    for (GroupRoom element in response.response!) {
      AppList.groups[index].rooms!.add(
        Room(
          groupID: groupID,
          roomID: element.roomID,
          name: element.name,
          limit: element.limit,
          type: element.type,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          // ARMOYU home logo
          _RailHomeBtn(
            onTap: () {
              controller.pageController.jumpToPage(0);
              controller.selectedPage.value = 0;
            },
            controller: controller,
          ),

          // Separator
          _RailDivider(),

          // Group list
          Expanded(
            child: Obx(() => ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  children: [
                    ...List.generate(
                      AppList.groups.length,
                      (index) => GroupsChangeWidget.groups(
                        index,
                        onTap: () => _loadGroup(context, index),
                        selectedPage: controller.selectedPage,
                      ),
                    ),
                    _AddGroupBtn(
                      onTap: () => controller.showAlertDialog(
                          context, controller.socketio),
                    ),
                  ],
                )),
          ),

          // Separator
          _RailDivider(),

          // Explore button
          _RailExploreBtn(
            onTap: () {
              controller.pageController.jumpToPage(1);
            },
            controller: controller,
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RailHomeBtn extends StatefulWidget {
  final VoidCallback onTap;
  final HomeController controller;
  const _RailHomeBtn({required this.onTap, required this.controller});

  @override
  State<_RailHomeBtn> createState() => _RailHomeBtnState();
}

class _RailHomeBtnState extends State<_RailHomeBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = widget.controller.selectedPage.value == 0;
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Active indicator pill
                Positioned(
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: 4,
                    height: isSelected ? 32 : (_hovered ? 16 : 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(4)),
                    ),
                  ),
                ),
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red
                        : (_hovered
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFF1A1A1A)),
                    borderRadius: BorderRadius.circular(
                        isSelected ? 14 : (_hovered ? 14 : 21)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        isSelected ? 14 : (_hovered ? 14 : 21)),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://storage.aramizdakioyuncu.com/galeri/ana-yapi/armoyu64.png",
                      fit: BoxFit.cover,
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

class _RailExploreBtn extends StatefulWidget {
  final VoidCallback onTap;
  final HomeController controller;
  const _RailExploreBtn({required this.onTap, required this.controller});

  @override
  State<_RailExploreBtn> createState() => _RailExploreBtnState();
}

class _RailExploreBtnState extends State<_RailExploreBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Keşfet",
      preferBelow: false,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _hovered
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFF1A1A1A),
                borderRadius:
                    BorderRadius.circular(_hovered ? 14 : 21),
              ),
              child: Icon(
                Icons.explore_outlined,
                size: 20,
                color:
                    _hovered ? Colors.green.shade400 : const Color(0xFF666666),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddGroupBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _AddGroupBtn({required this.onTap});

  @override
  State<_AddGroupBtn> createState() => _AddGroupBtnState();
}

class _AddGroupBtnState extends State<_AddGroupBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Sunucu Ekle",
      preferBelow: false,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _hovered
                      ? Colors.green.withValues(alpha: 0.2)
                      : const Color(0xFF1A1A1A),
                  borderRadius:
                      BorderRadius.circular(_hovered ? 14 : 21),
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 22,
                  color: _hovered
                      ? Colors.green.shade400
                      : const Color(0xFF666666),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 1,
        color: const Color(0xFF1E1E1E),
      ),
    );
  }
}

class _IncomingCallCard extends StatelessWidget {
  final HomeController controller;
  const _IncomingCallCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade400,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Gelen Arama",
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Caller info
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2A2A2A),
                    border: Border.all(
                        color: Colors.green.shade400.withValues(alpha: 0.4),
                        width: 2),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: AppList.sessions.isNotEmpty
                          ? AppList.sessions.first.currentUser.user.avatar!
                              .mediaURL.minURL.value
                          : "",
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.person,
                          color: Colors.white54, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.socketio.whichuserisCallingMe.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                      const Text(
                        "sesli arama",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _CallActionBtn(
                    label: "Reddet",
                    icon: Icons.call_end_rounded,
                    color: Colors.red,
                    onTap: () => controller.socketio.closecall(
                        controller.socketio.whichuserisCallingMe.value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CallActionBtn(
                    label: "Kabul Et",
                    icon: Icons.call_rounded,
                    color: Colors.green,
                    onTap: () => controller.socketio.acceptcall(
                        controller.socketio.whichuserisCallingMe.value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CallActionBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CallActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CallActionBtn> createState() => _CallActionBtnState();
}

class _CallActionBtnState extends State<_CallActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color
                : widget.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: _hovered ? Colors.white : widget.color,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? Colors.white : widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
