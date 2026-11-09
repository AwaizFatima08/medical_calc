// Calculator definitions and results. Pure Dart: no Flutter imports.

import 'units.dart';

/// Colour band of a result. The UI always shows the label too, never colour
/// alone (design §6, S6).
enum Severity { normal, info, caution, warning, danger }

sealed class InputSpec {
  const InputSpec(
    this.id,
    this.label, {
    this.help,
    this.showWhen,
    this.heading,
  });
  final String id;
  final String label;
  final String? help;

  /// Section title shown above this input (e.g. "Any of these now?").
  final String? heading;

  /// Show only when choice [showWhen.id] has value [showWhen.value].
  final ({String id, num value})? showWhen;

  bool visible(Inputs v) =>
      showWhen == null || v.choice(showWhen!.id) == showWhen!.value;
}

/// A number with units. [min]/[max] are in the quantity's base unit.
class NumberInput extends InputSpec {
  const NumberInput(
    super.id,
    super.label, {
    required this.quantity,
    required this.min,
    required this.max,
    this.decimals = 1,
    this.optional = false,
    super.help,
    super.showWhen,
    super.heading,
  });

  final Quantity quantity;
  final double min;
  final double max;
  final int decimals;
  final bool optional;
}

/// A yes/no item, usually worth [points] in a score.
class ToggleInput extends InputSpec {
  const ToggleInput(
    super.id,
    super.label, {
    this.points = 1,
    super.help,
    super.showWhen,
    super.heading,
  });
  final num points;
}

class Choice {
  const Choice(this.label, this.value);
  final String label;
  final num value;
}

/// Pick one option; [Choice.value] is the points or code used by compute.
class ChoiceInput extends InputSpec {
  const ChoiceInput(
    super.id,
    super.label, {
    required this.choices,
    this.initial,
    this.followsBmiSetting = false,
    super.help,
    super.showWhen,
    super.heading,
  });

  final List<Choice> choices;

  /// Pre-select from Settings → BMI standard (0 Asian, 1 international).
  final bool followsBmiSetting;

  /// Index pre-selected, or null to force a choice.
  final int? initial;
}

class DateInput extends InputSpec {
  const DateInput(
    super.id,
    super.label, {
    super.help,
    super.showWhen,
    super.heading,
  });
}

/// Values entered so far. Numbers are in base units; choices are their value;
/// toggles are bool (default false).
class Inputs {
  const Inputs(this._values);
  final Map<String, Object?> _values;

  double? number(String id) => (_values[id] as num?)?.toDouble();
  bool flag(String id) => _values[id] == true;
  num? choice(String id) => _values[id] as num?;
  DateTime? date(String id) => _values[id] as DateTime?;
}

class CalcResult {
  const CalcResult({
    required this.headline,
    this.unit,
    this.band,
    this.severity = Severity.info,
    this.details = const [],
    this.interpretation,
    this.warnings = const [],
    this.emergency,
  });

  /// Main value, already formatted (e.g. "89" or "3 points").
  final String headline;
  final String? unit;

  /// Band label, e.g. "G2: mildly decreased".
  final String? band;
  final Severity severity;

  /// Extra lines: breakdown of points, other formulas, etc.
  final List<String> details;

  /// What the source says this band means.
  final String? interpretation;
  final List<String> warnings;

  /// Red-flag message: the result screen shows an emergency box with a
  /// "Call 1122" button (design §6 S7).
  final String? emergency;
}

class Source {
  const Source(this.citation, {this.url});
  final String citation;
  final String? url;
}

class CalcDefinition {
  const CalcDefinition({
    required this.id,
    required this.inputs,
    required this.compute,
    required this.formula,
    required this.sources,
    required this.version,
    this.notes = const [],
    this.reviewedOn,
  });

  /// Same id as the catalog entry.
  final String id;
  final List<InputSpec> inputs;

  /// Returns null until every required input is valid.
  final CalcResult? Function(Inputs) compute;

  /// Plain-text formula shown under "Show formula".
  final String formula;
  final List<Source> sources;

  /// Formula/guideline version, e.g. "CKD-EPI 2021".
  final String version;

  /// Always-shown caveats (e.g. "Not for use alone").
  final List<String> notes;

  /// Date Homi signed this tool off; null shows "Review pending".
  final String? reviewedOn;
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// e.g. "9 Nov 2026".
String fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whole days from [a] to [b], ignoring time of day and DST.
int daysBetween(DateTime a, DateTime b) => DateTime.utc(
  b.year,
  b.month,
  b.day,
).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

String fmt(double v, [int decimals = 1]) {
  final s = v.toStringAsFixed(decimals);
  return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
}
