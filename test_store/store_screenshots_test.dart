// Renders the Play Store phone screenshots from the real screens.
// Not part of `flutter test`. Run:
//   python3 tool/make_store_fonts.py <dir>
//   STORE_FONTS=<dir> flutter test test_store --update-goldens   → then move test_store/out/*.png to store/screenshots/
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalcalc/app/ads.dart';
import 'package:medicalcalc/app/settings.dart';
import 'package:medicalcalc/calc/who_cvd.dart';
import 'package:medicalcalc/calc/who_growth.dart';
import 'package:medicalcalc/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader.addFont(
      Future.value(ByteData.sublistView(File(p).readAsBytesSync())),
    );
  }
  await loader.load();
}

Future<void> _pumpApp(
  WidgetTester tester, [
  Map<String, Object> prefs = const {},
]) async {
  // ignore: invalid_use_of_visible_for_testing_member (test_store/ is a test, outside test/)
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  // 1080×2340 phone.
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
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

Future<void> _open(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.scrollUntilVisible(
    finder,
    150,
    // The home list, not the search field's horizontal scroller.
    scrollable: find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    ).first,
  );
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String key, String value) async {
  await tester.enterText(find.byKey(Key(key)), value);
  await tester.pumpAndSettle();
}

Future<void> _showResult(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byKey(const Key('result_value')));
  await tester.pumpAndSettle();
}

Future<void> _shot(String name) => expectLater(
  find.byType(MaterialApp),
  matchesGoldenFile('out/$name.png'),
);

const _doctor = {'mode': 'doctor', 'doctor_declared': true};
const _public = {'mode': 'public'};

void main() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
  final fonts = '$flutterRoot/bin/cache/artifacts/material_fonts';

  setUpAll(() async {
    // Roboto plus ₂ ↔ etc. from tool/make_store_fonts.py: the test engine has no font fallback.
    final merged = Platform.environment['STORE_FONTS']!;
    await _loadFont('Roboto', [
      '$merged/Roboto-Regular.ttf',
      '$merged/Roboto-Medium.ttf',
      '$merged/Roboto-Bold.ttf',
    ]);
    await _loadFont('MaterialIcons', ['$fonts/MaterialIcons-Regular.otf']);
    WhoGrowth.instance = WhoGrowth.fromJson(
      jsonDecode(File('assets/who_growth.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    WhoCvdChart.instance = WhoCvdChart.fromJson(
      jsonDecode(
            File('assets/who_cvd_south_asia_nonlab.json').readAsStringSync(),
          )
          as Map<String, dynamic>,
    );
  });

  testWidgets('1 welcome', (tester) async {
    await _pumpApp(tester);
    await _shot('1_welcome');
  });

  testWidgets('2 doctor home', (tester) async {
    await _pumpApp(tester, _doctor);
    await _shot('2_doctor_home');
  });

  testWidgets('3 egfr', (tester) async {
    await _pumpApp(tester, _doctor);
    await _open(tester, 'eGFR (CKD-EPI 2021)');
    await _type(tester, 'in_scr', '1.4');
    await _type(tester, 'in_age', '62');
    await tester.tap(find.byKey(const Key('in_sex_1')));
    await _showResult(tester);
    await _shot('3_egfr');
  });

  testWidgets('4 public home', (tester) async {
    await _pumpApp(tester, _public);
    await _shot('4_public_home');
  });

  testWidgets('5 blood pressure', (tester) async {
    await _pumpApp(tester, _public);
    await _open(tester, 'Blood pressure reading check');
    await _type(tester, 'in_sbp', '186');
    await _type(tester, 'in_dbp', '122');
    await tester.tap(find.byKey(const Key('in_s_head')));
    await _showResult(tester);
    await tester.ensureVisible(find.byKey(const Key('emergency')));
    await tester.pumpAndSettle();
    await _shot('5_blood_pressure');
  });

  testWidgets('6 lab converter', (tester) async {
    await _pumpApp(tester, _doctor);
    await _open(tester, 'Lab unit converter');
    await _type(tester, 'lab_unit_0', '1.2');
    await _shot('6_lab_converter');
  });
}
