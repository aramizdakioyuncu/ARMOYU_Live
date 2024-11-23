import 'package:armoyu_desktop/app/services/armoyu_services.dart';
import 'package:armoyu_desktop/app/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  await ARMOYU.service.setup();

  windowManager.setTitle("Custom Title"); // Başlık ayarı
  windowManager.center();
  windowManager.setTitleBarStyle(TitleBarStyle.hidden);

  windowManager.setSize(const Size(500, 300));
  windowManager.setResizable(false);

  runApp(const App());
}
