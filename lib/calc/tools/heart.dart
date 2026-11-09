import 'dart:math' as math;

import '../model.dart';
import '../score.dart';
import '../units.dart';

final mapCalc = CalcDefinition(
  id: 'map',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'Standard formula',
  inputs: const [
    NumberInput(
      'sbp',
      'Systolic BP',
      quantity: Q.bp,
      min: 40,
      max: 300,
      decimals: 0,
    ),
    NumberInput(
      'dbp',
      'Diastolic BP',
      quantity: Q.bp,
      min: 20,
      max: 200,
      decimals: 0,
    ),
  ],
  compute: (v) {
    final s = v.number('sbp'), d = v.number('dbp');
    if (s == null || d == null) return null;
    if (d >= s) {
      return const CalcResult(
        headline: '—',
        severity: Severity.caution,
        warnings: ['Diastolic must be lower than systolic.'],
      );
    }
    final map = d + (s - d) / 3;
    return CalcResult(
      headline: fmt(map, 0),
      unit: 'mmHg',
      band: map < 65 ? 'Below 65 mmHg' : 'At or above 65 mmHg',
      severity: map < 65 ? Severity.warning : Severity.normal,
      interpretation: map < 65
          ? 'Below the usual minimum target of 65 mmHg in septic shock (Surviving Sepsis Campaign 2021).'
          : 'At or above the usual minimum target of 65 mmHg in septic shock.',
    );
  },
  formula: 'MAP = DBP + (SBP − DBP) / 3',
  sources: const [
    Source(
      'Evans L et al. Surviving Sepsis Campaign: international guidelines 2021. Crit Care Med 2021;49:e1063-143 (MAP target 65 mmHg).',
      url: 'https://doi.org/10.1097/CCM.0000000000005337',
    ),
  ],
);

// ---- CHA2DS2-VA / CHA2DS2-VASc ----

const _chaItems = <InputSpec>[
  ToggleInput('chf', 'Congestive heart failure (or LV dysfunction)'),
  ToggleInput('htn', 'Hypertension'),
  ChoiceInput(
    'age',
    'Age',
    choices: [
      Choice('Under 65', 0),
      Choice('65–74', 1),
      Choice('75 or older', 2),
    ],
  ),
  ToggleInput('dm', 'Diabetes'),
  ToggleInput('stroke', 'Prior stroke, TIA or thromboembolism', points: 2),
  ToggleInput('vasc', 'Vascular disease (prior MI, PAD, aortic plaque)'),
];

final cha2ds2vaCalc = CalcDefinition(
  id: 'cha2ds2va',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'CHA₂DS₂-VA (ESC 2024); CHA₂DS₂-VASc (ACC/AHA/ACCP/HRS 2023)',
  inputs: const [
    ChoiceInput(
      'version',
      'Score version',
      initial: 0,
      choices: [
        Choice('CHA₂DS₂-VA (ESC 2024)', 0),
        Choice('CHA₂DS₂-VASc (ACC/AHA 2023)', 1),
      ],
    ),
    ..._chaItems,
    ChoiceInput(
      'sex',
      'Sex (used by CHA₂DS₂-VASc only)',
      initial: 0,
      choices: [Choice('Male', 0), Choice('Female', 1)],
    ),
  ],
  compute: (v) {
    final base = scoreTotal(_chaItems, v);
    final version = v.choice('version'), sex = v.choice('sex');
    if (base == null || version == null || sex == null) return null;
    final vasc = version == 1;
    final female = sex == 1;
    final total = base + (vasc && female ? 1 : 0);
    final details = scoreBreakdown(_chaItems, v);
    if (vasc && female) details.add('Sex category (female): +1');

    final String band;
    final String meaning;
    final Severity sev;
    if (!vasc) {
      if (total == 0) {
        band = 'Low risk';
        sev = Severity.normal;
        meaning =
            'ESC 2024: oral anticoagulation is not recommended for stroke prevention on the basis of the score alone.';
      } else if (total == 1) {
        band = 'Intermediate risk';
        sev = Severity.caution;
        meaning = 'ESC 2024: oral anticoagulation should be considered.';
      } else {
        band = 'High risk';
        sev = Severity.warning;
        meaning = 'ESC 2024: oral anticoagulation is recommended.';
      }
    } else {
      final nonSex = total - (female ? 1 : 0);
      if (nonSex == 0) {
        band = 'Low risk';
        sev = Severity.normal;
        meaning =
            'ACC/AHA 2023: anticoagulation not indicated on the score alone (female sex alone does not count).';
      } else if (nonSex == 1) {
        band = 'Intermediate risk';
        sev = Severity.caution;
        meaning =
            'ACC/AHA 2023: anticoagulation is reasonable (score 1 in men, 2 in women).';
      } else {
        band = 'High risk';
        sev = Severity.warning;
        meaning =
            'ACC/AHA 2023: anticoagulation recommended (score 2 or more in men, 3 or more in women).';
      }
    }
    return CalcResult(
      headline: fmt(total.toDouble()),
      unit: 'points',
      band: band,
      severity: sev,
      interpretation: meaning,
      details: details,
    );
  },
  formula:
      'C: heart failure 1 · H: hypertension 1 · A₂: age ≥75 2 · D: diabetes 1 · S₂: stroke/TIA/thromboembolism 2 · '
      'V: vascular disease 1 · A: age 65–74 1. CHA₂DS₂-VASc adds Sc: female sex 1.',
  sources: const [
    Source(
      'Van Gelder IC et al. 2024 ESC Guidelines for the management of atrial fibrillation. Eur Heart J 2024;45:3314-414.',
      url: 'https://doi.org/10.1093/eurheartj/ehae176',
    ),
    Source(
      'Joglar JA et al. 2023 ACC/AHA/ACCP/HRS Guideline for the diagnosis and management of atrial fibrillation. Circulation 2024;149:e1-156.',
      url: 'https://doi.org/10.1161/CIR.0000000000001193',
    ),
    Source(
      'Lip GYH et al. Refining clinical risk stratification for predicting stroke in AF (CHA₂DS₂-VASc). Chest 2010;137:263-72.',
      url: 'https://doi.org/10.1378/chest.09-1584',
    ),
  ],
  notes: const [
    'Not for AF with moderate–severe mitral stenosis or a mechanical valve: these need anticoagulation regardless of score.',
  ],
);

// ---- HAS-BLED ----

const _hasBledItems = <InputSpec>[
  ToggleInput('h', 'Hypertension (uncontrolled, systolic above 160 mmHg)'),
  ToggleInput(
    'renal',
    'Abnormal renal function (dialysis, transplant, Cr ≥2.26 mg/dL / ≥200 µmol/L)',
  ),
  ToggleInput(
    'liver',
    'Abnormal liver function (cirrhosis, or bilirubin >2× normal with AST/ALT/ALP >3× normal)',
  ),
  ToggleInput('stroke', 'Prior stroke'),
  ToggleInput('bleed', 'Prior major bleeding or predisposition to bleeding'),
  ToggleInput(
    'inr',
    'Labile INR (unstable or high INRs, time in range below 60%)',
  ),
  ToggleInput('elderly', 'Elderly (over 65 years)'),
  ToggleInput(
    'drugs',
    'Drugs predisposing to bleeding (antiplatelets, NSAIDs)',
  ),
  ToggleInput('alcohol', 'Alcohol use (8 or more drinks a week)'),
];

final hasBledCalc = CalcDefinition(
  id: 'hasbled',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'HAS-BLED (Pisters 2010)',
  inputs: _hasBledItems,
  compute: (v) => scoreResult(_hasBledItems, v, const [
    ScoreBand(
      2,
      'Low to moderate bleeding risk',
      Severity.caution,
      'Score below 3. Address modifiable bleeding risk factors.',
    ),
    ScoreBand(
      double.infinity,
      'High bleeding risk',
      Severity.warning,
      'Score 3 or more: high bleeding risk. Address modifiable risk factors and review more often. A high score alone is not a reason to withhold anticoagulation (ESC 2024).',
    ),
  ]),
  formula:
      'One point each: H, A (renal), A (liver), S, B, L, E, D (drugs), D (alcohol). Maximum 9.',
  sources: const [
    Source(
      'Pisters R et al. A novel user-friendly score (HAS-BLED) to assess 1-year risk of major bleeding in patients with AF. Chest 2010;138:1093-100.',
      url: 'https://doi.org/10.1378/chest.10-0134',
    ),
  ],
);

// ---- QTc ----

final qtcCalc = CalcDefinition(
  id: 'qtc',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'Bazett 1920; Fridericia 1920',
  inputs: const [
    NumberInput(
      'qt',
      'QT interval',
      quantity: Q.ms,
      min: 200,
      max: 700,
      decimals: 0,
    ),
    NumberInput(
      'hr',
      'Heart rate',
      quantity: Q.heartRate,
      min: 30,
      max: 200,
      decimals: 0,
    ),
    ChoiceInput(
      'sex',
      'Sex',
      initial: 0,
      choices: [Choice('Male', 0), Choice('Female', 1)],
    ),
    ChoiceInput(
      'formula',
      'Formula',
      initial: 0,
      choices: [Choice('Bazett', 0), Choice('Fridericia', 1)],
    ),
  ],
  compute: (v) {
    final qt = v.number('qt'), hr = v.number('hr');
    final sex = v.choice('sex'), f = v.choice('formula');
    if (qt == null || hr == null || sex == null || f == null) return null;
    final rr = 60 / hr;
    final bazett = qt / math.sqrt(rr);
    final fridericia = qt / math.pow(rr, 1 / 3);
    final qtc = f == 0 ? bazett : fridericia;
    final limit = sex == 1 ? 460 : 450;
    final String band;
    final Severity sev;
    if (qtc >= 500) {
      band = '500 ms or more: markedly prolonged';
      sev = Severity.danger;
    } else if (qtc >= limit) {
      band = 'Prolonged (${sex == 1 ? 'female' : 'male'} limit $limit ms)';
      sev = Severity.warning;
    } else {
      band = 'Within normal limits';
      sev = Severity.normal;
    }
    return CalcResult(
      headline: fmt(qtc, 0),
      unit: 'ms',
      band: band,
      severity: sev,
      interpretation: qtc >= 500
          ? 'QTc of 500 ms or more is linked to a higher risk of torsades de pointes. Review QT-prolonging drugs and electrolytes.'
          : 'AHA/ACCF/HRS 2009: QTc 450 ms or more in men and 460 ms or more in women is prolonged.',
      details: [
        'Bazett: ${fmt(bazett, 0)} ms',
        'Fridericia: ${fmt(fridericia, 0)} ms',
        'RR interval: ${fmt(rr, 3)} s',
        if (hr > 100 || hr < 60)
          'Bazett over-corrects at fast heart rates and under-corrects at slow ones; Fridericia is preferred outside 60–100/min.',
      ],
    );
  },
  formula:
      'RR = 60 / heart rate (s)\nBazett: QTc = QT / √RR\nFridericia: QTc = QT / ∛RR',
  sources: const [
    Source(
      'Rautaharju PM et al. AHA/ACCF/HRS recommendations for the standardization and interpretation of the ECG, part IV: ST segment, T and U waves, and the QT interval. Circulation 2009;119:e241-50.',
      url: 'https://doi.org/10.1161/CIRCULATIONAHA.108.191096',
    ),
  ],
);
