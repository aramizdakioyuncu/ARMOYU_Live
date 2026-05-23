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
                          controller.changepage();
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
                  child: PageView(
                    controller: controller.pagecontroller.value,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (value) {
                      controller.selectedItem.value = value;
                    },
                    children: [
                      AppList.settingsList[0].page,
                      AppList.settingsList[1].page,
                    ],
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
