// Public mode (P1–P9). Plain-language results, one next step, red flags
// (design §4.2). No medicine doses.

import 'dart:math' as math;

import '../model.dart';
import '../units.dart';
import 'body.dart' show bmi, bmiBand;

const _inCm = (id: 'hunit', value: 0);
const _inFeet = (id: 'hunit', value: 1);

const _heightInputs = <InputSpec>[
  ChoiceInput(
    'hunit',
    'Height in',
    initial: 1,
    choices: [Choice('cm', 0), Choice('feet and inches', 1)],
  ),
  NumberInput(
    'height',
    'Height',
    quantity: Q.height,
    min: 100,
    max: 230,
    showWhen: _inCm,
  ),
  NumberInput(
    'feet',
    'Feet',
    quantity: Q.feet,
    min: 3,
    max: 7,
    decimals: 0,
    showWhen: _inFeet,
  ),
  NumberInput(
    'inches',
    'Inches',
    quantity: Q.inches,
    min: 0,
    max: 11.9,
    optional: true,
    showWhen: _inFeet,
  ),
];

double? _heightCm(Inputs v) {
  if (v.choice('hunit') == 0) return v.number('height');
  final ft = v.number('feet');
  if (ft == null) return null;
  return (ft * 12 + (v.number('inches') ?? 0)) * 2.54;
}

// ---- P1 BMI and waist ----

final publicBmiCalc = CalcDefinition(
  id: 'p_bmi',
  version: 'WHO 2004 Asian BMI cut-offs; IDF 2006 South Asian waist cut-offs',
  inputs: const [
    NumberInput('weight', 'Weight', quantity: Q.weight, min: 25, max: 250),
    ..._heightInputs,
    ChoiceInput(
      'sex',
      'You are',
      initial: 0,
      choices: [Choice('Man', 0), Choice('Woman', 1)],
    ),
    NumberInput(
      'waist',
      'Waist, at the belly button',
      quantity: Q.length,
      min: 40,
      max: 200,
      optional: true,
    ),
  ],
  compute: (v) {
    final kg = v.number('weight'), cm = _heightCm(v), sex = v.choice('sex');
    if (kg == null || cm == null || sex == null) return null;
    if (cm < 100 || cm > 230) return null;
    final b = bmi(kg, cm);
    final band = bmiBand(b, asian: true);
    final lowHealthy = 18.5 * math.pow(cm / 100, 2);
    final highHealthy = 22.9 * math.pow(cm / 100, 2);
    final waist = v.number('waist');
    final details = <String>[
      'Healthy weight for your height (Asian range): ${fmt(lowHealthy.toDouble(), 0)}–${fmt(highHealthy.toDouble(), 0)} kg.',
    ];
    if (waist != null) {
      final limit = sex == 1 ? 80 : 90;
      details.add(
        waist >= limit
            ? 'Waist ${fmt(waist, 0)} cm is at or above $limit cm: extra fat around the belly raises the risk of diabetes and heart disease.'
            : 'Waist ${fmt(waist, 0)} cm is below $limit cm: good.',
      );
      final ratio = waist / cm;
      details.add(
        'Waist-to-height ratio ${fmt(ratio, 2)}${ratio >= 0.5 ? ': above 0.5, keep your waist to less than half your height.' : ': below 0.5, good.'}',
      );
    }
    final message = switch (band.label) {
      'Underweight' =>
        'You are below a healthy weight. Eat regular balanced meals and see a doctor if you are losing weight without trying.',
      'Normal (Asian cut-offs)' =>
        'Your weight is in the healthy range. Keep active and eat a balanced diet.',
      'Overweight / at risk (Asian cut-offs)' =>
        'You are a little above a healthy weight for South Asians. Losing even 3–5 kg lowers your risk of diabetes and heart disease. Ask your doctor about a sugar test.',
      _ =>
        'Your weight is high for your height. This raises the risk of diabetes, high blood pressure and heart disease. Talk to a doctor about a check-up and a sugar test.',
    };
    return CalcResult(
      headline: fmt(b),
      unit: 'BMI',
      band: band.label.replaceAll(' (Asian cut-offs)', ''),
      severity: band.severity,
      interpretation: message,
      details: details,
    );
  },
  formula:
      'BMI = weight (kg) ÷ height (m)². South Asian cut-offs: healthy 18.5–22.9, overweight 23–24.9, obese 25 or more.\n'
      'Waist: risk at 90 cm or more for men, 80 cm or more for women (South Asians).',
  sources: const [
    Source(
      'WHO Expert Consultation. Appropriate body-mass index for Asian populations. Lancet 2004;363:157-63.',
      url: 'https://doi.org/10.1016/S0140-6736(03)15268-3',
    ),
    Source(
      'International Diabetes Federation. The IDF consensus worldwide definition of the metabolic syndrome, 2006 (ethnic waist cut-offs).',
      url: 'https://idf.org/media/uploads/2023/05/attachments-30.pdf',
    ),
  ],
  notes: const ['Not for children, pregnant women or bodybuilders.'],
);

// ---- P2 Diabetes risk (IDRS) ----

final publicDiabetesRiskCalc = CalcDefinition(
  id: 'p_diabetes_risk',
  version: 'Indian Diabetes Risk Score (Mohan 2005)',
  inputs: const [
    ChoiceInput(
      'age',
      'Your age',
      choices: [
        Choice('Under 35', 0),
        Choice('35–49', 20),
        Choice('50 or older', 30),
      ],
    ),
    ChoiceInput(
      'waist',
      'Waist size at the belly button',
      choices: [
        Choice('Men under 90 cm (35.4 in) / women under 80 cm (31.5 in)', 0),
        Choice('Men 90–99 cm / women 80–89 cm', 10),
        Choice(
          'Men 100 cm (39.4 in) or more / women 90 cm (35.4 in) or more',
          20,
        ),
      ],
    ),
    ChoiceInput(
      'activity',
      'Physical activity',
      choices: [
        Choice('Regular hard exercise or hard physical work', 0),
        Choice('Regular moderate exercise or moderate work', 10),
        Choice('Light exercise or light work only', 20),
        Choice('No exercise, mostly sitting', 30),
      ],
    ),
    ChoiceInput(
      'family',
      'Parents with diabetes',
      choices: [
        Choice('Neither', 0),
        Choice('One parent', 10),
        Choice('Both parents', 20),
      ],
    ),
  ],
  compute: (v) {
    final a = v.choice('age'),
        w = v.choice('waist'),
        p = v.choice('activity'),
        f = v.choice('family');
    if (a == null || w == null || p == null || f == null) return null;
    final total = a + w + p + f;
    final (band, sev, msg) = total >= 60
        ? (
            'High risk',
            Severity.danger,
            'You have a high chance of having or getting diabetes. Get a blood sugar test (fasting sugar or HbA1c) soon.',
          )
        : total >= 30
        ? (
            'Medium risk',
            Severity.caution,
            'You have some risk. Get a blood sugar test, be more active and keep your waist down.',
          )
        : (
            'Low risk',
            Severity.normal,
            'Your risk is low. Stay active and check again every few years.',
          );
    return CalcResult(
      headline: fmt(total.toDouble(), 0),
      unit: 'out of 100',
      band: band,
      severity: sev,
      interpretation: msg,
      details: const [
        'This is a screening test, not a diagnosis. Only a blood test can show diabetes.',
      ],
    );
  },
  formula:
      'Age 0/20/30 + waist 0/10/20 + activity 0/10/20/30 + family history 0/10/20. 60 or more high, 30–50 medium, under 30 low.',
  sources: const [
    Source(
      'Mohan V et al. A simplified Indian Diabetes Risk Score for screening for undiagnosed diabetic subjects. J Assoc Physicians India 2005;53:759-63.',
    ),
  ],
  notes: const [
    'Developed in India for South Asians. Not yet validated in Pakistan.',
  ],
);

// ---- P3 Blood pressure reading ----

const _bpSymptoms = <InputSpec>[
  ToggleInput('s_chest', 'Chest pain', points: 0),
  ToggleInput('s_breath', 'Short of breath', points: 0),
  ToggleInput(
    's_weak',
    'Weakness, numbness, face drooping or trouble speaking',
    points: 0,
  ),
  ToggleInput('s_vision', 'Sudden change in vision', points: 0),
  ToggleInput('s_head', 'Severe headache or confusion', points: 0),
];

final publicBpCalc = CalcDefinition(
  id: 'p_bp',
  version: 'AHA/ACC 2025 high blood pressure guideline categories',
  inputs: const [
    NumberInput(
      'sbp',
      'Top number (systolic)',
      quantity: Q.bp,
      min: 60,
      max: 300,
      decimals: 0,
    ),
    NumberInput(
      'dbp',
      'Bottom number (diastolic)',
      quantity: Q.bp,
      min: 30,
      max: 200,
      decimals: 0,
    ),
    ..._bpSymptoms,
  ],
  compute: (v) {
    final s = v.number('sbp'), d = v.number('dbp');
    if (s == null || d == null) return null;
    if (d >= s) {
      return const CalcResult(
        headline: '—',
        severity: Severity.caution,
        warnings: ['The bottom number must be lower than the top number.'],
      );
    }
    final symptoms = _bpSymptoms.any((i) => v.flag(i.id));
    final reading = '${fmt(s, 0)}/${fmt(d, 0)}';
    if (s > 180 || d > 120) {
      return CalcResult(
        headline: reading,
        unit: 'mmHg',
        band: 'Severely high',
        severity: Severity.danger,
        interpretation: symptoms
            ? 'Very high blood pressure with these symptoms can be an emergency (stroke, heart attack).'
            : 'Sit quietly for 5 minutes and check again. If it is still this high, contact your doctor today.',
        emergency: symptoms
            ? 'Very high blood pressure with chest pain, breathlessness, weakness, vision change or severe headache. Call 1122 or go to the nearest hospital now.'
            : null,
      );
    }
    if (s < 90 || d < 60) {
      return CalcResult(
        headline: reading,
        unit: 'mmHg',
        band: 'Low',
        severity: Severity.caution,
        interpretation: symptoms
            ? 'Low blood pressure with these symptoms needs a doctor today.'
            : 'Low blood pressure is often normal if you feel well. See a doctor if you feel dizzy, faint or unwell.',
      );
    }
    final (band, sev, msg) = s >= 140 || d >= 90
        ? (
            'High: stage 2',
            Severity.warning,
            'Your blood pressure is high. See a doctor soon: it usually needs treatment.',
          )
        : s >= 130 || d >= 80
        ? (
            'High: stage 1',
            Severity.caution,
            'Your blood pressure is raised. Check it again on different days and see a doctor.',
          )
        : s >= 120
        ? (
            'Elevated',
            Severity.caution,
            'A little above normal. Less salt, more walking and a healthy weight can bring it down.',
          )
        : (
            'Normal',
            Severity.normal,
            'Your blood pressure is normal. Check it at least once a year.',
          );
    return CalcResult(
      headline: reading,
      unit: 'mmHg',
      band: band,
      severity: sev,
      interpretation: msg,
      emergency: symptoms
          ? 'Chest pain, breathlessness, weakness, face drooping, trouble speaking or a sudden change in vision can mean a heart attack or stroke whatever your blood pressure. Call 1122.'
          : null,
      details: const [
        'One reading is not enough: take two readings a minute apart, morning and evening, for a few days.',
        'Use an upper-arm cuff, sit with your back supported and arm at heart level.',
      ],
    );
  },
  formula:
      'Normal below 120/80; elevated 120–129 and below 80; stage 1 130–139 or 80–89; stage 2 140/90 or more; severe above 180 or above 120.',
  sources: const [
    Source(
      '2025 AHA/ACC/AANP/AAPA/ABC/ACCP/ACPM/AGS/AMA/ASPC/NMA/PCNA/SGIM Guideline for the prevention, detection, evaluation and management of high blood pressure in adults. Hypertension 2025.',
      url: 'https://doi.org/10.1161/HYP.0000000000000249',
    ),
  ],
);

// ---- P4 Blood sugar reading ----

const _sugarSymptoms = <InputSpec>[
  ToggleInput('s_drowsy', 'Very drowsy, confused or hard to wake', points: 0),
  ToggleInput('s_vomit', 'Vomiting or deep fast breathing', points: 0),
];

final publicSugarCalc = CalcDefinition(
  id: 'p_sugar',
  version: 'ADA Standards of Care 2026 (diagnosis and hypoglycaemia levels)',
  inputs: const [
    NumberInput(
      'glu',
      'Glucometer reading',
      quantity: Q.glucose,
      min: 10,
      max: 700,
      decimals: 0,
    ),
    ChoiceInput(
      'when',
      'When did you check?',
      initial: 0,
      choices: [
        Choice('Fasting (nothing to eat for 8 hours)', 0),
        Choice('2 hours after a meal', 1),
        Choice('Any other time', 2),
      ],
    ),
    ..._sugarSymptoms,
  ],
  compute: (v) {
    final g = v.number('glu'), when = v.choice('when');
    if (g == null || when == null) return null;
    final symptoms = _sugarSymptoms.any((i) => v.flag(i.id));
    if (g < 70) {
      final veryLow = g < 54;
      return CalcResult(
        headline: fmt(g, 0),
        unit: 'mg/dL',
        band: veryLow ? 'Very low sugar' : 'Low sugar',
        severity: veryLow ? Severity.danger : Severity.warning,
        interpretation:
            'Take 15 g of fast sugar now (half a glass of juice, 3 teaspoons of sugar in water, or 3–4 glucose tablets). Check again after 15 minutes and repeat if still below 70.',
        emergency: symptoms
            ? 'Low sugar with drowsiness or confusion. If the person cannot swallow safely, do not give food or drink by mouth. Call 1122.'
            : null,
        details: const ['Tell your doctor about any low reading.'],
      );
    }
    if (g >= 300 && symptoms) {
      return CalcResult(
        headline: fmt(g, 0),
        unit: 'mg/dL',
        band: 'Very high sugar',
        severity: Severity.danger,
        interpretation:
            'Very high sugar with these symptoms can be dangerous (DKA).',
        emergency:
            'Very high sugar with vomiting, deep breathing or drowsiness. Call 1122 or go to hospital now.',
      );
    }
    final (band, sev, msg) = switch (when) {
      0 =>
        g >= 126
            ? (
                'High (diabetes range if repeated)',
                Severity.warning,
                'A fasting reading of 126 or more on a lab test, done twice, means diabetes. See a doctor for a lab test.',
              )
            : g >= 100
            ? (
                'Raised (prediabetes range)',
                Severity.caution,
                'Above normal. See a doctor for a lab test; more activity and less sugar can bring it down.',
              )
            : (
                'Normal fasting sugar',
                Severity.normal,
                'Your fasting sugar is normal.',
              ),
      1 =>
        g >= 200
            ? (
                'High (diabetes range if repeated)',
                Severity.warning,
                'High after a meal. See a doctor for a lab test.',
              )
            : g >= 140
            ? (
                'Raised',
                Severity.caution,
                'Above normal after a meal. See a doctor for a lab test.',
              )
            : (
                'Normal after a meal',
                Severity.normal,
                'Your sugar after a meal is normal.',
              ),
      _ =>
        g >= 200
            ? (
                'High',
                Severity.warning,
                'A random sugar of 200 or more with thirst and passing a lot of urine suggests diabetes. See a doctor soon.',
              )
            : g >= 140
            ? (
                'Raised',
                Severity.caution,
                'Higher than ideal. A fasting test gives a clearer answer.',
              )
            : (
                'Normal',
                Severity.normal,
                'Your reading is in the normal range.',
              ),
    };
    return CalcResult(
      headline: fmt(g, 0),
      unit: 'mg/dL',
      band: band,
      severity: sev,
      interpretation: msg,
      details: [
        '= ${fmt(g / 18.016, 1)} mmol/L',
        if (g >= 300)
          'Above 300: if you have diabetes, follow your doctor\'s sick-day plan and check for ketones if you can.',
        'A home meter cannot diagnose diabetes; only a lab test can.',
      ],
    );
  },
  formula:
      'Fasting: normal below 100, prediabetes 100–125, diabetes range 126 or more.\nAfter a meal (2 h): normal below 140, 140–199 raised, 200 or more high.\nLow below 70; very low below 54 mg/dL.',
  sources: const [
    Source(
      'American Diabetes Association. Standards of Care in Diabetes—2026: sections 2 (diagnosis) and 6 (glycaemic goals and hypoglycaemia).',
      url: 'https://diabetesjournals.org/care/issue/49/Supplement_1',
    ),
  ],
);

// ---- P6 Pregnancy due date ----

final publicDueDateCalc = CalcDefinition(
  id: 'p_due_date',
  version: 'Naegele rule (LMP + 280 days)',
  inputs: const [DateInput('lmp', 'First day of your last period')],
  compute: (v) {
    final d = v.date('lmp');
    if (d == null) return null;
    final lmp = dateOnly(d);
    final today = dateOnly(v.date('today') ?? DateTime.now());
    final edd = DateTime(lmp.year, lmp.month, lmp.day + 280);
    final days = daysBetween(lmp, today);
    if (days < 0) {
      return const CalcResult(
        headline: '—',
        severity: Severity.caution,
        warnings: ['This date is in the future.'],
      );
    }
    return CalcResult(
      headline: fmtDate(edd),
      unit: 'due date',
      band: 'You are ${days ~/ 7} weeks ${days % 7} days pregnant',
      severity: days > 42 * 7 ? Severity.warning : Severity.info,
      interpretation: days > 42 * 7
          ? 'You are past 42 weeks. See your doctor or midwife today.'
          : 'Book antenatal check-ups early: at least 8 contacts during pregnancy are recommended.',
      details: const [
        'Go to hospital at once for: bleeding, severe headache or blurred vision, fits, high fever, severe belly pain, the baby moving less, or water breaking.',
        'A scan in the first 3 months gives the most accurate due date.',
      ],
    );
  },
  formula: 'Due date = first day of last period + 280 days (40 weeks).',
  sources: const [
    Source(
      'WHO recommendations on antenatal care for a positive pregnancy experience, 2016 (8 contacts; danger signs).',
      url: 'https://www.who.int/publications/i/item/9789241549912',
    ),
    Source(
      'ACOG Committee Opinion No. 700: Methods for estimating the due date, 2017.',
      url: 'https://doi.org/10.1097/AOG.0000000000002046',
    ),
  ],
);

// ---- P9 Heat risk ----

/// US National Weather Service heat index (°F).
double heatIndexF(double t, double rh) {
  final simple = 0.5 * (t + 61 + (t - 68) * 1.2 + rh * 0.094);
  if ((simple + t) / 2 < 80) return simple;
  var hi =
      -42.379 +
      2.04901523 * t +
      10.14333127 * rh -
      0.22475541 * t * rh -
      0.00683783 * t * t -
      0.05481717 * rh * rh +
      0.00122874 * t * t * rh +
      0.00085282 * t * rh * rh -
      0.00000199 * t * t * rh * rh;
  if (rh < 13 && t >= 80 && t <= 112) {
    hi -= (13 - rh) / 4 * math.sqrt((17 - (t - 95).abs()) / 17);
  } else if (rh > 85 && t >= 80 && t <= 87) {
    hi += (rh - 85) / 10 * ((87 - t) / 5);
  }
  return hi;
}

const _heatSymptoms = <InputSpec>[
  ToggleInput(
    's_confused',
    'Someone is confused, fainting or having a fit',
    points: 0,
  ),
  ToggleInput(
    's_hot',
    'Hot dry skin and very high body temperature',
    points: 0,
  ),
];

final publicHeatCalc = CalcDefinition(
  id: 'p_heat',
  version: 'US National Weather Service heat index (Rothfusz 1990)',
  inputs: const [
    NumberInput(
      'temp',
      'Air temperature',
      quantity: Q.temperature,
      min: 20,
      max: 55,
    ),
    NumberInput(
      'rh',
      'Humidity',
      quantity: Q.humidity,
      min: 1,
      max: 100,
      decimals: 0,
    ),
    ..._heatSymptoms,
  ],
  compute: (v) {
    final c = v.number('temp'), rh = v.number('rh');
    if (c == null || rh == null) return null;
    final hiF = heatIndexF(c * 9 / 5 + 32, rh);
    final hiC = (hiF - 32) * 5 / 9;
    final symptoms = _heatSymptoms.any((i) => v.flag(i.id));
    final (band, sev, msg) = hiF >= 125
        ? (
            'Extreme danger',
            Severity.danger,
            'Heat stroke is very likely. Stay indoors in the coolest place, drink water often and check on elderly people and children.',
          )
        : hiF >= 103
        ? (
            'Danger',
            Severity.danger,
            'Heat cramps and heat exhaustion are likely; heat stroke is possible. Avoid the sun from 11 am to 4 pm and drink water often.',
          )
        : hiF >= 90
        ? (
            'Extreme caution',
            Severity.warning,
            'Heat exhaustion is possible with long exposure or work. Rest in shade and drink water.',
          )
        : hiF >= 80
        ? (
            'Caution',
            Severity.caution,
            'Tiredness is possible with long exposure. Drink water.',
          )
        : ('Low heat risk', Severity.normal, 'No special heat risk.');
    return CalcResult(
      headline: fmt(hiC, 0),
      unit: '°C feels like',
      band: band,
      severity: sev,
      interpretation: msg,
      emergency: symptoms
          ? 'These are signs of heat stroke. Call 1122. Move the person to shade, remove extra clothes and cool them with water and fanning while you wait.'
          : null,
      details: [
        'Feels like ${fmt(hiF, 0)} °F',
        'Heat index is for shade; direct sun can add up to 8 °C.',
      ],
    );
  },
  formula:
      'NWS heat index: Rothfusz regression on temperature (°F) and relative humidity, with NWS adjustments. Bands: 80–90 °F caution, 90–103 extreme caution, 103–124 danger, 125+ extreme danger.',
  sources: const [
    Source(
      'US National Weather Service. The heat index equation.',
      url: 'https://www.wpc.ncep.noaa.gov/html/heatindex_equation.shtml',
    ),
    Source(
      'WHO. Heat and health fact sheet, 2024.',
      url:
          'https://www.who.int/news-room/fact-sheets/detail/climate-change-heat-and-health',
    ),
  ],
);

// ---- P7 Dengue danger signs ----

const _dengueDanger = <InputSpec>[
  ToggleInput('d_belly', 'Severe or constant belly pain', points: 0),
  ToggleInput('d_vomit', 'Vomiting again and again', points: 0),
  ToggleInput(
    'd_bleed',
    'Bleeding from gums or nose, or blood in vomit or stool',
    points: 0,
  ),
  ToggleInput('d_tired', 'Very sleepy, restless or confused', points: 0),
  ToggleInput('d_cold', 'Cold, clammy hands and feet, or fainting', points: 0),
  ToggleInput('d_breath', 'Difficulty breathing', points: 0),
  ToggleInput('d_urine', 'Little or no urine for 6 hours', points: 0),
];

final publicDengueCalc = CalcDefinition(
  id: 'p_dengue',
  version: 'WHO 2009 dengue warning signs; NIH Pakistan dengue advisory 2025',
  inputs: const [
    ToggleInput('fever', 'Fever now, or in the last few days', points: 0),
    ..._dengueDanger,
  ],
  compute: (v) {
    final danger = _dengueDanger.where((i) => v.flag(i.id)).toList();
    if (danger.isNotEmpty) {
      return CalcResult(
        headline: 'Danger signs',
        band: '${danger.length} danger sign${danger.length == 1 ? '' : 's'}',
        severity: Severity.danger,
        interpretation:
            'These can be signs of severe dengue. Go to hospital now.',
        emergency:
            'Dengue danger signs: go to the nearest hospital now, or call 1122.',
        details: [for (final d in danger) d.label],
      );
    }
    return CalcResult(
      headline: 'No danger signs now',
      band: v.flag('fever') ? 'Keep watching' : 'No fever',
      severity: Severity.caution,
      interpretation:
          'Rest and drink plenty of fluids (ORS, water, juice, soup). For fever use paracetamol only: do not take ibuprofen, aspirin or other painkillers like them. See a doctor for a blood test.',
      details: const [
        'The most dangerous time is when the fever goes down, around day 3 to 7. Check for danger signs every day.',
        'Prevent mosquito bites: nets, repellent, and no standing water near the house.',
      ],
    );
  },
  formula:
      'Any danger sign → go to hospital now. Based on the WHO 2009 warning signs, in plain words.',
  sources: const [
    Source(
      'WHO/TDR. Dengue: guidelines for diagnosis, treatment, prevention and control, 2009 (warning signs).',
      url: 'https://iris.who.int/handle/10665/44188',
    ),
    Source(
      'NIH/NHSRC Pakistan. Advisory for prevention and control of dengue fever, March 2025.',
      url: 'https://www.nih.org.pk/guidelines',
    ),
  ],
);

// ---- P8 Ramadan check for people with diabetes ----

const _ramadanHigh = <InputSpec>[
  ToggleInput('r_preg', 'Pregnant', points: 0),
  ToggleInput(
    'r_hypo',
    'Had a severe low sugar, or cannot feel low sugars coming',
    points: 0,
  ),
  ToggleInput(
    'r_dka',
    'In hospital for very high sugar (DKA) in the last 3 months',
    points: 0,
  ),
  ToggleInput('r_kidney', 'Serious kidney disease or on dialysis', points: 0),
  ToggleInput(
    'r_heart',
    'Heart disease or stroke that is not stable',
    points: 0,
  ),
  ToggleInput('r_frail', 'Very frail or memory problems', points: 0),
];

const _ramadanMore = <InputSpec>[
  ToggleInput('r_insulin', 'Uses insulin', points: 0),
  ToggleInput('r_type1', 'Has type 1 diabetes', points: 0),
  ToggleInput('r_lows', 'Gets low sugars sometimes', points: 0),
  ToggleInput('r_work', 'Does hard physical work', points: 0),
  ToggleInput(
    'r_tablets',
    'Takes glibenclamide or other sugar tablets that can cause lows',
    points: 0,
  ),
];

final publicRamadanCalc = CalcDefinition(
  id: 'p_ramadan',
  version: 'Plain-language checklist based on IDF-DAR risk items (2021, 2026)',
  inputs: const [..._ramadanHigh, ..._ramadanMore],
  compute: (v) {
    final high = _ramadanHigh.where((i) => v.flag(i.id)).toList();
    final more = _ramadanMore.where((i) => v.flag(i.id)).toList();
    if (high.isNotEmpty) {
      return CalcResult(
        headline: 'Fasting may be unsafe',
        band: 'High-risk sign present',
        severity: Severity.danger,
        interpretation:
            'Fasting is probably not safe for you. Islam allows people who are ill not to fast. Talk to your doctor before Ramadan.',
        details: [for (final h in high) h.label],
      );
    }
    if (more.isNotEmpty) {
      return CalcResult(
        headline: 'Talk to your doctor first',
        band: 'Some risk',
        severity: Severity.caution,
        interpretation:
            'You may be able to fast, but your medicines and timings may need changes. See your doctor 6–8 weeks before Ramadan.',
        details: [
          for (final m in more) m.label,
          'Break the fast at once if sugar is below 70 mg/dL or above 300 mg/dL, or if you feel unwell.',
        ],
      );
    }
    return const CalcResult(
      headline: 'Lower risk',
      band: 'No risk signs ticked',
      severity: Severity.normal,
      interpretation:
          'Fasting is often possible, but still see your doctor 6–8 weeks before Ramadan to plan medicines and sugar checks.',
      details: [
        'Break the fast at once if sugar is below 70 mg/dL or above 300 mg/dL, or if you feel unwell.',
      ],
    );
  },
  formula:
      'Not a score. Any high-risk item → fasting may be unsafe; other risk items → talk to your doctor first.',
  sources: const [
    Source(
      'IDF-DAR. Diabetes and Ramadan: Practical Guidelines 2021 (pre-Ramadan assessment 6–8 weeks before; when to break the fast).',
      url:
          'https://idf.org/news-and-resources/resources/diabetes-and-ramadan-practical-guidelines-2021/',
    ),
    Source(
      'Afandi B et al. The 2026 update of the IDF-DAR risk calculator. J Diabetes Endocr Pract 2025.',
      url:
          'https://media.idf.org/media/uploads/2026/02/IDF-DAR-Risk-Calculator-Update-2026.pdf',
    ),
  ],
  notes: const [
    'For people with diabetes. This checklist does not replace a doctor\'s assessment.',
  ],
);
