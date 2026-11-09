// Shared builder for point scores (CHA2DS2-VA, HAS-BLED, Wells, CURB-65 …).

import 'model.dart';

class ScoreBand {
  const ScoreBand(this.upTo, this.label, this.severity, this.meaning);

  /// Highest total (inclusive) in this band; use double.infinity for the top.
  final num upTo;
  final String label;
  final Severity severity;
  final String meaning;
}

/// Sum of every toggle's points and every choice's value. Null if a choice
/// without an initial option is still unanswered.
num? scoreTotal(List<InputSpec> items, Inputs v) {
  num total = 0;
  for (final item in items) {
    switch (item) {
      case ToggleInput(:final points):
        if (v.flag(item.id)) total += points;
      case ChoiceInput():
        final c = v.choice(item.id);
        if (c == null) return null;
        total += c;
      case NumberInput() || DateInput():
        break;
    }
  }
  return total;
}

ScoreBand bandFor(num total, List<ScoreBand> bands) =>
    bands.firstWhere((b) => total <= b.upTo, orElse: () => bands.last);

/// Breakdown lines for the points that counted.
List<String> scoreBreakdown(List<InputSpec> items, Inputs v) {
  final lines = <String>[];
  for (final item in items) {
    switch (item) {
      case ToggleInput(:final points):
        if (v.flag(item.id)) {
          lines.add('${item.label}: +${fmt(points.toDouble())}');
        }
      case ChoiceInput(:final choices):
        final c = v.choice(item.id);
        if (c != null && c != 0) {
          final label = choices.firstWhere((x) => x.value == c).label;
          lines.add('${item.label}: $label (+${fmt(c.toDouble())})');
        }
      case NumberInput() || DateInput():
        break;
    }
  }
  return lines;
}

CalcResult scoreResult(
  List<InputSpec> items,
  Inputs v,
  List<ScoreBand> bands, {
  String unit = 'points',
}) {
  final total = scoreTotal(items, v)!;
  final band = bandFor(total, bands);
  return CalcResult(
    headline: fmt(total.toDouble()),
    unit: unit,
    band: band.label,
    severity: band.severity,
    interpretation: band.meaning,
    details: scoreBreakdown(items, v),
  );
}
