import 'dart:math' as math;

import '../model.dart';
import '../units.dart';
import 'kidney.dart' show adjustedBodyWeight, idealBodyWeight;

double bmi(double kg, double cm) => kg / math.pow(cm / 100, 2);

/// Mosteller BSA in m².
double bsaMosteller(double kg, double cm) => math.sqrt(kg * cm / 3600);

/// BMI bands. [asian]: WHO Western Pacific Region 2000 / WHO expert
/// consultation 2004 cut-offs for Asians (overweight from 23, obese from 25).
/// The obese cut-off (25 vs 27.5) is open item 14.9 for Homi's review.
({String label, Severity severity}) bmiBand(double b, {required bool asian}) {
  if (b < 18.5) return (label: 'Underweight', severity: Severity.caution);
  if (asian) {
    if (b < 23) {
      return (label: 'Normal (Asian cut-offs)', severity: Severity.normal);
    }
    if (b < 25) {
      return (
        label: 'Overweight / at risk (Asian cut-offs)',
        severity: Severity.caution,
      );
    }
    if (b < 30) {
      return (
        label: 'Obese class I (Asian cut-offs)',
        severity: Severity.warning,
      );
    }
    return (
      label: 'Obese class II (Asian cut-offs)',
      severity: Severity.danger,
    );
  }
  if (b < 25) return (label: 'Normal', severity: Severity.normal);
  if (b < 30) return (label: 'Overweight', severity: Severity.caution);
  if (b < 35) return (label: 'Obese class I', severity: Severity.warning);
  if (b < 40) return (label: 'Obese class II', severity: Severity.danger);
  return (label: 'Obese class III', severity: Severity.danger);
}

final bodySizeCalc = CalcDefinition(
  id: 'body_size',
  version:
      'BMI (WHO; Asian cut-offs WHO 2004), BSA Mosteller 1987, IBW Devine 1974',
  inputs: const [
    NumberInput('weight', 'Weight', quantity: Q.weight, min: 2, max: 300),
    NumberInput('height', 'Height', quantity: Q.height, min: 45, max: 230),
    ChoiceInput(
      'sex',
      'Sex (for ideal weight)',
      initial: 0,
      choices: [Choice('Male', 0), Choice('Female', 1)],
    ),
    ChoiceInput(
      'standard',
      'BMI cut-offs',
      initial: 0,
      followsBmiSetting: true,
      choices: [Choice('Asian', 0), Choice('International (WHO)', 1)],
    ),
  ],
  compute: (v) {
    final kg = v.number('weight'), cm = v.number('height');
    final sex = v.choice('sex'), std = v.choice('standard');
    if (kg == null || cm == null || sex == null || std == null) return null;
    final b = bmi(kg, cm);
    final band = bmiBand(b, asian: std == 0);
    final details = ['BSA (Mosteller): ${fmt(bsaMosteller(kg, cm), 2)} m²'];
    if (cm >= 152.4) {
      final ibw = idealBodyWeight(cm, female: sex == 1);
      details
        ..add('Ideal body weight (Devine): ${fmt(ibw)} kg')
        ..add('Adjusted body weight: ${fmt(adjustedBodyWeight(kg, ibw))} kg');
    } else {
      details.add(
        'Ideal body weight (Devine) is not defined below 5 ft (152 cm).',
      );
    }
    return CalcResult(
      headline: fmt(b),
      unit: 'kg/m²',
      band: band.label,
      severity: band.severity,
      interpretation: std == 0
          ? 'Asian cut-offs: normal 18.5–22.9, overweight 23–24.9, obese 25 or more. Risk of diabetes and heart disease rises at lower BMI in South Asians.'
          : 'WHO: normal 18.5–24.9, overweight 25–29.9, obese 30 or more.',
      details: details,
    );
  },
  formula:
      'BMI = weight (kg) / height (m)²\n'
      'BSA (Mosteller) = √(height cm × weight kg / 3600)\n'
      'IBW (Devine) = 50 (male) or 45.5 (female) + 2.3 × (height in inches − 60)\n'
      'Adjusted BW = IBW + 0.4 × (actual − IBW)',
  sources: const [
    Source(
      'WHO Expert Consultation. Appropriate body-mass index for Asian populations. Lancet 2004;363:157-63.',
      url: 'https://doi.org/10.1016/S0140-6736(03)15268-3',
    ),
    Source(
      'WHO Western Pacific Region. The Asia-Pacific perspective: redefining obesity and its treatment. 2000.',
    ),
    Source(
      'Mosteller RD. Simplified calculation of body-surface area. N Engl J Med 1987;317:1098.',
      url: 'https://doi.org/10.1056/NEJM198710223171717',
    ),
    Source(
      'Devine BJ. Gentamicin therapy. Drug Intell Clin Pharm 1974;8:650-5.',
    ),
  ],
  notes: const [
    'BMI bands are for adults; not for pregnancy, children or very muscular people.',
  ],
);
