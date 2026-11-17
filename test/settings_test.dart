import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rabbana_flutter/app.dart';
import 'package:rabbana_flutter/controllers/settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(Get.reset);

  Future<void> openSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const RabbanaApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  }

  testWidgets('Settings screen changes theme, reading and audio options', (
    tester,
  ) async {
    await openSettings(tester);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Settings'))).brightness,
      Brightness.light,
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Settings'))).brightness,
      Brightness.dark,
    );

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'dark');

    // Reading and recitation options (kept in one test: GetX keeps its
    // navigator between tests, so a second app launch in this file hangs).
    final settings = Get.find<SettingsController>();

    await tester.tap(find.text('Show meaning'));
    await tester.pumpAndSettle();
    expect(settings.showTranslation.value, isFalse);

    await tester.scrollUntilVisible(find.text('Fast'), 200);
    await tester.tap(find.text('Fast'));
    await tester.pumpAndSettle();
    expect(settings.recitationSpeed.value, RecitationSpeed.fast);

    await tester.scrollUntilVisible(find.text('Reset settings'), 200);
    await tester.tap(find.text('Reset settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(settings.showTranslation.value, isTrue);
    expect(settings.recitationSpeed.value, RecitationSpeed.normal);
  });
}
