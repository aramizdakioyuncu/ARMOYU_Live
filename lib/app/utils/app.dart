import 'package:armoyu_desktop/app/routes/routes.dart';
import 'package:armoyu_desktop/app/theme/theme.dart';
import 'package:armoyu_desktop/app/utils/appinfo.dart';
import 'package:armoyu_widgets/core/appcore.dart';
import 'package:armoyu_widgets/translations/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppInfo.appName,
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.dark,
      translationsKeys: AppTranslation.translationKeys,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorKey: AppCore.navigatorKey,
    );
  }
}
