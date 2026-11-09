import '../model.dart';
import '../score.dart';

const _dvt = (id: 'test', value: 0);
const _pe = (id: 'test', value: 1);
const _perc = (id: 'test', value: 2);

const _dvtItems = <InputSpec>[
  ToggleInput(
    'd_cancer',
    'Active cancer (treatment within 6 months or palliative)',
    showWhen: _dvt,
  ),
  ToggleInput(
    'd_paralysis',
    'Paralysis, paresis or recent plaster cast of a leg',
    showWhen: _dvt,
  ),
  ToggleInput(
    'd_bed',
    'Bedridden 3 days or more, or major surgery within 12 weeks',
    showWhen: _dvt,
  ),
  ToggleInput(
    'd_tender',
    'Localised tenderness along the deep veins',
    showWhen: _dvt,
  ),
  ToggleInput('d_leg', 'Entire leg swollen', showWhen: _dvt),
  ToggleInput(
    'd_calf',
    'Calf swelling 3 cm more than the other leg',
    showWhen: _dvt,
  ),
  ToggleInput(
    'd_pitting',
    'Pitting oedema in the symptomatic leg only',
    showWhen: _dvt,
  ),
  ToggleInput(
    'd_collateral',
    'Collateral superficial (non-varicose) veins',
    showWhen: _dvt,
  ),
  ToggleInput('d_prior', 'Previously documented DVT', showWhen: _dvt),
  ToggleInput(
    'd_alt',
    'Alternative diagnosis at least as likely as DVT',
    points: -2,
    showWhen: _dvt,
  ),
];

const _peItems = <InputSpec>[
  ToggleInput(
    'p_dvt',
    'Clinical signs and symptoms of DVT',
    points: 3,
    showWhen: _pe,
  ),
  ToggleInput(
    'p_likely',
    'PE is the most likely diagnosis',
    points: 3,
    showWhen: _pe,
  ),
  ToggleInput('p_hr', 'Heart rate above 100', points: 1.5, showWhen: _pe),
  ToggleInput(
    'p_immob',
    'Immobilisation 3 days or more, or surgery within 4 weeks',
    points: 1.5,
    showWhen: _pe,
  ),
  ToggleInput('p_prior', 'Previous DVT or PE', points: 1.5, showWhen: _pe),
  ToggleInput('p_haemoptysis', 'Haemoptysis', showWhen: _pe),
  ToggleInput(
    'p_cancer',
    'Malignancy (treatment within 6 months or palliative)',
    showWhen: _pe,
  ),
];

const _percItems = <InputSpec>[
  ToggleInput('r_age', 'Age 50 or older', showWhen: _perc),
  ToggleInput('r_hr', 'Heart rate 100 or more', showWhen: _perc),
  ToggleInput('r_sat', 'SpO₂ below 95% on room air', showWhen: _perc),
  ToggleInput('r_leg', 'Unilateral leg swelling', showWhen: _perc),
  ToggleInput('r_haemoptysis', 'Haemoptysis', showWhen: _perc),
  ToggleInput('r_surgery', 'Surgery or trauma within 4 weeks', showWhen: _perc),
  ToggleInput('r_prior', 'Prior DVT or PE', showWhen: _perc),
  ToggleInput(
    'r_hormone',
    'Hormone use (oral contraceptives, HRT, oestrogen)',
    showWhen: _perc,
  ),
];

final wellsPercCalc = CalcDefinition(
  id: 'wells_perc',
  reviewedOn: '9 Nov 2026 (Homi)',
  version: 'Wells DVT (2003), Wells PE (2000), PERC (Kline 2004)',
  inputs: const [
    ChoiceInput(
      'test',
      'Score',
      initial: 0,
      choices: [
        Choice('Wells DVT', 0),
        Choice('Wells PE', 1),
        Choice('PERC rule', 2),
      ],
    ),
    ..._dvtItems,
    ..._peItems,
    ..._percItems,
  ],
  compute: (v) {
    switch (v.choice('test')) {
      case 0:
        return scoreResult(_dvtItems, v, const [
          ScoreBand(
            1,
            'DVT unlikely',
            Severity.caution,
            'Score below 2: DVT unlikely. A negative D-dimer can rule out DVT (NICE NG158).',
          ),
          ScoreBand(
            double.infinity,
            'DVT likely',
            Severity.warning,
            'Score 2 or more: DVT likely. Proximal leg vein ultrasound is indicated (NICE NG158).',
          ),
        ]);
      case 1:
        final r = scoreResult(_peItems, v, const [
          ScoreBand(
            4,
            'PE unlikely',
            Severity.caution,
            'Score 4 or less: PE unlikely. A negative D-dimer can rule out PE (NICE NG158).',
          ),
          ScoreBand(
            double.infinity,
            'PE likely',
            Severity.warning,
            'Score above 4: PE likely. CT pulmonary angiography is indicated (NICE NG158).',
          ),
        ]);
        final total = scoreTotal(_peItems, v)!;
        final tier = total < 2
            ? 'low'
            : total <= 6
            ? 'moderate'
            : 'high';
        return CalcResult(
          headline: r.headline,
          unit: r.unit,
          band: r.band,
          severity: r.severity,
          interpretation: r.interpretation,
          details: [
            ...r.details,
            'Three-tier model: $tier clinical probability (below 2 low, 2–6 moderate, above 6 high).',
          ],
        );
      case 2:
        final count = scoreTotal(_percItems, v)!;
        return CalcResult(
          headline: count == 0 ? 'PERC negative' : 'PERC positive',
          band: count == 0
              ? 'All 8 criteria absent'
              : '${fmt(count.toDouble())} of 8 criteria present',
          severity: count == 0 ? Severity.normal : Severity.caution,
          interpretation: count == 0
              ? 'Only when clinical probability is already low (gestalt below 15%): PE can be ruled out without D-dimer.'
              : 'PERC cannot rule out PE. Use Wells PE and D-dimer.',
          details: scoreBreakdown(_percItems, v),
        );
      default:
        return null;
    }
  },
  formula:
      'Wells DVT: 1 point each, −2 if an alternative diagnosis is as likely; 2 or more = likely.\n'
      'Wells PE: DVT signs 3, PE most likely 3, HR >100 1.5, immobilisation/surgery 1.5, prior VTE 1.5, haemoptysis 1, cancer 1; above 4 = likely.\n'
      'PERC: 8 criteria; negative only if all absent, and only in low-probability patients.',
  sources: const [
    Source(
      'Wells PS et al. Evaluation of D-dimer in the diagnosis of suspected deep-vein thrombosis. N Engl J Med 2003;349:1227-35.',
      url: 'https://doi.org/10.1056/NEJMoa023153',
    ),
    Source(
      'Wells PS et al. Derivation of a simple clinical model to categorize patients\' probability of PE. Thromb Haemost 2000;83:416-20.',
    ),
    Source(
      'Kline JA et al. Clinical criteria to prevent unnecessary diagnostic testing in ED patients with suspected PE. J Thromb Haemost 2004;2:1247-55.',
      url: 'https://doi.org/10.1111/j.1538-7836.2004.00790.x',
    ),
    Source(
      'NICE NG158. Venous thromboembolic diseases: diagnosis, management and thrombophilia testing (2020, updated 2023).',
      url: 'https://www.nice.org.uk/guidance/ng158',
    ),
  ],
);
