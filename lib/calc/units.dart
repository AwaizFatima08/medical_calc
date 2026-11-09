// Unit conversion. Every formula works in one base unit per quantity; inputs
// are converted at the edge. Pure Dart.
//
// Lab factors are from standard SI conversion tables; each is a golden-vector
// case in test/golden/lab_units.json and is part of Homi's review (design §9).

/// A unit of a quantity: base = value * factor + offset.
class Unit {
  const Unit(this.label, this.factor, {this.offset = 0, this.si = false});

  final String label;
  final double factor;
  final double offset;

  /// True for the SI unit of a lab quantity (used for the default unit).
  final bool si;

  double toBase(double v) => v * factor + offset;
  double fromBase(double base) => (base - offset) / factor;
}

/// A measurable quantity with its base unit first.
class Quantity {
  const Quantity(this.id, this.name, this.units, {this.isLab = false});

  final String id;
  final String name;
  final List<Unit> units;

  /// Lab quantities follow the conventional/SI default in Settings.
  final bool isLab;

  Unit get base => units.first;

  Unit defaultUnit({required bool preferSi}) {
    if (preferSi && isLab) {
      for (final u in units) {
        if (u.si) return u;
      }
    }
    return units.first;
  }
}

abstract final class Q {
  // ---- Body ----
  static const weight = Quantity('weight', 'Weight', [
    Unit('kg', 1),
    Unit('lb', 0.45359237),
  ]);
  static const height = Quantity('height', 'Height', [
    Unit('cm', 1),
    Unit('in', 2.54),
    Unit('ft', 30.48),
  ]);
  static const feet = Quantity('feet', 'Feet', [Unit('ft', 1)]);
  static const inches = Quantity('inches', 'Inches', [Unit('in', 1)]);
  static const length = Quantity('length', 'Length', [
    Unit('cm', 1),
    Unit('in', 2.54),
  ]);
  static const temperature = Quantity('temperature', 'Temperature', [
    Unit('°C', 1),
    Unit('°F', 5 / 9, offset: -160 / 9),
  ]);

  // ---- Lab (base = conventional unit used by Pakistani labs) ----
  static const creatinine = Quantity('creatinine', 'Creatinine', [
    Unit('mg/dL', 1),
    Unit('µmol/L', 1 / 88.42, si: true),
  ], isLab: true);
  static const glucose = Quantity('glucose', 'Glucose', [
    Unit('mg/dL', 1),
    Unit('mmol/L', 18.016, si: true),
  ], isLab: true);

  /// Base is BUN (blood urea nitrogen) in mg/dL. Pakistani reports usually
  /// give "urea" in mg/dL, which is 2.14 × BUN.
  static const urea = Quantity('urea', 'Urea / BUN', [
    Unit('BUN mg/dL', 1),
    Unit('urea mg/dL', 1 / 2.14),
    Unit('urea mmol/L', 2.8, si: true),
  ], isLab: true);
  static const albumin = Quantity('albumin', 'Albumin', [
    Unit('g/dL', 1),
    Unit('g/L', 0.1, si: true),
  ], isLab: true);
  static const totalProtein = Quantity('total_protein', 'Total protein', [
    Unit('g/dL', 1),
    Unit('g/L', 0.1, si: true),
  ], isLab: true);
  static const calcium = Quantity('calcium', 'Calcium', [
    Unit('mg/dL', 1),
    Unit('mmol/L', 4.008, si: true),
  ], isLab: true);
  static const magnesium = Quantity('magnesium', 'Magnesium', [
    Unit('mg/dL', 1),
    Unit('mmol/L', 2.431, si: true),
  ], isLab: true);
  static const phosphate = Quantity('phosphate', 'Phosphate', [
    Unit('mg/dL', 1),
    Unit('mmol/L', 3.097, si: true),
  ], isLab: true);

  /// Sodium, potassium, chloride, bicarbonate: mEq/L equals mmol/L.
  static const electrolyte = Quantity('electrolyte', 'Electrolyte', [
    Unit('mmol/L', 1, si: true),
  ], isLab: true);
  static const bilirubin = Quantity('bilirubin', 'Bilirubin', [
    Unit('mg/dL', 1),
    Unit('µmol/L', 1 / 17.1, si: true),
  ], isLab: true);
  static const uricAcid = Quantity('uric_acid', 'Uric acid', [
    Unit('mg/dL', 1),
    Unit('µmol/L', 1 / 59.48, si: true),
  ], isLab: true);
  static const cholesterol = Quantity(
    'cholesterol',
    'Cholesterol (total, LDL, HDL)',
    [Unit('mg/dL', 1), Unit('mmol/L', 38.67, si: true)],
    isLab: true,
  );
  static const triglycerides = Quantity('triglycerides', 'Triglycerides', [
    Unit('mg/dL', 1),
    Unit('mmol/L', 88.57, si: true),
  ], isLab: true);
  static const haemoglobin = Quantity('haemoglobin', 'Haemoglobin', [
    Unit('g/dL', 1),
    Unit('g/L', 0.1, si: true),
    Unit('mmol/L', 1.611),
  ], isLab: true);
  static const ferritin = Quantity('ferritin', 'Ferritin', [
    Unit('ng/mL', 1),
    Unit('µg/L', 1, si: true),
  ], isLab: true);
  static const iron = Quantity('iron', 'Iron', [
    Unit('µg/dL', 1),
    Unit('µmol/L', 5.585, si: true),
  ], isLab: true);
  static const lactate = Quantity('lactate', 'Lactate', [
    Unit('mg/dL', 1),
    Unit('mmol/L', 9.008, si: true),
  ], isLab: true);
  static const ammonia = Quantity('ammonia', 'Ammonia', [
    Unit('µg/dL', 1),
    Unit('µmol/L', 1.703, si: true),
  ], isLab: true);
  static const vitaminD = Quantity('vitamin_d', 'Vitamin D (25-OH)', [
    Unit('ng/mL', 1),
    Unit('nmol/L', 1 / 2.496, si: true),
  ], isLab: true);
  static const vitaminB12 = Quantity('vitamin_b12', 'Vitamin B12', [
    Unit('pg/mL', 1),
    Unit('pmol/L', 1.355, si: true),
  ], isLab: true);
  static const freeT4 = Quantity('free_t4', 'Free T4', [
    Unit('ng/dL', 1),
    Unit('pmol/L', 1 / 12.87, si: true),
  ], isLab: true);
  static const tsh = Quantity('tsh', 'TSH', [
    Unit('mIU/L', 1, si: true),
    Unit('µIU/mL', 1),
  ], isLab: true);

  /// HbA1c: % (NGSP/DCCT) ↔ mmol/mol (IFCC). mmol/mol = 10.929 × (% − 2.15).
  static const hba1c = Quantity('hba1c', 'HbA1c', [
    Unit('%', 1),
    Unit('mmol/mol', 1 / 10.929, offset: 2.15, si: true),
  ], isLab: true);

  // ---- Simple single-unit quantities ----
  static const age = Quantity('age', 'Age', [Unit('years', 1)]);
  static const ageMonths = Quantity('age_months', 'Age', [Unit('months', 1)]);
  static const bp = Quantity('bp', 'Blood pressure', [Unit('mmHg', 1)]);
  static const heartRate = Quantity('heart_rate', 'Heart rate', [
    Unit('/min', 1),
  ]);
  static const humidity = Quantity('humidity', 'Humidity', [Unit('%', 1)]);
  static const respRate = Quantity('resp_rate', 'Respiratory rate', [
    Unit('/min', 1),
  ]);
  static const ms = Quantity('ms', 'Interval', [Unit('ms', 1)]);
  static const percent = Quantity('percent', 'Percent', [Unit('%', 1)]);
  static const hours = Quantity('hours', 'Time', [
    Unit('h', 1),
    Unit('min', 1 / 60),
  ]);
  static const volume = Quantity('volume', 'Volume', [
    Unit('mL', 1),
    Unit('L', 1000),
  ]);
  static const dropFactor = Quantity('drop_factor', 'Drop factor', [
    Unit('drops/mL', 1),
  ]);
  static const weeks = Quantity('weeks', 'Weeks', [Unit('weeks', 1)]);
  static const days = Quantity('days', 'Days', [Unit('days', 1)]);
  static const osmolality = Quantity('osmolality', 'Osmolality', [
    Unit('mOsm/kg', 1),
  ]);
  static const ast = Quantity('ast', 'AST', [Unit('U/L', 1)]);
  static const alt = Quantity('alt', 'ALT', [Unit('U/L', 1)]);
  static const platelets = Quantity('platelets', 'Platelets', [
    Unit('×10⁹/L', 1),
    Unit('/µL', 0.001),
  ]);
}

/// Everyday conversions in Public mode (P10).
const List<Quantity> kPublicConverterQuantities = [
  Q.glucose,
  Q.temperature,
  Q.height,
  Q.weight,
];

/// Tests offered in the D28 lab converter, in display order.
const List<Quantity> kLabConverterTests = [
  Q.creatinine,
  Q.urea,
  Q.uricAcid,
  Q.glucose,
  Q.hba1c,
  Q.cholesterol,
  Q.triglycerides,
  Q.calcium,
  Q.magnesium,
  Q.phosphate,
  Q.bilirubin,
  Q.albumin,
  Q.totalProtein,
  Q.haemoglobin,
  Q.ferritin,
  Q.iron,
  Q.lactate,
  Q.ammonia,
  Q.vitaminD,
  Q.vitaminB12,
  Q.freeT4,
  Q.tsh,
];
