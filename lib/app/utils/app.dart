import 'package:armoyu_desktop/app/routes/routes.dart';
import 'package:armoyu_desktop/app/theme/theme.dart';
import 'package:armoyu_desktop/app/utils/appinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppInfo.appName,
      theme: appThemeData,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
