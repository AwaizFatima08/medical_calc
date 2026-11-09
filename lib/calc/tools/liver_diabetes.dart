import 'dart:math' as math;

import '../model.dart';
import '../units.dart';

// ---- APRI and FIB-4 ----

final apriFib4Calc = CalcDefinition(
  id: 'apri_fib4',
  version:
      'FIB-4 (Sterling 2006; MASLD cut-offs AASLD 2023); APRI (Wai 2003; WHO 2014/2024)',
  inputs: const [
    ChoiceInput(
      'context',
      'Liver disease',
      initial: 0,
      choices: [
        Choice('Hepatitis C or B', 0),
        Choice('Fatty liver (MASLD)', 1),
      ],
    ),
    NumberInput('age', 'Age', quantity: Q.age, min: 18, max: 100, decimals: 0),
    NumberInput('ast', 'AST', quantity: Q.ast, min: 1, max: 5000, decimals: 0),
    NumberInput('alt', 'ALT', quantity: Q.alt, min: 1, max: 5000, decimals: 0),
    NumberInput(
      'uln',
      'AST upper limit of normal (from your lab report)',
      quantity: Q.ast,
      min: 10,
      max: 100,
      decimals: 0,
    ),
    NumberInput(
      'plt',
      'Platelets',
      quantity: Q.platelets,
      min: 5,
      max: 1500,
      decimals: 0,
    ),
  ],
  compute: (v) {
    final ctx = v.choice('context'),
        age = v.number('age'),
        ast = v.number('ast');
    final alt = v.number('alt'), uln = v.number('uln'), plt = v.number('plt');
    if ([ctx, age, ast, alt, uln, plt].contains(null)) return null;
    final fib4 = age! * ast! / (plt! * math.sqrt(alt!));
    final apri = (ast / uln!) / plt * 100;
    final masld = ctx == 1;
    final low = masld ? (age >= 65 ? 2.0 : 1.3) : 1.45;
    final high = masld ? 2.67 : 3.25;
    final (band, sev, meaning) = fib4 < low
        ? (
            'Low risk of advanced fibrosis (below ${fmt(low, 2)})',
            Severity.normal,
            'Advanced fibrosis unlikely.',
          )
        : fib4 > high
        ? (
            'High risk of advanced fibrosis (above ${fmt(high, 2)})',
            Severity.danger,
            'Advanced fibrosis likely. Refer for specialist assessment (e.g. elastography).',
          )
        : (
            'Indeterminate (${fmt(low, 2)}–${fmt(high, 2)})',
            Severity.caution,
            'Needs a second test such as transient elastography (FibroScan).',
          );
    final apriLine = apri > 2
        ? 'APRI ${fmt(apri, 2)}: above 2, cirrhosis likely (WHO).'
        : apri > 1.5
        ? 'APRI ${fmt(apri, 2)}: above 1.5, significant fibrosis likely.'
        : apri < 0.5
        ? 'APRI ${fmt(apri, 2)}: below 0.5, significant fibrosis unlikely.'
        : 'APRI ${fmt(apri, 2)}: 0.5–1.5, indeterminate.';
    return CalcResult(
      headline: fmt(fib4, 2),
      unit: 'FIB-4',
      band: band,
      severity: sev,
      interpretation: meaning,
      details: [
        apriLine,
        if (masld && age < 35) 'FIB-4 is less accurate under 35 years.',
      ],
    );
  },
  formula:
      'FIB-4 = age × AST / (platelets ×10⁹/L × √ALT)\nAPRI = (AST / AST upper limit of normal) / platelets ×10⁹/L × 100\n'
      'FIB-4 cut-offs: hepatitis C/B 1.45 and 3.25; MASLD 1.3 (2.0 if 65+) and 2.67. APRI: 0.5, 1.5, 2.0.',
  sources: const [
    Source(
      'Sterling RK et al. Development of a simple noninvasive index to predict significant fibrosis in HIV/HCV coinfection. Hepatology 2006;43:1317-25.',
      url: 'https://doi.org/10.1002/hep.21178',
    ),
    Source(
      'Wai CT et al. A simple noninvasive index can predict both significant fibrosis and cirrhosis in chronic hepatitis C. Hepatology 2003;38:518-26.',
      url: 'https://doi.org/10.1053/jhep.2003.50346',
    ),
    Source(
      'Rinella ME et al. AASLD Practice Guidance on the clinical assessment and management of NAFLD/MASLD. Hepatology 2023;77:1797-835.',
      url: 'https://doi.org/10.1097/HEP.0000000000000323',
    ),
    Source(
      'WHO. Guidelines for the care and treatment of persons diagnosed with chronic hepatitis C virus infection (2018); hepatitis B (2024).',
      url: 'https://www.who.int/publications/i/item/9789240090903',
    ),
  ],
);

// ---- HbA1c ↔ estimated average glucose ----

final a1cEagCalc = CalcDefinition(
  id: 'a1c_eag',
  version: 'ADAG (Nathan 2008); ADA Standards of Care 2026 for diagnosis bands',
  inputs: const [
    NumberInput('a1c', 'HbA1c', quantity: Q.hba1c, min: 3, max: 20),
  ],
  compute: (v) {
    final a1c = v.number('a1c');
    if (a1c == null) return null;
    final eag = 28.7 * a1c - 46.7;
    final (band, sev) = a1c >= 6.5
        ? ('Diabetes range (6.5% or more)', Severity.warning)
        : a1c >= 5.7
        ? ('Prediabetes range (5.7–6.4%)', Severity.caution)
        : ('Normal range (below 5.7%)', Severity.normal);
    return CalcResult(
      headline: fmt(eag, 0),
      unit: 'mg/dL average glucose',
      band: band,
      severity: sev,
      interpretation:
          'A diagnosis of diabetes needs a confirmed lab result. HbA1c can mislead in anaemia, haemoglobin variants (e.g. thalassaemia trait), pregnancy and kidney disease.',
      details: [
        '= ${fmt(eag / 18.016, 1)} mmol/L',
        'HbA1c ${fmt(a1c, 1)}% = ${fmt(10.929 * (a1c - 2.15), 0)} mmol/mol (IFCC)',
      ],
    );
  },
  formula:
      'eAG (mg/dL) = 28.7 × HbA1c (%) − 46.7\neAG (mmol/L) = 1.59 × HbA1c (%) − 2.59\nIFCC (mmol/mol) = 10.929 × (HbA1c % − 2.15)',
  sources: const [
    Source(
      'Nathan DM et al. Translating the A1C assay into estimated average glucose values. Diabetes Care 2008;31:1473-8.',
      url: 'https://doi.org/10.2337/dc08-0545',
    ),
    Source(
      'American Diabetes Association. Standards of Care in Diabetes—2026, section 2: Diagnosis and classification.',
      url: 'https://diabetesjournals.org/care/issue/49/Supplement_1',
    ),
  ],
);

// ---- Infusion / drip rate ----

final dripRateCalc = CalcDefinition(
  id: 'drip_rate',
  version: 'Standard infusion arithmetic',
  inputs: const [
    NumberInput(
      'volume',
      'Volume to infuse',
      quantity: Q.volume,
      min: 1,
      max: 10000,
      decimals: 0,
    ),
    NumberInput('time', 'Over', quantity: Q.hours, min: 1 / 60, max: 72),
    ChoiceInput(
      'factor',
      'Giving set (drop factor)',
      initial: 1,
      choices: [
        Choice('10 drops/mL', 10),
        Choice('15 drops/mL', 15),
        Choice('20 drops/mL (standard adult set)', 20),
        Choice('60 drops/mL (micro-drip / burette)', 60),
      ],
    ),
  ],
  compute: (v) {
    final vol = v.number('volume'),
        h = v.number('time'),
        f = v.choice('factor');
    if (vol == null || h == null || f == null) return null;
    final mlPerH = vol / h;
    final dropsPerMin = mlPerH * f / 60;
    return CalcResult(
      headline: fmt(mlPerH, 1),
      unit: 'mL/h',
      band: '${fmt(dropsPerMin, 0)} drops/min',
      severity: Severity.info,
      interpretation:
          'Pump rate ${fmt(mlPerH, 1)} mL/h, or ${fmt(dropsPerMin, 0)} drops per minute with a ${fmt(f.toDouble(), 0)} drops/mL set.',
      details: ['One drop every ${fmt(60 / dropsPerMin, 1)} seconds'],
    );
  },
  formula:
      'mL/h = volume (mL) / time (h)\ndrops/min = mL/h × drop factor (drops/mL) / 60',
  sources: const [
    Source(
      'Standard nursing infusion calculation (e.g. Royal Marsden Manual of Clinical Nursing Procedures, 10th ed.).',
    ),
  ],
  notes: const [
    'Arithmetic only: the volume and time must come from the prescription.',
  ],
);
