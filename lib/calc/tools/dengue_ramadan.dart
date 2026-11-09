import '../model.dart';
import '../score.dart';
import '../units.dart';
import 'mother_child.dart' show hollidaySegarDaily;

// ---- D24 Dengue: WHO 2009 classification and WHO 2009/2012 fluids ----

const _warningSigns = <InputSpec>[
  ToggleInput(
    points: 0,
    'w_abdo',
    heading: 'Warning signs (WHO 2009)',
    'Abdominal pain or tenderness',
  ),
  ToggleInput(points: 0, 'w_vomit', 'Persistent vomiting'),
  ToggleInput(
    points: 0,
    'w_fluid',
    'Clinical fluid accumulation (ascites, pleural effusion)',
  ),
  ToggleInput(points: 0, 'w_mucosal', 'Mucosal bleeding'),
  ToggleInput(points: 0, 'w_lethargy', 'Lethargy or restlessness'),
  ToggleInput(points: 0, 'w_liver', 'Liver enlargement more than 2 cm'),
  ToggleInput(
    points: 0,
    'w_hct',
    'Rising haematocrit with a rapid fall in platelets',
  ),
];

const _severe = <InputSpec>[
  ToggleInput(
    points: 0,
    's_shock',
    heading: 'Severe dengue',
    'Shock from plasma leakage (compensated: tachycardia, cold peripheries, CRT >2 s, narrow pulse pressure)',
  ),
  ToggleInput(
    points: 0,
    's_hypo',
    'Hypotensive shock (low or unrecordable BP)',
  ),
  ToggleInput(
    points: 0,
    's_resp',
    'Fluid accumulation with respiratory distress',
  ),
  ToggleInput(points: 0, 's_bleed', 'Severe bleeding'),
  ToggleInput(
    points: 0,
    's_organ',
    'Severe organ involvement (AST or ALT ≥1000, impaired consciousness, heart or other organs)',
  ),
];

/// WHO dengue guidance: ideal body weight for obese adults.
double whoIdealWeight(double heightCm, {required bool female}) =>
    (female ? 45.5 : 50.0) + 0.91 * (heightCm - 152.4);

String _rate(double perKg, double kg) => '${fmt(perKg * kg, 0)} mL/h';
String _range(double lo, double hi, double kg) =>
    '${fmt(lo, 0)}–${fmt(hi, 0)} mL/kg/h = ${fmt(lo * kg, 0)}–${fmt(hi * kg, 0)} mL/h';

final dengueCalc = CalcDefinition(
  id: 'dengue',
  reviewedOn: '9 Nov 2026 (Homi)',
  version:
      'WHO 2009 dengue guidelines; WHO 2012 handbook for clinical management',
  inputs: const [
    ChoiceInput(
      'group',
      'Patient',
      initial: 0,
      choices: [Choice('Adult', 0), Choice('Child or infant', 1)],
    ),
    NumberInput(
      'weight',
      'Actual weight',
      quantity: Q.weight,
      min: 2,
      max: 250,
    ),
    NumberInput(
      'height',
      'Height (adults: to use ideal weight if obese)',
      quantity: Q.height,
      min: 45,
      max: 230,
      optional: true,
    ),
    ChoiceInput(
      'sex',
      'Sex',
      initial: 0,
      choices: [Choice('Male', 0), Choice('Female', 1)],
    ),
    ..._warningSigns,
    ..._severe,
  ],
  compute: (v) {
    final kg = v.number('weight'),
        group = v.choice('group'),
        sex = v.choice('sex');
    if (kg == null || group == null || sex == null) return null;
    final child = group == 1;
    final ht = v.number('height');
    var dosing = kg;
    final details = <String>[];
    if (!child && ht != null) {
      final ibw = whoIdealWeight(ht, female: sex == 1);
      if (kg > ibw) {
        dosing = ibw;
        details.add(
          'Using ideal body weight ${fmt(ibw)} kg (actual ${fmt(kg)} kg), as WHO advises for obese patients.',
        );
      }
    }
    final warnings = _warningSigns.where((i) => v.flag(i.id)).length;
    final severe = _severe.where((i) => v.flag(i.id)).length;
    final hypotensive = v.flag('s_hypo');
    final shock = v.flag('s_shock') || hypotensive;
    final maint = hollidaySegarDaily(dosing) / 24;

    if (hypotensive) {
      return CalcResult(
        headline: 'Severe dengue',
        band: 'Hypotensive shock',
        severity: Severity.danger,
        interpretation:
            'Resuscitate now: 20 mL/kg crystalloid or colloid bolus over 15 minutes${child ? ' (WHO 2012: 15–30 minutes)' : ''} = ${fmt(20 * dosing, 0)} mL. Take haematocrit before fluids.',
        details: [
          ...details,
          if (!child) ...[
            'If improving: 10 mL/kg/h for 1 h (${_rate(10, dosing)}), then crystalloid 5–7 mL/kg/h for 1–2 h, 3–5 mL/kg/h for 2–4 h, 2–3 mL/kg/h for 2–4 h.',
          ] else ...[
            'If improving (WHO 2012, children): colloid 10 mL/kg/h for 1 h (${_rate(10, dosing)}), then crystalloid 10 mL/kg/h for 1 h, 7.5 mL/kg/h for 2 h, 5 mL/kg/h for 4 h, then 3 mL/kg/h.',
          ],
          'If not improving and haematocrit high: colloid 10–20 mL/kg over 30–60 min (${fmt(10 * dosing, 0)}–${fmt(20 * dosing, 0)} mL).',
          'If haematocrit is falling or low: suspect bleeding and transfuse.',
          'Stop IV fluids by 48 hours.',
        ],
      );
    }
    if (shock) {
      return CalcResult(
        headline: 'Severe dengue',
        band: 'Compensated shock',
        severity: Severity.danger,
        interpretation: child
            ? 'Isotonic crystalloid 10–20 mL/kg/h over 1 hour (${_range(10, 20, dosing)}). Take haematocrit before fluids.'
            : 'Isotonic crystalloid 5–10 mL/kg/h over 1 hour (${_range(5, 10, dosing)}). Take haematocrit before fluids.',
        details: [
          ...details,
          if (!child)
            'If improving: 5–7 mL/kg/h for 1–2 h, 3–5 mL/kg/h for 2–4 h, 2–3 mL/kg/h for 2–4 h, then lower.'
          else
            'If improving (WHO 2012, children): 10 mL/kg/h for 1–2 h, 7 mL/kg/h for 2 h, 5 mL/kg/h for 4 h, then 3 mL/kg/h.',
          'If still in shock and haematocrit rising or above 50%: second bolus 10–20 mL/kg/h for 1 h (${_range(10, 20, dosing)}).',
          'If haematocrit falls: suspect bleeding and transfuse.',
          'Stop IV fluids by 48 hours.',
        ],
      );
    }
    if (severe > 0) {
      return CalcResult(
        headline: 'Severe dengue',
        band: 'Severe dengue without shock',
        severity: Severity.danger,
        interpretation:
            'Emergency treatment and referral (WHO Group C). Manage the specific complication: severe bleeding, organ involvement or respiratory distress.',
        details: [
          ...details,
          'Maintenance by Holliday–Segar on dosing weight: ${fmt(maint, 0)} mL/h.',
        ],
      );
    }
    if (warnings > 0) {
      return CalcResult(
        headline: 'Dengue with warning signs',
        band: '$warnings warning sign${warnings == 1 ? '' : 's'} (WHO Group B)',
        severity: Severity.warning,
        interpretation:
            'Admit. Take a reference haematocrit, then isotonic crystalloid 5–7 mL/kg/h for 1–2 h (${_range(5, 7, dosing)}).',
        details: [
          ...details,
          'Then 3–5 mL/kg/h for 2–4 h (${_range(3, 5, dosing)}).',
          'Then 2–3 mL/kg/h or less (${_range(2, 3, dosing)}) according to response.',
          'If vital signs worsen and haematocrit rises fast: 5–10 mL/kg/h for 1–2 h.',
          'Aim for urine output about 0.5 mL/kg/h. IV fluids are usually needed for only 24–48 hours.',
        ],
      );
    }
    return CalcResult(
      headline: 'Dengue without warning signs',
      band: 'WHO Group A (if tolerating oral fluids and passing urine)',
      severity: Severity.caution,
      interpretation:
          'Can be managed at home with oral fluids, rest and paracetamol, with daily review for warning signs, especially as the fever settles (critical phase, about day 3–7).',
      details: [
        ...details,
        'Avoid NSAIDs and aspirin.',
        'Group B instead if there are co-existing conditions (pregnancy, infancy, old age, obesity, diabetes, kidney failure) or no reliable home care.',
      ],
    );
  },
  formula:
      'Warning signs (WHO 2009): abdominal pain, persistent vomiting, fluid accumulation, mucosal bleeding, lethargy/restlessness, liver >2 cm, rising HCT with falling platelets.\n'
      'Severe: shock or fluid accumulation with respiratory distress, severe bleeding, severe organ involvement.\n'
      'Ideal weight (WHO): 50 kg (male) or 45.5 kg (female) + 0.91 × (height cm − 152.4).',
  sources: const [
    Source(
      'WHO/TDR. Dengue: guidelines for diagnosis, treatment, prevention and control. New edition, 2009.',
      url: 'https://iris.who.int/handle/10665/44188',
    ),
    Source(
      'WHO. Handbook for clinical management of dengue, 2012.',
      url: 'https://iris.who.int/handle/10665/76887',
    ),
    Source(
      'WHO. Guidelines for clinical management of arboviral diseases (dengue, chikungunya, Zika, yellow fever), July 2025. Not yet checked against this tool.',
      url: 'https://www.who.int/publications/i/item/9789240111110',
    ),
  ],
  notes: const [
    'Fluid plans are a guide: adjust to clinical response, haematocrit and urine output.',
  ],
);

// ---- D25 Ramadan fasting risk: IDF-DAR 2026 ----

const _ramadanItems = <InputSpec>[
  ToggleInput('pregnancy', 'Pregnancy with any type of diabetes', points: 6.5),
  ChoiceInput(
    'type',
    'Diabetes type',
    choices: [
      Choice('Type 1 or LADA', 1),
      Choice('Type 2 or any other type', 0),
    ],
  ),
  ChoiceInput(
    'duration',
    'Duration of diabetes',
    choices: [
      Choice('More than 20 years', 1),
      Choice('10–20 years', 0.5),
      Choice('Less than 10 years', 0),
    ],
  ),
  ToggleInput(
    't_mdi_premix',
    heading: 'Treatment (tick all that apply)',
    'Treatment: premixed insulin more than once daily',
    points: 2,
  ),
  ToggleInput(
    't_od_premix',
    'Treatment: premixed insulin once daily',
    points: 1.5,
  ),
  ToggleInput('t_pump', 'Treatment: open-loop insulin pump', points: 1.5),
  ToggleInput('t_aid', 'Treatment: automated insulin delivery', points: 1),
  ToggleInput(
    't_basal',
    'Treatment: standard basal insulin (NPH, detemir, glargine 100)',
    points: 1,
  ),
  ToggleInput(
    't_ultralong',
    'Treatment: ultra-long basal insulin (glargine 300, degludec)',
    points: 0.75,
  ),
  ToggleInput('t_short', 'Treatment: short-acting insulin', points: 0.75),
  ToggleInput('t_glib', 'Treatment: glibenclamide or glipizide', points: 0.75),
  ToggleInput(
    't_glic',
    'Treatment: gliclazide (incl. MR), glimepiride or repaglinide',
    points: 0.5,
  ),
  ToggleInput(
    't_multi',
    'Treatment: 2 or more glucose-lowering drugs without insulin or sulfonylurea',
    points: 0.25,
  ),
  ChoiceInput(
    'hypo',
    'Hypoglycaemia',
    choices: [
      Choice('Impaired awareness', 6.5),
      Choice('Severe hypo in last 4 weeks', 5),
      Choice('More than once daily', 4),
      Choice('6–7 per week', 3),
      Choice('3–5 per week', 2),
      Choice('1–2 per week', 1),
      Choice('Less than once a week', 0.5),
      Choice('None in last 4 weeks', 0),
    ],
  ),
  ChoiceInput(
    'hba1c',
    'HbA1c',
    choices: [
      Choice('Above 9% (>75 mmol/mol)', 1),
      Choice('7.5–9% (58–75)', 0.5),
      Choice('Below 7.5% (<58)', 0),
    ],
  ),
  ChoiceInput(
    'smbg',
    'Glucose monitoring',
    choices: [
      Choice('Not done', 2),
      Choice('Suboptimal', 1),
      Choice('As indicated', 0),
    ],
  ),
  ToggleInput('cgm', 'Uses any type of CGM', points: -0.5),
  ChoiceInput(
    'dka',
    'DKA or HHS',
    choices: [
      Choice('Within last month', 3.5),
      Choice('2–3 months ago', 2),
      Choice('4–6 months ago', 1),
      Choice('None in last 6 months', 0),
    ],
  ),
  ChoiceInput(
    'macro',
    'Macrovascular disease',
    choices: [Choice('Unstable', 6.5), Choice('Stable', 2), Choice('None', 0)],
  ),
  ChoiceInput(
    'egfr',
    'eGFR (mL/min/1.73 m²)',
    choices: [
      Choice('Below 30', 6.5),
      Choice('30–45', 4),
      Choice('45–60', 2),
      Choice('Above 60', 0),
    ],
  ),
  ChoiceInput(
    'micro',
    'Neuropathy, foot complications, retinopathy: how many present',
    choices: [
      Choice('3', 3),
      Choice('2', 2),
      Choice('1', 1),
      Choice('None', 0),
    ],
  ),
  ChoiceInput(
    'frailty',
    'Cognition, frailty and age',
    choices: [
      Choice('Impaired cognition', 6.5),
      Choice('Advanced frailty', 6.5),
      Choice('Mild to moderate frailty', 4),
      Choice('Over 70 with no home support', 1),
      Choice('None of these', 0),
    ],
  ),
  ChoiceInput(
    'labour',
    'Physical labour',
    choices: [
      Choice('High intensity', 4),
      Choice('Moderate', 2),
      Choice('Low', 0),
    ],
  ),
  ChoiceInput(
    'education',
    'Has had fasting-focused diabetes education',
    choices: [Choice('No', 1), Choice('Yes', 0)],
  ),
  ChoiceInput(
    'hours',
    'Expected fasting hours',
    choices: [Choice('16 hours or more', 1), Choice('Less than 16 hours', 0)],
  ),
];

final ramadanRiskCalc = CalcDefinition(
  id: 'ramadan_risk',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'IDF-DAR Risk Calculator 2026 update (Afandi 2025)',
  inputs: _ramadanItems,
  compute: (v) {
    final total = scoreTotal(_ramadanItems, v);
    if (total == null) return null;
    final (band, sev, meaning) = total <= 3
        ? (
            'Low risk',
            Severity.normal,
            'Fasting is generally safe, with a pre-Ramadan medical review, medication adjustment and glucose monitoring.',
          )
        : total <= 6
        ? (
            'Moderate risk',
            Severity.caution,
            'Fasting safety is uncertain. Fasting is possible after individual assessment, medication adjustment and close monitoring.',
          )
        : (
            'High risk',
            Severity.danger,
            'Fasting is probably unsafe. Advise against fasting.',
          );
    return CalcResult(
      headline: fmt(total.toDouble(), 2),
      unit: 'points',
      band: band,
      severity: sev,
      interpretation: meaning,
      details: [
        ...scoreBreakdown(_ramadanItems, v),
        if (v.flag('pregnancy'))
          'Pregnant and breastfeeding women may choose not to fast whatever their score.',
        'Ideally assess 6–8 weeks before Ramadan (IDF-DAR 2021).',
      ],
    );
  },
  formula:
      'Sum of 14 items (treatments add up; CGM −0.5). Low 0–3, moderate 3.5–6, high above 6.\n'
      'Totals between bands (e.g. 3.25 with CGM) are counted as the higher band here: pending clinical review.',
  sources: const [
    Source(
      'Afandi B, Suliman M, Shaikh S, Beshyah SA, Hassanein M. The 2026 update of the IDF-DAR risk calculator for fasting in people with diabetes. J Diabetes Endocr Pract 2025. doi:10.1055/s-0045-1813010',
      url:
          'https://media.idf.org/media/uploads/2026/02/IDF-DAR-Risk-Calculator-Update-2026.pdf',
    ),
    Source(
      'IDF-DAR. Diabetes and Ramadan: Practical Guidelines 2021.',
      url:
          'https://idf.org/news-and-resources/resources/diabetes-and-ramadan-practical-guidelines-2021/',
    ),
  ],
  notes: const [
    'Frailty uses the 2026 figure (mild–moderate frailty 4 points); the paper text gives 2.5 for mild frailty.',
  ],
);
