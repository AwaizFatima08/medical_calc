import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalcalc/app/ads.dart';
import 'package:medicalcalc/app/settings.dart';
import 'package:medicalcalc/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(
  WidgetTester tester, [
  Map<String, Object> prefs = const {},
]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sp),
        adsEnabledProvider.overrideWithValue(false),
      ],
      child: const MedicalCalcApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first launch asks who is using the app', (tester) async {
    await pumpApp(tester);
    expect(find.text('Who is using this app?'), findsOneWidget);
  });

  testWidgets('public path shows disclaimer then public tools only', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('mode_public')));
    await tester.pumpAndSettle();
    expect(find.text('Before you start'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('BMI and waist check'), findsOneWidget);
    expect(find.text('eGFR (CKD-EPI 2021)'), findsNothing);
  });

  testWidgets('doctor path needs the declaration', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('mode_doctor')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Who is using this app?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('mode_doctor')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I confirm'));
    await tester.pumpAndSettle();
    expect(find.text('eGFR (CKD-EPI 2021)'), findsOneWidget);
  });

  testWidgets('search filters doctor tools by alias', (tester) async {
    await pumpApp(tester, {'mode': 'doctor', 'doctor_declared': true});
    await tester.enterText(find.byKey(const Key('search')), 'crcl');
    await tester.pumpAndSettle();
    expect(find.text('Creatinine clearance (Cockcroft-Gault)'), findsOneWidget);
    expect(find.text('QTc'), findsNothing);
  });

  testWidgets('opening a tool records it in recents', (tester) async {
    await pumpApp(tester, {'mode': 'public'});
    await tester.tap(find.text('BMI and waist check'));
    await tester.pumpAndSettle();
    expect(find.text('Result'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Recently used'), findsOneWidget);
  });
}
