import 'dart:math' as math;

import '../model.dart';
import '../units.dart';

const _sex = ChoiceInput(
  'sex',
  'Sex',
  choices: [Choice('Male', 0), Choice('Female', 1)],
);

/// KDIGO 2012/2024 GFR categories.
({String label, Severity severity, String meaning}) gfrStage(double egfr) {
  if (egfr >= 90) {
    return (
      label: 'G1: normal or high',
      severity: Severity.normal,
      meaning:
          'Normal or high GFR. CKD only if there are other markers of kidney damage (e.g. albuminuria).',
    );
  }
  if (egfr >= 60) {
    return (
      label: 'G2: mildly decreased',
      severity: Severity.info,
      meaning:
          'Mildly decreased. CKD only if there are other markers of kidney damage.',
    );
  }
  if (egfr >= 45) {
    return (
      label: 'G3a: mildly to moderately decreased',
      severity: Severity.caution,
      meaning: 'CKD stage G3a if present for more than 3 months.',
    );
  }
  if (egfr >= 30) {
    return (
      label: 'G3b: moderately to severely decreased',
      severity: Severity.warning,
      meaning: 'CKD stage G3b if present for more than 3 months.',
    );
  }
  if (egfr >= 15) {
    return (
      label: 'G4: severely decreased',
      severity: Severity.warning,
      meaning: 'CKD stage G4 if present for more than 3 months.',
    );
  }
  return (
    label: 'G5: kidney failure',
    severity: Severity.danger,
    meaning: 'Kidney failure range (GFR below 15).',
  );
}

/// CKD-EPI 2021 creatinine equation (race-free). Scr in mg/dL.
double ckdEpi2021(double scr, double age, {required bool female}) {
  final kappa = female ? 0.7 : 0.9;
  final alpha = female ? -0.241 : -0.302;
  final ratio = scr / kappa;
  return 142 *
      math.pow(math.min(ratio, 1), alpha) *
      math.pow(math.max(ratio, 1), -1.200) *
      math.pow(0.9938, age) *
      (female ? 1.012 : 1.0);
}

final egfrCalc = CalcDefinition(
  id: 'egfr',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'CKD-EPI 2021 creatinine (race-free)',
  inputs: const [
    NumberInput(
      'scr',
      'Serum creatinine',
      quantity: Q.creatinine,
      min: 0.1,
      max: 20,
      decimals: 2,
    ),
    NumberInput('age', 'Age', quantity: Q.age, min: 18, max: 110, decimals: 0),
    _sex,
  ],
  compute: (v) {
    final scr = v.number('scr'), age = v.number('age'), sex = v.choice('sex');
    if (scr == null || age == null || sex == null) return null;
    final e = ckdEpi2021(scr, age, female: sex == 1);
    final stage = gfrStage(e);
    return CalcResult(
      headline: fmt(e, 0),
      unit: 'mL/min/1.73 m²',
      band: stage.label,
      severity: stage.severity,
      interpretation: stage.meaning,
      details: const ['Adults (18+) with stable creatinine only.'],
    );
  },
  formula:
      'eGFR = 142 × min(Scr/κ, 1)^α × max(Scr/κ, 1)^−1.200 × 0.9938^age × 1.012 [if female]\n'
      'κ = 0.7 (female), 0.9 (male); α = −0.241 (female), −0.302 (male); Scr in mg/dL.',
  sources: const [
    Source(
      'Inker LA et al. New creatinine- and cystatin C-based equations to estimate GFR without race. N Engl J Med 2021;385:1737-49.',
      url: 'https://doi.org/10.1056/NEJMoa2102953',
    ),
    Source(
      'KDIGO 2024 Clinical Practice Guideline for the Evaluation and Management of CKD (GFR categories).',
      url: 'https://kdigo.org/guidelines/ckd-evaluation-and-management/',
    ),
  ],
  notes: const [
    'Not valid in acute kidney injury, pregnancy, extremes of muscle mass or under 18.',
  ],
);

final cockcroftGaultCalc = CalcDefinition(
  id: 'cockcroft_gault',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'Cockcroft-Gault 1976',
  inputs: const [
    NumberInput('age', 'Age', quantity: Q.age, min: 18, max: 110, decimals: 0),
    NumberInput('weight', 'Weight', quantity: Q.weight, min: 20, max: 300),
    NumberInput(
      'height',
      'Height (for ideal / adjusted weight)',
      quantity: Q.height,
      min: 120,
      max: 230,
      optional: true,
    ),
    NumberInput(
      'scr',
      'Serum creatinine',
      quantity: Q.creatinine,
      min: 0.1,
      max: 20,
      decimals: 2,
    ),
    _sex,
  ],
  compute: (v) {
    final age = v.number('age'), wt = v.number('weight'), scr = v.number('scr');
    final sex = v.choice('sex'), ht = v.number('height');
    if (age == null || wt == null || scr == null || sex == null) return null;
    final female = sex == 1;
    double cg(double w) => (140 - age) * w / (72 * scr) * (female ? 0.85 : 1);
    final details = <String>[];
    if (ht != null) {
      final ibw = idealBodyWeight(ht, female: female);
      final abw = adjustedBodyWeight(wt, ibw);
      details
        ..add(
          'With ideal body weight (${fmt(ibw)} kg): ${fmt(cg(ibw), 0)} mL/min',
        )
        ..add(
          'With adjusted body weight (${fmt(abw)} kg): ${fmt(cg(abw), 0)} mL/min',
        );
    }
    final crcl = cg(wt);
    return CalcResult(
      headline: fmt(crcl, 0),
      unit: 'mL/min (actual weight)',
      band: crcl >= 60
          ? 'CrCl 60 or more'
          : crcl >= 30
          ? 'CrCl 30–59'
          : crcl >= 15
          ? 'CrCl 15–29'
          : 'CrCl below 15',
      severity: crcl >= 60
          ? Severity.normal
          : crcl >= 30
          ? Severity.caution
          : crcl >= 15
          ? Severity.warning
          : Severity.danger,
      interpretation:
          'Estimated creatinine clearance, used mainly for drug dose adjustment. Check the drug\'s label for its own thresholds and which weight to use.',
      details: details,
    );
  },
  formula:
      'CrCl = (140 − age) × weight (kg) / (72 × Scr mg/dL) × 0.85 [if female]\n'
      'Ideal body weight (Devine): 50 kg (male) or 45.5 kg (female) + 2.3 kg per inch over 5 ft.\n'
      'Adjusted body weight = IBW + 0.4 × (actual − IBW).',
  sources: const [
    Source(
      'Cockcroft DW, Gault MH. Prediction of creatinine clearance from serum creatinine. Nephron 1976;16:31-41.',
      url: 'https://doi.org/10.1159/000180580',
    ),
    Source(
      'Devine BJ. Gentamicin therapy. Drug Intell Clin Pharm 1974;8:650-5 (ideal body weight).',
    ),
  ],
  notes: const [
    'Not valid when creatinine is changing (e.g. acute kidney injury).',
  ],
);

/// Devine ideal body weight (kg) from height in cm.
double idealBodyWeight(double heightCm, {required bool female}) {
  final inchesOver60 = heightCm / 2.54 - 60;
  return (female ? 45.5 : 50) + 2.3 * inchesOver60;
}

double adjustedBodyWeight(double actual, double ibw) =>
    actual > ibw ? ibw + 0.4 * (actual - ibw) : actual;
