import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class AppbarWidget {
  static Widget buildAppBar({String? label, List<Widget> actions = const []}) {
    var isHoveredClose = false.obs;

    return GestureDetector(
      onPanUpdate: (details) {
        windowManager.startDragging();
      },
      onDoubleTap: () async {
        if (await windowManager.isMaximized()) {
          windowManager.unmaximize();
        } else {
          windowManager.maximize();
        }
      },
      child: Container(
        color: Colors.transparent,
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.info,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  label ?? "ARMOYU",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                ...actions,
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 19,
                  ),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    windowManager.minimize();
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  icon: const Icon(
                    Icons.crop_square,
                    color: Colors.white,
                    size: 16,
                  ),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    bool isMaximized = await windowManager.isMaximized();
                    if (isMaximized) {
                      windowManager.unmaximize(); // Pencereyi normale döndür
                    } else {
                      windowManager.maximize(); // Pencereyi tam ekran yap
                    }
                  },
                ),
                MouseRegion(
                  onEnter: (_) {
                    isHoveredClose.value = true;
                  },
                  onExit: (_) {
                    isHoveredClose.value = false;
                  },
                  child: Obx(
                    () => IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          isHoveredClose.value
                              ? Colors.red
                              : Colors.transparent,
                        ),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {
                        windowManager.close();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
