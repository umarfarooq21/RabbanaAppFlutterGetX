import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rabbana_flutter/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(Get.reset);

  testWidgets('App launches into splash then home', (tester) async {
    await tester.pumpWidget(const RabbanaApp());
    await tester.pump();

    expect(find.text('40 Rabbana'), findsOneWidget);
    expect(find.textContaining('Forty beautiful duas'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('All Duas'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
  });
}
