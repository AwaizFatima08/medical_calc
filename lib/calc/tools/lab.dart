import '../model.dart';
import '../units.dart';

final anionGapCalc = CalcDefinition(
  id: 'anion_gap',
  version: 'Anion gap; albumin correction (Figge 1998)',
  inputs: const [
    NumberInput(
      'na',
      'Sodium',
      quantity: Q.electrolyte,
      min: 90,
      max: 200,
      decimals: 0,
    ),
    NumberInput(
      'cl',
      'Chloride',
      quantity: Q.electrolyte,
      min: 50,
      max: 160,
      decimals: 0,
    ),
    NumberInput(
      'hco3',
      'Bicarbonate',
      quantity: Q.electrolyte,
      min: 1,
      max: 60,
      decimals: 0,
    ),
    NumberInput(
      'alb',
      'Albumin (for correction)',
      quantity: Q.albumin,
      min: 0.5,
      max: 7,
      optional: true,
    ),
  ],
  compute: (v) {
    final na = v.number('na'), cl = v.number('cl'), hco3 = v.number('hco3');
    final alb = v.number('alb');
    if (na == null || cl == null || hco3 == null) return null;
    final ag = na - (cl + hco3);
    final corrected = alb == null ? null : ag + 2.5 * (4.0 - alb);
    final judged = corrected ?? ag;
    return CalcResult(
      headline: fmt(ag, 0),
      unit: 'mmol/L',
      band: judged > 12
          ? 'Raised (above 12)'
          : judged < 3
          ? 'Low (below 3)'
          : 'Within usual range (3–12)',
      severity: judged > 12
          ? Severity.warning
          : judged < 3
          ? Severity.caution
          : Severity.normal,
      interpretation:
          'Usual reference range without potassium is about 3–12 mmol/L, but it depends on the lab\'s analyser. A raised gap suggests unmeasured anions (e.g. ketones, lactate, toxins).',
      details: [
        if (corrected != null)
          'Albumin-corrected anion gap: ${fmt(corrected, 1)} mmol/L',
        if (corrected == null)
          'Add albumin to correct for low albumin (each 1 g/dL fall hides about 2.5 mmol/L of gap).',
      ],
    );
  },
  formula:
      'Anion gap = Na − (Cl + HCO₃)\nCorrected AG = AG + 2.5 × (4.0 − albumin g/dL)',
  sources: const [
    Source(
      'Kraut JA, Madias NE. Serum anion gap: its uses and limitations in clinical medicine. Clin J Am Soc Nephrol 2007;2:162-74.',
      url: 'https://doi.org/10.2215/CJN.03020906',
    ),
    Source(
      'Figge J et al. Anion gap and hypoalbuminemia. Crit Care Med 1998;26:1807-10.',
      url: 'https://doi.org/10.1097/00003246-199811000-00019',
    ),
  ],
);

final correctedCalciumCalc = CalcDefinition(
  id: 'corrected_calcium',
  version: 'Payne 1973 (0.8 mg/dL per g/dL albumin below 4)',
  inputs: const [
    NumberInput(
      'ca',
      'Total calcium',
      quantity: Q.calcium,
      min: 2,
      max: 20,
      decimals: 2,
    ),
    NumberInput('alb', 'Albumin', quantity: Q.albumin, min: 0.5, max: 7),
  ],
  compute: (v) {
    final ca = v.number('ca'), alb = v.number('alb');
    if (ca == null || alb == null) return null;
    final c = ca + 0.8 * (4.0 - alb);
    return CalcResult(
      headline: fmt(c, 1),
      unit: 'mg/dL',
      band: c < 8.5
          ? 'Low (below 8.5 mg/dL)'
          : c > 10.5
          ? 'High (above 10.5 mg/dL)'
          : 'Within usual range (8.5–10.5)',
      severity: c < 8.5 || c > 10.5 ? Severity.warning : Severity.normal,
      interpretation:
          'Usual adult range about 8.5–10.5 mg/dL (2.12–2.62 mmol/L); use your lab\'s range. Ionised calcium is more reliable when albumin is very abnormal or in critical illness.',
      details: ['= ${fmt(c / 4.008, 2)} mmol/L'],
    );
  },
  formula: 'Corrected Ca (mg/dL) = measured Ca + 0.8 × (4.0 − albumin g/dL)',
  sources: const [
    Source(
      'Payne RB et al. Interpretation of serum calcium in patients with abnormal serum proteins. BMJ 1973;4:643-6.',
      url: 'https://doi.org/10.1136/bmj.4.5893.643',
    ),
  ],
);

final correctedSodiumCalc = CalcDefinition(
  id: 'corrected_sodium',
  version: 'Katz 1973 (1.6) and Hillier 1999 (2.4)',
  inputs: const [
    NumberInput(
      'na',
      'Measured sodium',
      quantity: Q.electrolyte,
      min: 90,
      max: 200,
      decimals: 0,
    ),
    NumberInput(
      'glu',
      'Glucose',
      quantity: Q.glucose,
      min: 20,
      max: 3000,
      decimals: 0,
    ),
  ],
  compute: (v) {
    final na = v.number('na'), glu = v.number('glu');
    if (na == null || glu == null) return null;
    final excess = glu > 100 ? (glu - 100) / 100 : 0.0;
    final katz = na + 1.6 * excess;
    final hillier = na + 2.4 * excess;
    return CalcResult(
      headline: fmt(hillier, 0),
      unit: 'mmol/L (Hillier)',
      band: hillier < 135
          ? 'Low (below 135)'
          : hillier > 145
          ? 'High (above 145)'
          : 'Within usual range (135–145)',
      severity: hillier < 135 || hillier > 145
          ? Severity.warning
          : Severity.normal,
      interpretation:
          'Sodium expected once the high glucose is corrected. Used in hyperglycaemic states such as DKA and HHS.',
      details: [
        'Katz (1.6 per 100 mg/dL): ${fmt(katz, 0)} mmol/L',
        'Hillier (2.4 per 100 mg/dL): ${fmt(hillier, 0)} mmol/L',
      ],
    );
  },
  formula:
      'Corrected Na = measured Na + k × (glucose mg/dL − 100) / 100, with k = 2.4 (Hillier) or 1.6 (Katz).',
  sources: const [
    Source(
      'Hillier TA et al. Hyponatremia: evaluating the correction factor for hyperglycemia. Am J Med 1999;106:399-403.',
      url: 'https://doi.org/10.1016/S0002-9343(99)00055-8',
    ),
    Source(
      'Katz MA. Hyperglycemia-induced hyponatremia: calculation of expected serum sodium depression. N Engl J Med 1973;289:843-4.',
      url: 'https://doi.org/10.1056/NEJM197310182891607',
    ),
  ],
);

final osmolalityCalc = CalcDefinition(
  id: 'osmolality',
  version: 'Calculated osmolality 2Na + glucose/18 + BUN/2.8',
  inputs: const [
    NumberInput(
      'na',
      'Sodium',
      quantity: Q.electrolyte,
      min: 90,
      max: 200,
      decimals: 0,
    ),
    NumberInput(
      'glu',
      'Glucose',
      quantity: Q.glucose,
      min: 20,
      max: 3000,
      decimals: 0,
    ),
    NumberInput('bun', 'Urea / BUN', quantity: Q.urea, min: 1, max: 200),
    NumberInput(
      'measured',
      'Measured osmolality (for the gap)',
      quantity: Q.osmolality,
      min: 200,
      max: 500,
      decimals: 0,
      optional: true,
    ),
  ],
  compute: (v) {
    final na = v.number('na'), glu = v.number('glu'), bun = v.number('bun');
    final measured = v.number('measured');
    if (na == null || glu == null || bun == null) return null;
    final calc = 2 * na + glu / 18 + bun / 2.8;
    final gap = measured == null ? null : measured - calc;
    return CalcResult(
      headline: fmt(calc, 0),
      unit: 'mOsm/kg',
      band: calc < 275
          ? 'Low (below 275)'
          : calc > 295
          ? 'High (above 295)'
          : 'Within usual range (275–295)',
      severity: calc < 275 || calc > 295 ? Severity.warning : Severity.normal,
      interpretation: gap == null
          ? 'Add measured osmolality to get the osmolal gap.'
          : gap > 10
          ? 'Osmolal gap above 10: consider unmeasured osmoles such as toxic alcohols (methanol, ethylene glycol), ethanol or mannitol.'
          : 'Osmolal gap 10 or less.',
      details: [if (gap != null) 'Osmolal gap: ${fmt(gap, 0)} mOsm/kg'],
    );
  },
  formula:
      'Calculated osmolality = 2 × Na + glucose (mg/dL) / 18 + BUN (mg/dL) / 2.8\nOsmolal gap = measured − calculated',
  sources: const [
    Source(
      'Kraut JA, Kurtz I. Toxic alcohol ingestions: clinical features, diagnosis, and management. Clin J Am Soc Nephrol 2008;3:208-25.',
      url: 'https://doi.org/10.2215/CJN.03220807',
    ),
  ],
);
