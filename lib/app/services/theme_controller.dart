import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeModeKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;
  SharedPreferences? _preferences;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  Future<void> loadThemeMode() async {
    _preferences ??= await SharedPreferences.getInstance();
    final savedMode = _preferences!.getString(_themeModeKey);

    if (savedMode == ThemeMode.light.name) {
      themeMode.value = ThemeMode.light;
      return;
    }

    if (savedMode == ThemeMode.dark.name) {
      themeMode.value = ThemeMode.dark;
      return;
    }

    themeMode.value = ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _preferences ??= await SharedPreferences.getInstance();
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _preferences!.setString(_themeModeKey, mode.name);
  }

  Future<void> enableDarkTheme() => setThemeMode(ThemeMode.dark);

  Future<void> enableLightTheme() => setThemeMode(ThemeMode.light);

  Future<void> toggleTheme(bool isDark) {
    return setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
