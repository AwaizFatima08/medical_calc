import '../model.dart';
import '../who_growth.dart';
import '../score.dart';
import '../units.dart';

// ---- Gestational age and due date ----

const _byLmp = (id: 'method', value: 0);
const _byScan = (id: 'method', value: 1);

String _ga(int days) => '${days ~/ 7}w ${days % 7}d';

final gestationalAgeCalc = CalcDefinition(
  id: 'gestational_age',
  version: 'Naegele rule (LMP + 280 days); ACOG CO 700 (2017) for dating',
  inputs: const [
    ChoiceInput(
      'method',
      'Date from',
      initial: 0,
      choices: [
        Choice('Last menstrual period', 0),
        Choice('Ultrasound scan', 1),
      ],
    ),
    DateInput('lmp', 'First day of last menstrual period', showWhen: _byLmp),
    DateInput('scan', 'Date of scan', showWhen: _byScan),
    NumberInput(
      'scan_w',
      'Gestational age at scan: weeks',
      quantity: Q.weeks,
      min: 4,
      max: 42,
      decimals: 0,
      showWhen: _byScan,
    ),
    NumberInput(
      'scan_d',
      'and days',
      quantity: Q.days,
      min: 0,
      max: 6,
      decimals: 0,
      optional: true,
      showWhen: _byScan,
    ),
  ],
  compute: (v) {
    final today = dateOnly(v.date('today') ?? DateTime.now());
    DateTime? lmp;
    if (v.choice('method') == 0) {
      final d = v.date('lmp');
      if (d == null) return null;
      lmp = dateOnly(d);
    } else {
      final scan = v.date('scan'), w = v.number('scan_w');
      if (scan == null || w == null) return null;
      final gaAtScan = w.round() * 7 + (v.number('scan_d') ?? 0).round();
      lmp = dateOnly(scan).subtract(Duration(days: gaAtScan));
    }
    final edd = DateTime(lmp.year, lmp.month, lmp.day + 280);
    final gaDays = daysBetween(lmp, today);
    if (gaDays < 0) {
      return const CalcResult(
        headline: '—',
        severity: Severity.caution,
        warnings: ['This date is in the future.'],
      );
    }
    final weeks = gaDays ~/ 7;
    final (band, sev) = gaDays > 44 * 7
        ? ('Beyond 44 weeks: check the dates', Severity.warning)
        : weeks < 14
        ? ('First trimester', Severity.info)
        : weeks < 28
        ? ('Second trimester', Severity.info)
        : weeks < 37
        ? ('Third trimester (preterm)', Severity.info)
        : weeks < 42
        ? ('Term', Severity.normal)
        : ('Post-term (42 weeks or more)', Severity.warning);
    return CalcResult(
      headline: _ga(gaDays),
      unit: 'today',
      band: band,
      severity: sev,
      interpretation: 'Estimated due date: ${fmtDate(edd)}.',
      details: [
        'Due date: ${fmtDate(edd)}',
        'Days to due date: ${daysBetween(today, edd)}',
        'LMP used: ${fmtDate(lmp)}',
        'Only about 1 in 20 babies is born on the due date.',
      ],
    );
  },
  formula:
      'EDD = LMP + 280 days (assumes a 28-day cycle).\nFrom a scan: LMP = scan date − gestational age at scan; then EDD = LMP + 280 days.',
  sources: const [
    Source(
      'ACOG Committee Opinion No. 700: Methods for estimating the due date. Obstet Gynecol 2017;129:e150-4.',
      url: 'https://doi.org/10.1097/AOG.0000000000002046',
    ),
  ],
  notes: const [
    'A first-trimester scan is the most accurate way to date a pregnancy.',
  ],
);

// ---- Bishop score ----

const _bishopItems = <InputSpec>[
  ChoiceInput(
    'dilation',
    'Dilation',
    choices: [
      Choice('Closed', 0),
      Choice('1–2 cm', 1),
      Choice('3–4 cm', 2),
      Choice('5 cm or more', 3),
    ],
  ),
  ChoiceInput(
    'effacement',
    'Effacement',
    choices: [
      Choice('0–30%', 0),
      Choice('40–50%', 1),
      Choice('60–70%', 2),
      Choice('80% or more', 3),
    ],
  ),
  ChoiceInput(
    'station',
    'Fetal station',
    choices: [
      Choice('−3', 0),
      Choice('−2', 1),
      Choice('−1 or 0', 2),
      Choice('+1 or +2', 3),
    ],
  ),
  ChoiceInput(
    'consistency',
    'Cervical consistency',
    choices: [Choice('Firm', 0), Choice('Medium', 1), Choice('Soft', 2)],
  ),
  ChoiceInput(
    'position',
    'Cervical position',
    choices: [Choice('Posterior', 0), Choice('Mid', 1), Choice('Anterior', 2)],
  ),
];

final bishopCalc = CalcDefinition(
  id: 'bishop',
  version: 'Bishop 1964',
  inputs: _bishopItems,
  compute: (v) {
    if (scoreTotal(_bishopItems, v) == null) return null;
    return scoreResult(_bishopItems, v, const [
      ScoreBand(
        6,
        'Unfavourable cervix (6 or less)',
        Severity.caution,
        'Cervical ripening is usually needed before induction.',
      ),
      ScoreBand(
        7,
        'Intermediate (7)',
        Severity.info,
        'Between unfavourable and favourable.',
      ),
      ScoreBand(
        double.infinity,
        'Favourable cervix (8 or more)',
        Severity.normal,
        'Chance of vaginal delivery after induction is similar to spontaneous labour.',
      ),
    ]);
  },
  formula:
      'Dilation 0–3 + effacement 0–3 + station 0–3 + consistency 0–2 + position 0–2. Maximum 13.',
  sources: const [
    Source(
      'Bishop EH. Pelvic scoring for elective induction. Obstet Gynecol 1964;24:266-8.',
    ),
    Source(
      'ACOG Practice Bulletin No. 107: Induction of labor. Obstet Gynecol 2009;114:386-97.',
      url: 'https://doi.org/10.1097/AOG.0b013e3181b48ef5',
    ),
  ],
);

// ---- Holliday-Segar maintenance fluids ----

double hollidaySegarDaily(double kg) {
  if (kg <= 10) return 100 * kg;
  if (kg <= 20) return 1000 + 50 * (kg - 10);
  return 1500 + 20 * (kg - 20);
}

final hollidaySegarCalc = CalcDefinition(
  id: 'holliday_segar',
  version: 'Holliday & Segar 1957 (4-2-1 rule)',
  inputs: const [
    NumberInput('weight', 'Weight', quantity: Q.weight, min: 1, max: 150),
  ],
  compute: (v) {
    final kg = v.number('weight');
    if (kg == null) return null;
    final daily = hollidaySegarDaily(kg);
    return CalcResult(
      headline: fmt(daily / 24, 0),
      unit: 'mL/h',
      band: '${fmt(daily, 0)} mL per 24 hours',
      severity: Severity.info,
      interpretation:
          'Maintenance only. Add deficit and ongoing losses separately. NICE NG29 advises isotonic fluids for maintenance in children.',
      details: [
        if (kg > 70)
          'Adult-size patient: many guidelines use 25–30 mL/kg/day instead (NICE CG174).',
      ],
    );
  },
  formula:
      '100 mL/kg/day for the first 10 kg + 50 mL/kg/day for the next 10 kg + 20 mL/kg/day above 20 kg.\nHourly: 4 + 2 + 1 mL/kg/h.',
  sources: const [
    Source(
      'Holliday MA, Segar WE. The maintenance need for water in parenteral fluid therapy. Pediatrics 1957;19:823-32.',
    ),
    Source(
      'NICE NG29. Intravenous fluid therapy in children and young people in hospital (2015, updated 2020).',
      url: 'https://www.nice.org.uk/guidance/ng29',
    ),
  ],
);

// ---- Parkland ----

const _byPercent = (id: 'method', value: 0);
const _byRegions = (id: 'method', value: 1);

const _ruleOfNines = <InputSpec>[
  ToggleInput(
    'head',
    heading: 'Burnt regions (partial or full thickness)',
    'Head and neck',
    points: 9,
    showWhen: _byRegions,
  ),
  ToggleInput('r_arm', 'Right arm', points: 9, showWhen: _byRegions),
  ToggleInput('l_arm', 'Left arm', points: 9, showWhen: _byRegions),
  ToggleInput('front', 'Front of trunk', points: 18, showWhen: _byRegions),
  ToggleInput('back', 'Back of trunk', points: 18, showWhen: _byRegions),
  ToggleInput('r_leg', 'Right leg', points: 18, showWhen: _byRegions),
  ToggleInput('l_leg', 'Left leg', points: 18, showWhen: _byRegions),
  ToggleInput('perineum', 'Perineum', points: 1, showWhen: _byRegions),
];

final parklandCalc = CalcDefinition(
  id: 'parkland',
  version: 'Parkland formula (Baxter 1968); adult Rule of Nines',
  inputs: const [
    NumberInput('weight', 'Weight', quantity: Q.weight, min: 3, max: 250),
    ChoiceInput(
      'method',
      'Burn area',
      initial: 0,
      choices: [Choice('Enter % TBSA', 0), Choice('Rule of Nines (adults)', 1)],
    ),
    NumberInput(
      'tbsa',
      '% total body surface area (partial + full thickness)',
      quantity: Q.percent,
      min: 1,
      max: 100,
      decimals: 0,
      showWhen: _byPercent,
    ),
    ..._ruleOfNines,
  ],
  compute: (v) {
    final kg = v.number('weight');
    if (kg == null) return null;
    final double? tbsa = v.choice('method') == 0
        ? v.number('tbsa')
        : scoreTotal(_ruleOfNines, v)!.toDouble();
    if (tbsa == null || tbsa <= 0) return null;
    final total = 4 * kg * tbsa;
    return CalcResult(
      headline: fmt(total, 0),
      unit: 'mL in 24 hours',
      band: 'TBSA ${fmt(tbsa, 0)}%',
      severity: tbsa >= 15 ? Severity.warning : Severity.caution,
      interpretation:
          'Crystalloid (e.g. Ringer\'s lactate), timed from the burn, not from arrival. Adjust to urine output (about 0.5 mL/kg/h in adults, 1 mL/kg/h in children).',
      details: [
        'First 8 hours: ${fmt(total / 2, 0)} mL (${fmt(total / 16, 0)} mL/h)',
        'Next 16 hours: ${fmt(total / 2, 0)} mL (${fmt(total / 32, 0)} mL/h)',
        if (tbsa < 15)
          'Formal IV resuscitation is usually for burns of 15% or more in adults, 10% or more in children.',
        'Children also need maintenance fluid on top of this.',
      ],
    );
  },
  formula:
      '24-hour fluid = 4 mL × weight (kg) × % TBSA. Half in the first 8 hours from the time of burn, half over the next 16 hours.\n'
      'Rule of Nines (adults): head 9, each arm 9, front trunk 18, back trunk 18, each leg 18, perineum 1. Do not count simple erythema.',
  sources: const [
    Source(
      'Baxter CR, Shires T. Physiological response to crystalloid resuscitation of severe burns. Ann N Y Acad Sci 1968;150:874-94.',
      url: 'https://doi.org/10.1111/j.1749-6632.1968.tb14738.x',
    ),
    Source(
      'ISBI Practice Guidelines Committee. ISBI practice guidelines for burn care. Burns 2016;42:953-1021.',
      url: 'https://doi.org/10.1016/j.burns.2016.05.013',
    ),
  ],
  notes: const [
    'Rule of Nines is for adults. In children use a Lund-Browder chart (the head is a larger share).',
  ],
);

// ---- WHO / IMCI dehydration with ORS plans ----

final dehydrationCalc = CalcDefinition(
  id: 'dehydration',
  version: 'WHO 2005 diarrhoea treatment / IMCI 2014',
  inputs: const [
    NumberInput('weight', 'Weight', quantity: Q.weight, min: 1, max: 80),
    NumberInput(
      'age',
      'Age',
      quantity: Q.ageMonths,
      min: 0,
      max: 180,
      decimals: 0,
    ),
    ChoiceInput(
      'general',
      'General condition',
      choices: [
        Choice('Well, alert', 0),
        Choice('Restless, irritable', 1),
        Choice('Lethargic or unconscious', 2),
      ],
    ),
    ChoiceInput(
      'eyes',
      'Eyes',
      choices: [Choice('Normal', 0), Choice('Sunken', 1)],
    ),
    ChoiceInput(
      'drink',
      'Drinking',
      choices: [
        Choice('Drinks normally', 0),
        Choice('Drinks eagerly, thirsty', 1),
        Choice('Drinks poorly or not able to drink', 2),
      ],
    ),
    ChoiceInput(
      'pinch',
      'Skin pinch goes back',
      choices: [
        Choice('Immediately', 0),
        Choice('Slowly', 1),
        Choice('Very slowly (more than 2 seconds)', 2),
      ],
    ),
  ],
  compute: (v) {
    final kg = v.number('weight'), months = v.number('age');
    final g = v.choice('general'),
        e = v.choice('eyes'),
        d = v.choice('drink'),
        p = v.choice('pinch');
    if (kg == null ||
        months == null ||
        g == null ||
        e == null ||
        d == null ||
        p == null) {
      return null;
    }
    final severeSigns = [g == 2, e == 1, d == 2, p == 2].where((x) => x).length;
    // A severe-level sign also counts as the matching "some" sign.
    final someSigns = [g >= 1, e == 1, d >= 1, p >= 1].where((x) => x).length;
    if (severeSigns >= 2) {
      final under1 = months < 12;
      return CalcResult(
        headline: 'Severe dehydration',
        band: 'Plan C: IV fluids now',
        severity: Severity.danger,
        interpretation:
            'Ringer\'s lactate (or normal saline) 100 mL/kg IV. Reassess every 15–30 minutes. Start ORS (about 5 mL/kg/h) as soon as the child can drink.',
        details: [
          under1
              ? 'Under 12 months: ${fmt(30 * kg, 0)} mL in the first 1 hour, then ${fmt(70 * kg, 0)} mL over the next 5 hours.'
              : '12 months or older: ${fmt(30 * kg, 0)} mL in the first 30 minutes, then ${fmt(70 * kg, 0)} mL over the next 2½ hours.',
          'Repeat the first 30 mL/kg once if the radial pulse is still very weak or not detectable.',
          'If IV is not possible: ORS 20 mL/kg/h by nasogastric tube for 6 hours (${fmt(120 * kg, 0)} mL) and refer urgently.',
        ],
      );
    }
    if (someSigns >= 2) {
      return CalcResult(
        headline: 'Some dehydration',
        band: 'Plan B: ORS in the clinic',
        severity: Severity.warning,
        interpretation:
            'Give ORS 75 mL/kg over 4 hours: ${fmt(75 * kg, 0)} mL. Reassess after 4 hours and choose plan A, B or C. Continue breastfeeding.',
        details: [
          'About ${fmt(75 * kg / 4, 0)} mL per hour, given in small frequent sips or by spoon.',
          'Give zinc for 10–14 days: 10 mg/day under 6 months, 20 mg/day from 6 months.',
        ],
      );
    }
    final perStool = months < 24
        ? '50–100 mL'
        : months < 120
        ? '100–200 mL'
        : 'as much as wanted';
    return CalcResult(
      headline: 'No dehydration',
      band: 'Plan A: treat at home',
      severity: Severity.normal,
      interpretation:
          'Extra fluid at home: ORS $perStool after each loose stool. Continue feeding and breastfeeding. Zinc for 10–14 days.',
      details: const [
        'Return immediately if the child cannot drink, gets sicker, has blood in the stool, or drinks poorly.',
      ],
    );
  },
  formula:
      'Severe dehydration: two or more of lethargic/unconscious, sunken eyes, not able to drink or drinking poorly, skin pinch very slow.\n'
      'Some dehydration: two or more of restless/irritable, sunken eyes, drinks eagerly, skin pinch slow.\n'
      'Plan B: ORS 75 mL/kg over 4 h. Plan C: 100 mL/kg Ringer\'s lactate (under 12 months 30 mL/kg in 1 h then 70 mL/kg in 5 h; older 30 mL/kg in 30 min then 70 mL/kg in 2½ h).',
  sources: const [
    Source(
      'WHO. The treatment of diarrhoea: a manual for physicians and other senior health workers, 4th rev. 2005.',
      url: 'https://www.who.int/publications/i/item/9241593180',
    ),
    Source(
      'WHO. Integrated Management of Childhood Illness (IMCI) chart booklet, 2014.',
      url:
          'https://www.who.int/publications/m/item/integrated-management-of-childhood-illness---chart-booklet-(march-2014)',
    ),
  ],
  notes: const [
    'For children with acute diarrhoea. Severe acute malnutrition needs a different (ReSoMal) protocol.',
  ],
);

// ---- D21 WHO growth z-scores and MUAC ----

const _byDob = (id: 'agemode', value: 0);
const _byMonths = (id: 'agemode', value: 1);

String _z(double z) => '${z >= 0 ? '+' : '−'}${fmt(z.abs(), 2)}';

final whoGrowthCalc = CalcDefinition(
  id: 'who_growth',
  version:
      'WHO Child Growth Standards 2006 (0–5 years); WHO 2013 SAM guideline (MUAC)',
  inputs: const [
    ChoiceInput(
      'sex',
      'Sex',
      initial: 0,
      choices: [Choice('Boy', 0), Choice('Girl', 1)],
    ),
    ChoiceInput(
      'agemode',
      'Age from',
      initial: 0,
      choices: [Choice('Date of birth', 0), Choice('Age in months', 1)],
    ),
    DateInput('dob', 'Date of birth', showWhen: _byDob),
    NumberInput(
      'months',
      'Age',
      quantity: Q.ageMonths,
      min: 0,
      max: 60,
      showWhen: _byMonths,
    ),
    NumberInput(
      'weight',
      'Weight',
      quantity: Q.weight,
      min: 0.9,
      max: 58,
      decimals: 2,
    ),
    NumberInput(
      'length',
      'Length or height',
      quantity: Q.height,
      min: 45,
      max: 125,
    ),
    ChoiceInput(
      'measured',
      'Measured',
      initial: 0,
      choices: [
        Choice('Lying down (length)', 0),
        Choice('Standing (height)', 1),
      ],
    ),
    NumberInput(
      'muac',
      'MUAC, mid-upper arm (6–59 months)',
      quantity: Q.length,
      min: 6,
      max: 30,
      optional: true,
    ),
    ToggleInput('oedema', 'Bilateral pitting oedema', points: 0),
  ],
  compute: (v) {
    final who = WhoGrowth.instance;
    final sex = v.choice('sex'),
        kg = v.number('weight'),
        len = v.number('length');
    if (sex == null || kg == null || len == null) return null;
    double? days;
    if (v.choice('agemode') == 0) {
      final dob = v.date('dob');
      if (dob == null) return null;
      days = daysBetween(dob, v.date('today') ?? DateTime.now()).toDouble();
    } else {
      final m = v.number('months');
      if (m == null) return null;
      days = m * 30.4375;
    }
    if (who == null) {
      return const CalcResult(
        headline: '—',
        warnings: ['Growth tables are still loading.'],
      );
    }
    if (days < 0 || days > 1856) {
      return const CalcResult(
        headline: '—',
        severity: Severity.caution,
        warnings: ['WHO Child Growth Standards cover birth to 5 years.'],
      );
    }
    final girl = sex == 1;
    final months = days / 30.4375;
    // WHO: length (lying) under 24 months, height (standing) from 24 months.
    var l = len;
    final standing = v.choice('measured') == 1;
    final adj = <String>[];
    if (days < 731 && standing) {
      l += 0.7;
      adj.add('Standing height under 2 years: +0.7 cm to convert to length.');
    } else if (days >= 731 && !standing) {
      l -= 0.7;
      adj.add('Lying length from 2 years: −0.7 cm to convert to height.');
    }
    final waz = who
        .table('wfa', girl: girl)
        .at(days.roundToDouble())!
        .zRestricted(kg);
    final haz = who.table('lhfa', girl: girl).at(days.roundToDouble())!.z(l);
    final whTable = who.table(days < 731 ? 'wfl' : 'wfh', girl: girl);
    final whLms = whTable.at((l * 10).round() / 10);
    final whz = whLms?.zRestricted(kg);

    final muac = v.number('muac');
    final oedema = v.flag('oedema');
    final sixTo59 = months >= 6 && months < 60;
    String status;
    Severity sev;
    if (oedema ||
        (whz != null && whz < -3) ||
        (sixTo59 && muac != null && muac < 11.5)) {
      status = 'Severe acute malnutrition (SAM)';
      sev = Severity.danger;
    } else if ((whz != null && whz < -2) ||
        (sixTo59 && muac != null && muac < 12.5)) {
      status = 'Moderate acute malnutrition (wasting)';
      sev = Severity.warning;
    } else if (whz != null && whz > 3) {
      status = 'Obese (weight-for-length/height above +3)';
      sev = Severity.warning;
    } else if (whz != null && whz > 2) {
      status = 'Overweight (above +2)';
      sev = Severity.caution;
    } else if (haz < -2) {
      status = haz < -3 ? 'Severely stunted' : 'Stunted';
      sev = haz < -3 ? Severity.warning : Severity.caution;
    } else if (waz < -2) {
      status = waz < -3 ? 'Severely underweight' : 'Underweight';
      sev = Severity.caution;
    } else {
      status = 'Within normal range';
      sev = Severity.normal;
    }
    return CalcResult(
      headline: whz == null ? _z(waz) : _z(whz),
      unit: whz == null
          ? 'weight-for-age z'
          : 'weight-for-${days < 731 ? 'length' : 'height'} z',
      band: status,
      severity: sev,
      interpretation: sev == Severity.danger
          ? 'SAM: refer for inpatient care if there are medical complications or poor appetite; otherwise outpatient therapeutic feeding (WHO 2013).'
          : 'z-scores compare the child with the WHO standard for healthy children of the same age and sex.',
      details: [
        'Age: ${fmt(months, 1)} months',
        'Weight-for-age: ${_z(waz)}${waz < -3
            ? ' (severely underweight)'
            : waz < -2
            ? ' (underweight)'
            : ''}',
        '${days < 731 ? 'Length' : 'Height'}-for-age: ${_z(haz)}${haz < -3
            ? ' (severely stunted)'
            : haz < -2
            ? ' (stunted)'
            : ''}',
        if (whz != null)
          'Weight-for-${days < 731 ? 'length' : 'height'}: ${_z(whz)}'
        else
          'Weight-for-${days < 731 ? 'length' : 'height'}: outside the table (${fmt(whTable.minX, 0)}–${fmt(whTable.maxX, 0)} cm)',
        if (muac != null && sixTo59)
          'MUAC ${fmt(muac, 1)} cm: ${muac < 11.5
              ? 'below 11.5 (SAM)'
              : muac < 12.5
              ? '11.5–12.4 (MAM)'
              : '12.5 or more (normal)'}',
        if (muac != null && !sixTo59)
          'MUAC cut-offs apply to 6–59 months only.',
        if (oedema) 'Bilateral pitting oedema means SAM whatever the z-scores.',
        ...adj,
      ],
    );
  },
  formula:
      'z = ((X/M)^L − 1) / (L × S) with WHO L, M, S values for age in days or length/height in 0.1 cm.\n'
      'For weight indicators beyond ±3, WHO\'s restricted method uses the SD2–SD3 distance.\n'
      'Wasting: WHZ below −2 (severe below −3); stunting: HAZ below −2; underweight: WAZ below −2. MUAC (6–59 months): SAM below 11.5 cm, MAM 11.5–12.4 cm.',
  sources: const [
    Source(
      'WHO Multicentre Growth Reference Study Group. WHO Child Growth Standards: methods and development. WHO 2006.',
      url: 'https://www.who.int/tools/child-growth-standards',
    ),
    Source(
      'WHO. Guideline: updates on the management of severe acute malnutrition in infants and children, 2013.',
      url: 'https://www.who.int/publications/i/item/9789241506328',
    ),
  ],
);
