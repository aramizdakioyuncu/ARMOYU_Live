import 'package:armoyu_desktop/app/theme/app_theme_tokens.dart';
import 'package:armoyu_desktop/app/widgets/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class AppbarWidget {
  static Widget buildAppBar({String? label, List<Widget> actions = const []}) {
    var isHoveredClose = false.obs;

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final tokens = AppThemeTokens.of(context);
        final themeBackgroundColor =
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
        final backgroundColor = _slightlyDarker(themeBackgroundColor);
        final foregroundColor =
            theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;

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
            color: backgroundColor,
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
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    ...actions,
                    AppIconAction(
                      icon: Icons.remove,
                      color: foregroundColor,
                      size: 35,
                      iconSize: 19,
                      tooltip: 'Küçült',
                      onTap: () async {
                        windowManager.minimize();
                      },
                    ),
                    AppIconAction(
                      icon: Icons.crop_square,
                      color: foregroundColor,
                      size: 35,
                      iconSize: 16,
                      tooltip: 'Büyüt',
                      onTap: () async {
                        bool isMaximized = await windowManager.isMaximized();
                        if (isMaximized) {
                          windowManager.unmaximize();
                        } else {
                          windowManager.maximize();
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
                        () => Tooltip(
                          message: 'Kapat',
                          child: GestureDetector(
                            onTap: () {
                              windowManager.close();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              width: 44,
                              height: 35,
                              decoration: BoxDecoration(
                                color: isHoveredClose.value
                                    ? tokens.destructive
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(tokens.radiusSm),
                              ),
                              child: Icon(
                                Icons.close,
                                color: isHoveredClose.value
                                    ? Colors.white
                                    : foregroundColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _slightlyDarker(Color color) {
    return Color.lerp(color, Colors.black, 0.2) ?? color;
  }
}
