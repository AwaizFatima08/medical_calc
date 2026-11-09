// Runs every test/golden/<id>.json against the calculator registry.
// A working calculator without a golden file fails (design §9).

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medicalcalc/calc/model.dart';
import 'package:medicalcalc/calc/registry.dart';
import 'package:medicalcalc/calc/units.dart';

Map<String, dynamic> _load(String id) => jsonDecode(
  File('test/golden/$id.json').readAsStringSync(),
) as Map<String, dynamic>;

Inputs _inputs(Map<String, dynamic> raw) => Inputs({
  for (final e in raw.entries)
    e.key: switch (e.value) {
      final String s => DateTime.parse(s),
      final Object? o => o,
    },
});

void main() {
  test('every calculator has golden vectors', () {
    for (final id in [...kCalculators.keys, ...kCustomScreens]) {
      expect(
        File('test/golden/$id.json').existsSync(),
        isTrue,
        reason: 'missing test/golden/$id.json',
      );
    }
  });

  for (final def in kCalculators.values) {
    group(def.id, () {
      final file = _load(def.id);
      for (final c in (file['cases'] as List).cast<Map<String, dynamic>>()) {
        test(c['name'] as String, () {
          final result = def.compute(
            _inputs(c['inputs'] as Map<String, dynamic>),
          );
          final expected = c['expect'] as Map<String, dynamic>;
          expect(result, isNotNull);
          if (expected.containsKey('headline')) {
            expect(result!.headline, expected['headline']);
          }
          if (expected.containsKey('band')) {
            expect(result!.band, expected['band']);
          }
          if (expected.containsKey('detail')) {
            expect(
              result!.details.join('\n'),
              contains(expected['detail'] as String),
            );
          }
        });
      }
    });
  }

  group('lab_units', () {
    final byId = {for (final q in kLabConverterTests) q.id: q};
    final file = _load('lab_units');
    for (final c in (file['cases'] as List).cast<Map<String, dynamic>>()) {
      test(c['name'] as String, () {
        final q = byId[c['quantity']]!;
        final unit = q.units.firstWhere((u) => u.label == c['unit']);
        final base = unit.toBase((c['value'] as num).toDouble());
        expect(base, closeTo((c['base'] as num).toDouble(), 0.01));
        expect(unit.fromBase(base), closeTo((c['value'] as num).toDouble(), 1e-9));
      });
    }
  });

  test('incomplete inputs give no result', () {
    for (final def in kCalculators.values) {
      final needsEntry = def.inputs.any(
        (i) => switch (i) {
          NumberInput(:final optional) => !optional,
          ChoiceInput(:final initial) => initial == null,
          DateInput() => true,
          ToggleInput() => false,
        },
      );
      if (!needsEntry) continue; // yes/no scores: all "no" is a valid 0
      expect(def.compute(const Inputs({})), isNull, reason: def.id);
    }
  });
}
