// WHO Child Growth Standards 2006: LMS lookup and z-scores. Pure Dart; the
// tables (assets/who_growth.json) are loaded once at start-up.

import 'dart:math' as math;

class Lms {
  const Lms(this.l, this.m, this.s);
  final double l, m, s;

  double valueAt(double z) => m * math.pow(1 + l * s * z, 1 / l);

  /// Plain LMS z-score.
  double z(double x) => (math.pow(x / m, l) - 1) / (l * s);

  /// WHO restricted application for weight-based indicators: beyond ±3 SD
  /// the distance between SD2 and SD3 is used (WHO 2006 technical report).
  double zRestricted(double x) {
    final zz = z(x);
    if (zz > 3) {
      final sd3 = valueAt(3), sd23 = sd3 - valueAt(2);
      return 3 + (x - sd3) / sd23;
    }
    if (zz < -3) {
      final sd3 = valueAt(-3), sd23 = valueAt(-2) - sd3;
      return -3 + (x - sd3) / sd23;
    }
    return zz;
  }
}

class GrowthTable {
  GrowthTable(this.rows);

  /// [x, L, M, S] sorted by x (age in days, or length/height in cm).
  final List<List<double>> rows;

  double get minX => rows.first[0];
  double get maxX => rows.last[0];

  /// Linear interpolation between rows; null outside the table.
  Lms? at(double x) {
    if (x < minX - 1e-9 || x > maxX + 1e-9) return null;
    var lo = 0, hi = rows.length - 1;
    while (hi - lo > 1) {
      final mid = (lo + hi) ~/ 2;
      if (rows[mid][0] <= x) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final a = rows[lo], b = rows[hi];
    final t = b[0] == a[0] ? 0.0 : ((x - a[0]) / (b[0] - a[0])).clamp(0.0, 1.0);
    double lerp(int i) => a[i] + (b[i] - a[i]) * t;
    return Lms(lerp(1), lerp(2), lerp(3));
  }
}

class WhoGrowth {
  WhoGrowth._(this.tables);
  final Map<String, GrowthTable> tables;

  static WhoGrowth? instance;

  static WhoGrowth fromJson(Map<String, dynamic> json) {
    final tables = <String, GrowthTable>{};
    for (final e in json.entries) {
      if (e.value is! Map) continue;
      final rows = ((e.value as Map)['rows'] as List)
          .map((r) => (r as List).map((v) => (v as num).toDouble()).toList())
          .toList();
      tables[e.key] = GrowthTable(rows);
    }
    return WhoGrowth._(tables);
  }

  GrowthTable table(String indicator, {required bool girl}) =>
      tables['${indicator}_${girl ? 'girls' : 'boys'}']!;
}
