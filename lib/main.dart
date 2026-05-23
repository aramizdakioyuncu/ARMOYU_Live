import 'dart:developer';
import 'dart:io';

import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart'; // kIsWeb için

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Video
  MediaKit.ensureInitialized();
  initializeWindowManager();

  await ARMOYU.service.setup();

  runApp(const App());
}

Future<void> initializeWindowManager() async {
  if (!kIsWeb && Platform.isWindows) {
    // WindowsManager işlemlerini burada başlatabilirsiniz
    log("Windows platformunda çalışıyor.");
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false, //Görev Çubuğunda Gözükmesin ise true
      titleBarStyle: TitleBarStyle.hidden,
      title: "ARMOYU LIVE",
      fullScreen: false,
      minimumSize: Size(1000, 600),
    );

    windowManager.waitUntilReadyToShow(
      windowOptions,
      () async {
        await windowManager.show();
        await windowManager.focus();
        await windowManager.setResizable(true);
      },
    );
  } else {
    log("WindowsManager yalnızca Windows platformunda çalışır.");
  }
}
