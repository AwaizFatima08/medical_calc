// WHO 2019 non-laboratory CVD risk chart, South Asia region (Kaptoge 2019,
// appendix 2 p. 36). Pure Dart; loaded from assets at start-up.

class WhoCvdChart {
  WhoCvdChart._(this._values);

  /// [sex][smoker][age band][SBP band][BMI band] → % 10-year risk.
  final Map<String, Map<String, List<List<List<int>>>>> _values;

  static WhoCvdChart? instance;

  static WhoCvdChart fromJson(Map<String, dynamic> json) {
    final values = <String, Map<String, List<List<List<int>>>>>{};
    for (final sex in ['men', 'women']) {
      values[sex] = {
        for (final s in ['smoker', 'nonsmoker'])
          s: [
            for (final age in (json['values'][sex][s] as List))
              [
                for (final sbp in (age as List))
                  [for (final v in (sbp as List)) (v as num).toInt()],
              ],
          ],
      };
    }
    return WhoCvdChart._(values);
  }

  static int? ageBand(double age) =>
      age < 40 || age >= 75 ? null : ((age - 40) ~/ 5).clamp(0, 6);
  static int sbpBand(double sbp) => sbp < 120
      ? 0
      : sbp < 140
      ? 1
      : sbp < 160
      ? 2
      : sbp < 180
      ? 3
      : 4;
  static int bmiBand(double bmi) => bmi < 20
      ? 0
      : bmi < 25
      ? 1
      : bmi < 30
      ? 2
      : bmi < 35
      ? 3
      : 4;

  int risk({
    required bool female,
    required bool smoker,
    required int ageBand,
    required double sbp,
    required double bmi,
  }) =>
      _values[female ? 'women' : 'men']![smoker
          ? 'smoker'
          : 'nonsmoker']![ageBand][sbpBand(sbp)][bmiBand(bmi)];
}
