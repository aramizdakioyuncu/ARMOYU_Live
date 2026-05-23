import 'package:armoyu_desktop/app/modules/settings/_main/controllers/settings_controller.dart';
import 'package:armoyu_desktop/app/utils/applist.dart';
import 'package:armoyu_desktop/app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return LayoutBuilder(
      builder: (context, constraints) {
        final sidebarWidth = constraints.maxWidth < 1300 ? 260.0 : 290.0;
        final contentWidth = constraints.maxWidth < 1300 ? 520.0 : 560.0;
        final minimumWidth = sidebarWidth + contentWidth + 24;
        final canFitWithoutScroll = constraints.maxWidth >= minimumWidth;

        Widget buildSidebar() {
          return SizedBox(
            width: sidebarWidth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawScrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                controller: controller.controller.value,
                child: ListView.builder(
                  controller: controller.controller.value,
                  itemCount: AppList.settingsList.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => ListTile(
                        title: Text(AppList.settingsList[index].title),
                        selected: controller.selectedItem.value == index,
                        onTap: () {
                          controller.selectedItem.value = index;
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        Widget buildContent() {
          final settingsPages = AppList.settingsList
              .map<Widget>(
                (item) => item.page is Widget
                    ? item.page as Widget
                    : const _ComingSoonSettingsView(),
              )
              .toList();

          return SizedBox(
            width: contentWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            AppList.settingsList[controller.selectedItem.value]
                                .title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _CloseButton(),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: KeyedSubtree(
                        key: ValueKey<int>(controller.selectedItem.value),
                        child: settingsPages[controller.selectedItem.value],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              AppbarWidget.buildAppBar(
                  label: AppList
                      .settingsList[controller.selectedItem.value].title),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: canFitWithoutScroll
                      ? Row(
                          children: [
                            buildSidebar(),
                            Expanded(
                              child: Center(
                                child: buildContent(),
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: minimumWidth),
                            child: Row(
                              children: [
                                buildSidebar(),
                                buildContent(),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ComingSoonSettingsView extends StatelessWidget {
  const _ComingSoonSettingsView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Bu ayar bölümü henüz hazırlanmadı.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade800,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.close,
              color: Colors.grey.shade700,
              size: 20,
            ),
          ),
        ),
        Text(
          "ESC",
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        )
      ],
    );
  }
}
