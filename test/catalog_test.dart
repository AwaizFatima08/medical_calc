import 'package:flutter_test/flutter_test.dart';
import 'package:medicalcalc/calc/catalog.dart';
import 'package:medicalcalc/calc/registry.dart';

void main() {
  test('release 1 has 28 doctor and 10 public tools', () {
    expect(toolsFor(ToolMode.doctor), hasLength(28));
    expect(toolsFor(ToolMode.public), hasLength(10));
  });

  test('tool ids are unique', () {
    final ids = kTools.map((t) => t.id).toSet();
    expect(ids, hasLength(kTools.length));
  });

  test('every calculator has a catalog entry', () {
    for (final id in kCalculators.keys) {
      expect(toolById(id), isNotNull, reason: id);
    }
  });

  test('search matches name, alias and category', () {
    final egfr = toolById('egfr')!;
    expect(egfr.matches('kdigo'), isTrue);
    expect(egfr.matches('KIDNEY'), isTrue);
    expect(egfr.matches('dengue'), isFalse);
  });
}
