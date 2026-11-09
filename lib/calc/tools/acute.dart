import '../model.dart';
import '../score.dart';
import '../units.dart';

// ---- CURB-65 / CRB-65 ----

final curb65Calc = CalcDefinition(
  id: 'curb65',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'CURB-65 / CRB-65 (Lim 2003; BTS 2009, NICE NG250 2025)',
  inputs: const [
    ToggleInput(
      'confusion',
      'New confusion (AMT 8 or less, or new disorientation)',
    ),
    NumberInput(
      'urea',
      'Urea / BUN (leave empty for CRB-65)',
      quantity: Q.urea,
      min: 1,
      max: 200,
      optional: true,
    ),
    NumberInput(
      'rr',
      'Respiratory rate',
      quantity: Q.respRate,
      min: 4,
      max: 80,
      decimals: 0,
    ),
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
    NumberInput('age', 'Age', quantity: Q.age, min: 16, max: 110, decimals: 0),
  ],
  compute: (v) {
    final rr = v.number('rr'), sbp = v.number('sbp'), dbp = v.number('dbp');
    final age = v.number('age'), bun = v.number('urea');
    if (rr == null || sbp == null || dbp == null || age == null) return null;
    final details = <String>[];
    var score = 0;
    if (v.flag('confusion')) {
      score++;
      details.add('Confusion: +1');
    }
    // Urea above 7 mmol/L = BUN above 19.6 mg/dL.
    if (bun != null && bun > 19.6) {
      score++;
      details.add('Urea above 7 mmol/L (BUN above 19.6 mg/dL): +1');
    }
    if (rr >= 30) {
      score++;
      details.add('Respiratory rate 30 or more: +1');
    }
    if (sbp < 90 || dbp <= 60) {
      score++;
      details.add('Systolic below 90 or diastolic 60 or less: +1');
    }
    if (age >= 65) {
      score++;
      details.add('Age 65 or older: +1');
    }
    if (bun == null) {
      final (band, sev, meaning) = switch (score) {
        0 => (
          'Low risk (CRB-65 0)',
          Severity.normal,
          'Mortality below 1%. Usually suitable for home treatment.',
        ),
        1 || 2 => (
          'Intermediate risk (CRB-65 1–2)',
          Severity.caution,
          'Mortality 1–10%. Consider hospital assessment.',
        ),
        _ => (
          'High risk (CRB-65 3–4)',
          Severity.danger,
          'Mortality above 10%. Urgent hospital admission.',
        ),
      };
      return CalcResult(
        headline: '$score',
        unit: 'CRB-65 points',
        band: band,
        severity: sev,
        interpretation: meaning,
        details: details,
      );
    }
    final (band, sev, meaning) = switch (score) {
      0 || 1 => (
        'Low severity (CURB-65 0–1)',
        Severity.normal,
        '30-day mortality below 3%. Consider home treatment.',
      ),
      2 => (
        'Moderate severity (CURB-65 2)',
        Severity.caution,
        '30-day mortality 3–15%. Consider hospital treatment.',
      ),
      _ => (
        'High severity (CURB-65 3–5)',
        Severity.danger,
        '30-day mortality above 15%. Hospital treatment; assess for ICU if 4–5.',
      ),
    };
    return CalcResult(
      headline: '$score',
      unit: 'CURB-65 points',
      band: band,
      severity: sev,
      interpretation: meaning,
      details: details,
    );
  },
  formula:
      'One point each: Confusion; Urea >7 mmol/L (BUN >19.6 mg/dL, urea >42 mg/dL); Respiratory rate ≥30; '
      'BP systolic <90 or diastolic ≤60; age ≥65. CRB-65 leaves out urea.',
  sources: const [
    Source(
      'Lim WS et al. Defining community acquired pneumonia severity on presentation to hospital. Thorax 2003;58:377-82.',
      url: 'https://doi.org/10.1136/thorax.58.5.377',
    ),
    Source(
      'NICE NG250. Pneumonia: diagnosis and management (2025).',
      url: 'https://www.nice.org.uk/guidance/ng250',
    ),
  ],
  notes: const [
    'For community-acquired pneumonia in adults. Clinical judgement overrides the score.',
  ],
);

// ---- qSOFA ----

const _qsofaItems = <InputSpec>[
  ToggleInput('rr', 'Respiratory rate 22/min or more'),
  ToggleInput('mental', 'Altered mentation (GCS below 15)'),
  ToggleInput('sbp', 'Systolic BP 100 mmHg or less'),
];

final qsofaCalc = CalcDefinition(
  id: 'qsofa',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'qSOFA (Sepsis-3, Seymour 2016)',
  inputs: _qsofaItems,
  compute: (v) => scoreResult(_qsofaItems, v, const [
    ScoreBand(
      1,
      'qSOFA negative',
      Severity.caution,
      'Fewer than 2 criteria. This does not rule out sepsis.',
    ),
    ScoreBand(
      double.infinity,
      'qSOFA positive',
      Severity.danger,
      '2 or more criteria: higher risk of poor outcome if infection is present. Assess for organ dysfunction and sepsis.',
    ),
  ]),
  formula:
      'One point each: RR ≥22/min, altered mentation, systolic BP ≤100 mmHg. 2 or more = positive.',
  sources: const [
    Source(
      'Seymour CW et al. Assessment of clinical criteria for sepsis (Sepsis-3). JAMA 2016;315:762-74.',
      url: 'https://doi.org/10.1001/jama.2016.0288',
    ),
    Source(
      'Evans L et al. Surviving Sepsis Campaign 2021: recommends against qSOFA as a single screening tool compared with SIRS, NEWS or MEWS.',
      url: 'https://doi.org/10.1097/CCM.0000000000005337',
    ),
  ],
  notes: const [
    'Surviving Sepsis Campaign 2021 recommends against using qSOFA alone to screen for sepsis. Use NEWS2 as well.',
  ],
);

// ---- GCS ----

const _gcsItems = <InputSpec>[
  ChoiceInput(
    'e',
    'Eye opening',
    choices: [
      Choice('4 Spontaneous', 4),
      Choice('3 To sound', 3),
      Choice('2 To pressure', 2),
      Choice('1 None', 1),
    ],
  ),
  ChoiceInput(
    'v',
    'Verbal response',
    choices: [
      Choice('5 Orientated', 5),
      Choice('4 Confused', 4),
      Choice('3 Words', 3),
      Choice('2 Sounds', 2),
      Choice('1 None', 1),
    ],
  ),
  ChoiceInput(
    'm',
    'Motor response',
    choices: [
      Choice('6 Obeys commands', 6),
      Choice('5 Localising', 5),
      Choice('4 Normal flexion', 4),
      Choice('3 Abnormal flexion', 3),
      Choice('2 Extension', 2),
      Choice('1 None', 1),
    ],
  ),
];

final gcsCalc = CalcDefinition(
  id: 'gcs',
  reviewedOn: '9 Nov 2026 (Homi)',
  version:
      'Glasgow Coma Scale (Teasdale & Jennett 1974; 2014 structured approach)',
  inputs: _gcsItems,
  compute: (v) {
    final e = v.choice('e'), vb = v.choice('v'), m = v.choice('m');
    if (e == null || vb == null || m == null) return null;
    final total = e + vb + m;
    final (band, sev) = total <= 8
        ? ('Severe (8 or less)', Severity.danger)
        : total <= 12
        ? ('Moderate (9–12)', Severity.warning)
        : ('Mild (13–15)', total == 15 ? Severity.normal : Severity.caution);
    return CalcResult(
      headline: '$total',
      unit: '/ 15',
      band: band,
      severity: sev,
      interpretation: total <= 8
          ? 'GCS 8 or less: consider airway protection.'
          : 'Severity bands as used for head injury.',
      details: [
        'E${fmt(e.toDouble())} V${fmt(vb.toDouble())} M${fmt(m.toDouble())}',
      ],
    );
  },
  formula:
      'GCS = Eye (1–4) + Verbal (1–5) + Motor (1–6). Report as E V M as well as the total.',
  sources: const [
    Source(
      'Teasdale G, Jennett B. Assessment of coma and impaired consciousness. Lancet 1974;2:81-4.',
      url: 'https://doi.org/10.1016/S0140-6736(74)91639-0',
    ),
    Source(
      'Glasgow Coma Scale: structured approach and permissions. University of Glasgow / Sir Graham Teasdale.',
      url: 'https://www.glasgowcomascale.org',
    ),
  ],
  notes: const [
    '© Sir Graham Teasdale, University of Glasgow. If a component cannot be tested (e.g. intubated), record it as "NT" and do not total.',
  ],
);

// ---- NEWS2 ----

int _rrPts(double rr) => rr <= 8
    ? 3
    : rr <= 11
    ? 1
    : rr <= 20
    ? 0
    : rr <= 24
    ? 2
    : 3;
int _spo2Scale1(double s) => s <= 91
    ? 3
    : s <= 93
    ? 2
    : s <= 95
    ? 1
    : 0;
int _spo2Scale2(double s, bool onO2) {
  if (s <= 83) return 3;
  if (s <= 85) return 2;
  if (s <= 87) return 1;
  if (s <= 92 || !onO2) return 0;
  if (s <= 94) return 1;
  if (s <= 96) return 2;
  return 3;
}

int _sbpPts(double s) => s <= 90
    ? 3
    : s <= 100
    ? 2
    : s <= 110
    ? 1
    : s <= 219
    ? 0
    : 3;
int _pulsePts(double p) => p <= 40
    ? 3
    : p <= 50
    ? 1
    : p <= 90
    ? 0
    : p <= 110
    ? 1
    : p <= 130
    ? 2
    : 3;
int _tempPts(double t) => t <= 35.0
    ? 3
    : t <= 36.0
    ? 1
    : t <= 38.0
    ? 0
    : t <= 39.0
    ? 1
    : 2;

final news2Calc = CalcDefinition(
  id: 'news2',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'NEWS2 (Royal College of Physicians 2017)',
  inputs: const [
    NumberInput(
      'rr',
      'Respiratory rate',
      quantity: Q.respRate,
      min: 2,
      max: 80,
      decimals: 0,
    ),
    NumberInput(
      'spo2',
      'SpO₂',
      quantity: Q.percent,
      min: 50,
      max: 100,
      decimals: 0,
    ),
    ChoiceInput(
      'scale',
      'SpO₂ scale',
      initial: 0,
      choices: [
        Choice('Scale 1 (usual)', 0),
        Choice('Scale 2 (target 88–92%, e.g. hypercapnic COPD)', 1),
      ],
    ),
    ChoiceInput(
      'o2',
      'Breathing',
      initial: 0,
      choices: [Choice('Room air', 0), Choice('Supplemental oxygen', 2)],
    ),
    NumberInput(
      'sbp',
      'Systolic BP',
      quantity: Q.bp,
      min: 40,
      max: 300,
      decimals: 0,
    ),
    NumberInput(
      'pulse',
      'Pulse',
      quantity: Q.heartRate,
      min: 20,
      max: 250,
      decimals: 0,
    ),
    ChoiceInput(
      'acvpu',
      'Consciousness',
      initial: 0,
      choices: [
        Choice('Alert', 0),
        Choice('New confusion, or responds to Voice, Pain, or Unresponsive', 3),
      ],
    ),
    NumberInput(
      'temp',
      'Temperature',
      quantity: Q.temperature,
      min: 30,
      max: 44,
    ),
  ],
  compute: (v) {
    final rr = v.number('rr'), spo2 = v.number('spo2'), sbp = v.number('sbp');
    final pulse = v.number('pulse'), temp = v.number('temp');
    final scale = v.choice('scale'),
        o2 = v.choice('o2'),
        acvpu = v.choice('acvpu');
    if ([rr, spo2, sbp, pulse, temp, scale, o2, acvpu].contains(null)) {
      return null;
    }
    final onO2 = o2 == 2;
    final parts = <String, int>{
      'Respiration rate': _rrPts(rr!),
      'SpO₂ (scale ${scale == 0 ? 1 : 2})': scale == 0
          ? _spo2Scale1(spo2!)
          : _spo2Scale2(spo2!, onO2),
      'Air or oxygen': onO2 ? 2 : 0,
      'Systolic BP': _sbpPts(sbp!),
      'Pulse': _pulsePts(pulse!),
      'Consciousness': acvpu!.toInt(),
      'Temperature': _tempPts(temp!),
    };
    final total = parts.values.fold(0, (a, b) => a + b);
    final anyThree = parts.values.any((p) => p == 3);
    final (band, sev, meaning) = total >= 7
        ? (
            'High clinical risk (7 or more)',
            Severity.danger,
            'Emergency response: urgent assessment by a team with critical-care competencies; usually transfer to a higher level of care.',
          )
        : total >= 5
        ? (
            'Medium clinical risk (5–6)',
            Severity.warning,
            'Key threshold for urgent response: urgent review by a clinician competent in acute illness.',
          )
        : anyThree
        ? (
            'Low–medium clinical risk (a single parameter scored 3)',
            Severity.caution,
            'Urgent ward-based response: prompt review by a clinician.',
          )
        : total == 0
        ? (
            'Low clinical risk (0)',
            Severity.normal,
            'Continue routine monitoring (minimum 12-hourly).',
          )
        : (
            'Low clinical risk (1–4)',
            Severity.caution,
            'Ward-based response: assessment by a registered nurse; monitoring at least 4–6-hourly.',
          );
    return CalcResult(
      headline: '$total',
      unit: 'points',
      band: band,
      severity: sev,
      interpretation: meaning,
      details: [
        for (final e in parts.entries)
          if (e.value > 0) '${e.key}: +${e.value}',
      ],
    );
  },
  formula:
      'Seven parameters scored 0–3: respiration rate, SpO₂ (scale 1 or 2), air or oxygen (oxygen = 2), systolic BP, '
      'pulse, consciousness (new confusion/V/P/U = 3), temperature. Total 0–20.',
  sources: const [
    Source(
      'Royal College of Physicians. National Early Warning Score (NEWS) 2: standardising the assessment of acute-illness severity in the NHS. London: RCP, 2017.',
      url:
          'https://www.rcp.ac.uk/improving-care/resources/national-early-warning-score-news-2/',
    ),
  ],
  notes: const [
    'Not validated in children or pregnancy. Use SpO₂ scale 2 only when a clinician has set a target of 88–92%.',
  ],
);
