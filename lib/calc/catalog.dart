// Release 1 tool list (design doc Section 4). Pure Dart: no Flutter imports.
//
// A tool works once it has a definition in registry.dart; it shows
// "Review pending" until Homi signs it off (design §9).

enum ToolMode { doctor, public }

class ToolCategory {
  const ToolCategory(this.id, this.name);
  final String id;
  final String name;
}

class ToolInfo {
  const ToolInfo({
    required this.id,
    required this.name,
    required this.summary,
    required this.category,
    required this.mode,
    this.aliases = const [],
  });

  final String id;
  final String name;
  final String summary;
  final ToolCategory category;
  final ToolMode mode;
  final List<String> aliases;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        summary.toLowerCase().contains(q) ||
        category.name.toLowerCase().contains(q) ||
        aliases.any((a) => a.toLowerCase().contains(q));
  }
}

abstract final class Categories {
  // Doctor
  static const kidney = ToolCategory('kidney', 'Kidney');
  static const heart = ToolCategory('heart', 'Heart');
  static const clots = ToolCategory('clots', 'Clots (VTE)');
  static const acute = ToolCategory('acute', 'Acute care');
  static const lab = ToolCategory('lab', 'Lab');
  static const body = ToolCategory('body', 'Body size');
  static const mother = ToolCategory('mother', 'Mother & baby');
  static const children = ToolCategory('children', 'Children & fluids');
  static const liver = ToolCategory('liver', 'Liver');
  static const dengue = ToolCategory('dengue', 'Dengue');
  static const diabetes = ToolCategory('diabetes', 'Diabetes');
  static const utilities = ToolCategory('utilities', 'Utilities');
  // Public
  static const weight = ToolCategory('weight', 'Weight');
  static const sugar = ToolCategory('sugar', 'Diabetes & sugar');
  static const bp = ToolCategory('bp', 'Blood pressure');
  static const heartRisk = ToolCategory('heart_risk', 'Heart');
  static const pregnancy = ToolCategory('pregnancy', 'Pregnancy');
  static const dengueSigns = ToolCategory('dengue_signs', 'Dengue');
  static const ramadan = ToolCategory('ramadan', 'Ramadan');
  static const heat = ToolCategory('heat', 'Heat');
  static const converter = ToolCategory('converter', 'Converter');
}

const List<ToolInfo> kTools = [
  // ---- Doctor mode (D1–D28) ----
  ToolInfo(
    id: 'egfr',
    name: 'eGFR (CKD-EPI 2021)',
    summary: 'Race-free eGFR with KDIGO G stage',
    category: Categories.kidney,
    mode: ToolMode.doctor,
    aliases: ['gfr', 'ckd', 'creatinine', 'kdigo'],
  ),
  ToolInfo(
    id: 'cockcroft_gault',
    name: 'Creatinine clearance (Cockcroft-Gault)',
    summary: 'CrCl with actual, ideal or adjusted weight',
    category: Categories.kidney,
    mode: ToolMode.doctor,
    aliases: ['crcl', 'cg', 'renal dosing'],
  ),
  ToolInfo(
    id: 'map',
    name: 'Mean arterial pressure',
    summary: 'MAP from systolic and diastolic BP',
    category: Categories.heart,
    mode: ToolMode.doctor,
    aliases: ['map', 'blood pressure'],
  ),
  ToolInfo(
    id: 'qtc',
    name: 'QTc',
    summary: 'Corrected QT (Bazett, Fridericia)',
    category: Categories.heart,
    mode: ToolMode.doctor,
    aliases: ['qt', 'ecg', 'bazett', 'fridericia'],
  ),
  ToolInfo(
    id: 'cha2ds2va',
    name: 'CHA₂DS₂-VA',
    summary: 'AF stroke risk (CHA₂DS₂-VASc toggle)',
    category: Categories.heart,
    mode: ToolMode.doctor,
    aliases: ['cha2ds2vasc', 'chads', 'af', 'atrial fibrillation', 'stroke'],
  ),
  ToolInfo(
    id: 'hasbled',
    name: 'HAS-BLED',
    summary: 'Bleeding risk on anticoagulation',
    category: Categories.heart,
    mode: ToolMode.doctor,
    aliases: ['bleeding', 'anticoagulation'],
  ),
  ToolInfo(
    id: 'wells_perc',
    name: 'Wells DVT / PE and PERC',
    summary: 'Pre-test probability and PE rule-out',
    category: Categories.clots,
    mode: ToolMode.doctor,
    aliases: ['dvt', 'pe', 'pulmonary embolism', 'perc', 'wells'],
  ),
  ToolInfo(
    id: 'curb65',
    name: 'CURB-65 / CRB-65',
    summary: 'Pneumonia severity',
    category: Categories.acute,
    mode: ToolMode.doctor,
    aliases: ['crb65', 'pneumonia', 'cap'],
  ),
  ToolInfo(
    id: 'news2',
    name: 'NEWS2',
    summary: 'National Early Warning Score 2',
    category: Categories.acute,
    mode: ToolMode.doctor,
    aliases: ['early warning', 'deterioration'],
  ),
  ToolInfo(
    id: 'qsofa',
    name: 'qSOFA',
    summary: 'Sepsis prompt (not for use alone)',
    category: Categories.acute,
    mode: ToolMode.doctor,
    aliases: ['sepsis', 'sofa'],
  ),
  ToolInfo(
    id: 'gcs',
    name: 'Glasgow Coma Scale',
    summary: 'Eye, verbal and motor response',
    category: Categories.acute,
    mode: ToolMode.doctor,
    aliases: ['gcs', 'coma', 'consciousness'],
  ),
  ToolInfo(
    id: 'anion_gap',
    name: 'Anion gap',
    summary: 'With optional albumin correction',
    category: Categories.lab,
    mode: ToolMode.doctor,
    aliases: ['ag', 'acidosis', 'dka'],
  ),
  ToolInfo(
    id: 'corrected_calcium',
    name: 'Corrected calcium',
    summary: 'Calcium corrected for albumin',
    category: Categories.lab,
    mode: ToolMode.doctor,
    aliases: ['calcium', 'albumin'],
  ),
  ToolInfo(
    id: 'corrected_sodium',
    name: 'Corrected sodium',
    summary: 'Sodium corrected for high glucose',
    category: Categories.lab,
    mode: ToolMode.doctor,
    aliases: ['sodium', 'hyperglycaemia', 'pseudohyponatraemia'],
  ),
  ToolInfo(
    id: 'osmolality',
    name: 'Serum osmolality and osmolal gap',
    summary: 'Calculated osmolality and gap',
    category: Categories.lab,
    mode: ToolMode.doctor,
    aliases: ['osm', 'osmolal gap', 'toxic alcohol'],
  ),
  ToolInfo(
    id: 'body_size',
    name: 'BMI, BSA, ideal and adjusted weight',
    summary: 'Body measures for dosing and nutrition',
    category: Categories.body,
    mode: ToolMode.doctor,
    aliases: ['bmi', 'bsa', 'ibw', 'mosteller', 'weight'],
  ),
  ToolInfo(
    id: 'gestational_age',
    name: 'Gestational age and due date',
    summary: 'From LMP or scan date',
    category: Categories.mother,
    mode: ToolMode.doctor,
    aliases: ['edd', 'lmp', 'pregnancy', 'obstetric'],
  ),
  ToolInfo(
    id: 'bishop',
    name: 'Bishop score',
    summary: 'Cervical readiness for induction',
    category: Categories.mother,
    mode: ToolMode.doctor,
    aliases: ['induction', 'labour', 'cervix'],
  ),
  ToolInfo(
    id: 'holliday_segar',
    name: 'Maintenance fluids (Holliday-Segar)',
    summary: 'Hourly and daily maintenance by weight',
    category: Categories.children,
    mode: ToolMode.doctor,
    aliases: ['4-2-1', 'fluids', 'paediatric'],
  ),
  ToolInfo(
    id: 'parkland',
    name: 'Parkland burns fluid',
    summary: 'With Rule of 9s for burn area',
    category: Categories.children,
    mode: ToolMode.doctor,
    aliases: ['burns', 'tbsa', 'rule of nines'],
  ),
  ToolInfo(
    id: 'who_growth',
    name: 'WHO growth z-scores and MUAC',
    summary: 'Weight, height and BMI for age; MUAC bands',
    category: Categories.children,
    mode: ToolMode.doctor,
    aliases: ['stunting', 'wasting', 'malnutrition', 'z-score', 'muac'],
  ),
  ToolInfo(
    id: 'dehydration',
    name: 'Dehydration and ORS plan',
    summary: 'WHO assessment with Plan A/B/C volumes',
    category: Categories.children,
    mode: ToolMode.doctor,
    aliases: ['diarrhoea', 'ors', 'imci'],
  ),
  ToolInfo(
    id: 'apri_fib4',
    name: 'APRI and FIB-4',
    summary: 'Liver fibrosis scores (HCV, HBV, fatty liver)',
    category: Categories.liver,
    mode: ToolMode.doctor,
    aliases: ['fibrosis', 'hepatitis', 'hcv', 'hbv', 'masld'],
  ),
  ToolInfo(
    id: 'dengue',
    name: 'Dengue assessment and fluids',
    summary: 'WHO 2009 classification, warning signs, fluids',
    category: Categories.dengue,
    mode: ToolMode.doctor,
    aliases: ['dengue', 'platelets', 'warning signs'],
  ),
  ToolInfo(
    id: 'ramadan_risk',
    name: 'Ramadan fasting risk (IDF-DAR)',
    summary: 'Pre-fast risk score for people with diabetes',
    category: Categories.diabetes,
    mode: ToolMode.doctor,
    aliases: ['ramadan', 'fasting', 'idf-dar', 'roza'],
  ),
  ToolInfo(
    id: 'a1c_eag',
    name: 'HbA1c ↔ average glucose',
    summary: 'ADAG estimated average glucose',
    category: Categories.diabetes,
    mode: ToolMode.doctor,
    aliases: ['hba1c', 'a1c', 'eag', 'glucose'],
  ),
  ToolInfo(
    id: 'drip_rate',
    name: 'Infusion and drip rate',
    summary: 'mL/h and drops/min',
    category: Categories.utilities,
    mode: ToolMode.doctor,
    aliases: ['infusion', 'drops', 'iv'],
  ),
  ToolInfo(
    id: 'lab_units',
    name: 'Lab unit converter',
    summary: 'Conventional (mg/dL) ↔ SI (mmol/L, µmol/L)',
    category: Categories.utilities,
    mode: ToolMode.doctor,
    aliases: ['si', 'mmol', 'umol', 'mg/dl', 'convert', 'units'],
  ),

  // ---- Public mode (P1–P10) ----
  ToolInfo(
    id: 'p_bmi',
    name: 'BMI and waist check',
    summary: 'Healthy weight for South Asians',
    category: Categories.weight,
    mode: ToolMode.public,
    aliases: ['bmi', 'weight', 'waist', 'obesity'],
  ),
  ToolInfo(
    id: 'p_diabetes_risk',
    name: 'Diabetes risk test',
    summary: 'Four questions, no blood test',
    category: Categories.sugar,
    mode: ToolMode.public,
    aliases: ['diabetes', 'sugar', 'risk'],
  ),
  ToolInfo(
    id: 'p_bp',
    name: 'Blood pressure reading check',
    summary: 'What your home BP reading means',
    category: Categories.bp,
    mode: ToolMode.public,
    aliases: ['bp', 'blood pressure', 'hypertension'],
  ),
  ToolInfo(
    id: 'p_sugar',
    name: 'Blood sugar reading check',
    summary: 'What your glucometer reading means',
    category: Categories.sugar,
    mode: ToolMode.public,
    aliases: ['sugar', 'glucose', 'glucometer', 'hba1c'],
  ),
  ToolInfo(
    id: 'p_heart_risk',
    name: '10-year heart risk',
    summary: 'WHO chart, no lab tests',
    category: Categories.heartRisk,
    mode: ToolMode.public,
    aliases: ['heart', 'cardiac', 'heart attack'],
  ),
  ToolInfo(
    id: 'p_due_date',
    name: 'Pregnancy due date',
    summary: 'Due date and current week',
    category: Categories.pregnancy,
    mode: ToolMode.public,
    aliases: ['pregnancy', 'due date', 'edd'],
  ),
  ToolInfo(
    id: 'p_dengue',
    name: 'Dengue danger signs',
    summary: 'When to go to hospital',
    category: Categories.dengueSigns,
    mode: ToolMode.public,
    aliases: ['dengue', 'fever'],
  ),
  ToolInfo(
    id: 'p_ramadan',
    name: 'Ramadan fasting check',
    summary: 'For people with diabetes',
    category: Categories.ramadan,
    mode: ToolMode.public,
    aliases: ['ramadan', 'fasting', 'roza'],
  ),
  ToolInfo(
    id: 'p_heat',
    name: 'Heat risk check',
    summary: 'Heat index and heat-stroke signs',
    category: Categories.heat,
    mode: ToolMode.public,
    aliases: ['heat', 'heatstroke', 'temperature'],
  ),
  ToolInfo(
    id: 'p_units',
    name: 'Unit converter',
    summary: 'Sugar, temperature, height and weight',
    category: Categories.converter,
    mode: ToolMode.public,
    aliases: ['convert', 'units', 'mmol', 'feet', 'pounds'],
  ),
];

List<ToolInfo> toolsFor(ToolMode mode) =>
    kTools.where((t) => t.mode == mode).toList(growable: false);

ToolInfo? toolById(String id) {
  for (final t in kTools) {
    if (t.id == id) return t;
  }
  return null;
}
