import 'package:armoyu_desktop/app/utils/app.dart';
import 'package:armoyu_desktop/app/services/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    final themeController = Get.put(ThemeController(), permanent: true);
    await themeController.loadThemeMode();
  });

  tearDown(Get.reset);

  testWidgets('App starts on splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
