# Medical Calc (working title) — App Design Document v0.1

**Owner:** HomiLabs Solutions SMC Pvt Ltd
**Prepared:** 9 November 2026 · **Status:** Release 1 built; all calculators reviewed and passed by Homi (9 Nov 2026). Decisions in Section 14.1.
**Based on:** `reports/Health calculator tools for app.md` (research, 9 Nov 2026) and its notes in `research_notes/`.

---

## 1. Summary

Medical Calc is an offline Android health calculator for Pakistan, in English (English only — Homi, 9 Nov). On first launch the user picks one of two modes:

- **Doctor mode** offers bedside clinical formulas and scores for house officers, PG trainees and GPs.
- **Public mode** offers simple self-checks for the common man, with plain-language results, a colour band, one next step and red-flag warnings.

The app wins on three things foreign apps don't offer: **Pakistani defaults** (mg/dL, Asian cut-offs, Ramadan, dengue, hepatitis C), **plain-English results for the public**, and **working fully offline**. It does not try to match MDCalc's 900 tools. It does about 35 tools without error.

Every result is a **published formula whose output a clinician can check**, shown as a reference band, never as a treatment instruction. That one rule keeps the app in Google Play's "not a medical device" category and out of copyright trouble. Drug dosing is left out of release 1.

---

## 2. Proposed locked decisions (confirm)

| # | Decision | Source |
|---|---|---|
| L1 | HomiLabs owns the app | Homi, 9 Nov |
| L2 | Two modes chosen at first launch: Doctor and Public; switchable in Settings | Homi, 9 Nov |
| L3 | Package `com.homilabs.medicalcalc`; repo `AwaizFatima08/medical_calc` (public) | HomiLabs naming, Homi 9 Nov |
| L4 | Stack: Flutter, Android first, **no backend, no login** | Research: offline-first, no personal data |
| L5 | Language: **English only**, no Urdu text or audio | Homi, 9 Nov |
| L6 | Release 1 contains only verifiable formulas and scores; **no patient-specific drug dosing** | Research report, Sections 2, 3, 5 |
| L7 | No formula or threshold is coded until it is checked against its primary source and signed off by a clinician (Section 9) | Research report, Section 6 |
| L8 | MMSE and MoCA are excluded (licence holders enforce copyright) | Research report, Section 5 |
| L9 | Free with **AdMob** ads; AdMob account **homilabs.smc@gmail.com** (Section 6.1) | Homi, 9 Nov |
| L10 | Google Play countries: **all except the EU** | Homi, 9 Nov |
| L11 | Release 1 = full Section 4 list, built and reviewed in batches (Section 11) | Homi, 9 Nov |
| L12 | Homi signs off every calculator after the whole app is built; results show "Review pending" until then | Homi, 9 Nov |

---

## 3. Scope

### 3.1 In release 1.0

1. Splash, mode selector (Section 5)
2. Doctor-mode self-declaration (one time, stored on the phone)
3. Home screen per mode: search, categories, favourites, recently used
4. The calculators in Section 4 (Doctor 28, Public 10)
5. A shared result screen: value, band, interpretation, formula, citation, version, last-reviewed date
6. Unit toggle (conventional ↔ SI) on every lab field; mg/dL by default
7. Settings: mode, units, BMI standard (Asian / international), clear data, About
8. About: disclaimer, sources list, licence credits (GCS, EPDS, PHQ/GAD), app build

### 3.2 Not in release 1.0 (flag before adding — scope creep)

- Any drug dose (paediatric mg/kg, insulin, TB weight bands, antibiotics, anticoagulants) — Phase 3, needs a formulary and a pharmacist
- Symptom checkers or any "you have X" diagnosis
- Accounts, cloud sync, saved patient records
- MMSE, MoCA, QRISK3 (licence conditions)
- Urdu text or audio (English only, L5)
- Lottie animations, sound effects (not needed)
- iOS

---

## 4. Calculators in release 1.0

Each tool is marked **F** (simple formula) or **S** (multi-item score), and **Lab** if it needs a lab value. "Verify" means the formula, cut-offs or wording are not yet checked against the primary source — this happens in Build Phase 2 before the tool is coded.

### 4.1 Doctor mode

| # | Category | Tool | Type | Notes |
|---|---|---|---|---|
| D1 | Kidney | eGFR CKD-EPI 2021 (race-free) + KDIGO G stage | F, Lab | Name the equation on the result; MDRD only as a labelled "superseded" toggle |
| D2 | Kidney | Cockcroft-Gault creatinine clearance (actual / ideal / adjusted weight) | F, Lab | |
| D3 | Cardio | MAP | F | |
| D4 | Cardio | QTc (Bazett, Fridericia) | F | |
| D5 | Cardio | CHA2DS2-VA (default) with CHA2DS2-VASc toggle | S | ESC 2024 vs ACC/AHA 2023 |
| D6 | Cardio | HAS-BLED | S | |
| D7 | VTE | Wells DVT; Wells PE; PERC | S | |
| D8 | Acute | CURB-65 / CRB-65 | S | CRB-65 when urea is not available |
| D9 | Acute | NEWS2 | S | |
| D10 | Acute | qSOFA (with Surviving Sepsis 2021 caveat shown on the result) | S | Link to NEWS2 |
| D11 | Acute | GCS (E/V/M) | S | Credit University of Glasgow / Sir Graham Teasdale; confirm commercial use (14.6) |
| D12 | Lab | Anion gap (± albumin correction) | F, Lab | |
| D13 | Lab | Corrected calcium (albumin) | F, Lab | |
| D14 | Lab | Corrected sodium (glucose) | F, Lab | Verify factor (1.6 vs 2.4) |
| D15 | Lab | Serum osmolality and osmolal gap | F, Lab | |
| D16 | Body | BMI, BSA (Mosteller), IBW, adjusted body weight | F | |
| D17 | Obstetric | Gestational age / EDD (LMP or scan date) | F | |
| D18 | Obstetric | Bishop score | S | |
| D19 | Paeds | Holliday-Segar maintenance fluids | F | |
| D20 | Burns | Parkland formula with Rule of 9s | F | |
| D21 | Paeds | WHO growth z-scores (WFA, HFA, WFH, BMI-for-age) and MUAC bands | F | WHO 2006 LMS tables bundled offline |
| D22 | Paeds | IMCI dehydration assessment with ORS Plan A/B/C volumes | S | ORS volume is a WHO plan, not a drug dose |
| D23 | Liver | APRI; FIB-4 (asks: HCV/HBV or fatty liver → picks cut-off pair) | F, Lab | 1.45/3.25 vs 1.3/2.67 — verify |
| D24 | Dengue | WHO 2009 classification + NIH Islamabad warning-sign checklist + WHO crystalloid regimen | S | Cite WHO handbook; no local mL/kg table found |
| D25 | Diabetes | IDF-DAR 2021 Ramadan pre-fast risk score | S | Verify items; Hijri date shown |
| D26 | Diabetes | HbA1c ↔ estimated average glucose (ADAG) | F | |
| D27 | Utility | Infusion / drip rate (mL/h, drops/min) | F | Drip rate from an ordered dose is arithmetic, not dosing advice |
| D28 | Utility | **Lab unit converter: conventional (metric, e.g. mg/dL, g/dL) ↔ SI (mmol/L, µmol/L, g/L)** — both directions, search by test name | F | Added by Homi, 9 Nov. Factors in 4.1.1; each verified against a primary reference |

#### 4.1.1 D28 lab converter — tests in release 1

Each factor is verified against a primary reference (e.g. the SI conversion tables in a standard laboratory reference) and gets golden vectors like any other tool.

| Group | Tests | Conventional ↔ SI |
|---|---|---|
| Kidney | Creatinine; urea / BUN; uric acid | mg/dL ↔ µmol/L; mg/dL ↔ mmol/L (urea vs BUN shown separately) |
| Sugar | Glucose; HbA1c | mg/dL ↔ mmol/L; % (NGSP) ↔ mmol/mol (IFCC) |
| Lipids | Total cholesterol, LDL, HDL; triglycerides | mg/dL ↔ mmol/L (different factor for triglycerides) |
| Electrolytes | Sodium, potassium, chloride, bicarbonate; calcium; magnesium; phosphate | mEq/L ↔ mmol/L; mg/dL ↔ mmol/L |
| Liver | Bilirubin; albumin; total protein | mg/dL ↔ µmol/L; g/dL ↔ g/L |
| Blood | Haemoglobin; ferritin; iron | g/dL ↔ g/L (and mmol/L); ng/mL ↔ µg/L; µg/dL ↔ µmol/L |
| Other | Lactate; ammonia; vitamin D (25-OH); vitamin B12; TSH/free T4 | mg/dL ↔ mmol/L; µg/dL ↔ µmol/L; ng/mL ↔ nmol/L; pg/mL ↔ pmol/L; ng/dL ↔ pmol/L |

The same factors drive the unit toggle on every lab field in the other calculators, so there is one source of truth (`lib/calc/units.dart`).

### 4.2 Public mode

| # | Tool | Inputs (no lab) | Guard-rails |
|---|---|---|---|
| P1 | BMI with Asian bands (international toggle) + waist and waist-to-height | height (ft/in or cm), weight, waist | Not for children, pregnancy, athletes |
| P2 | Diabetes risk test (IDRS) | age, waist, activity, family history | "Screening estimate — get a blood test" at high risk |
| P3 | Home BP reading check | systolic, diastolic, symptoms | Full-screen red flag above 180/120 with symptoms: "Call 1122" |
| P4 | Home blood sugar check + HbA1c ↔ average sugar | reading, fasting / after meal | Low-sugar and DKA red flags; "a meter never diagnoses" |
| P5 | 10-year heart risk (WHO non-lab chart) | age, sex, smoking, systolic BP, BMI | Region chart to confirm (14.3); ≥10% → see a doctor |
| P6 | Pregnancy due date and week | LMP | Always "book antenatal care"; danger-sign list |
| P7 | Dengue danger signs | checklist | NIH wording; "go to hospital" |
| P8 | Ramadan pre-fast check for people with diabetes | simplified IDF-DAR | "See your doctor before Ramadan" |
| P9 | Heat-risk check (heat index) | temperature, humidity | Heat-stroke signs → emergency |
| P10 | Unit converter (sugar mg/dL↔mmol/L, °F↔°C, ft/in↔cm, lb↔kg) | — | No interpretation |

### 4.3 Later phases (from the research report)

- **Phase 2 Doctor:** WHO 2019 CVD chart (lab and non-lab), PREVENT as optional; HEART, GRACE, TIMI; Child-Pugh, MELD 3.0 (MELD-Na toggle); A-a gradient, P/F, S/F, free-water deficit, FENa/FEUrea; NIHSS, ABCD2; PHQ-9, GAD-7, EPDS; Mentzer index, WHO anaemia bands; shock index.
- **Phase 2 Public:** calorie needs (BMR/TDEE), PHQ-9/GAD-7 self-check with crisis screen, period calendar, child growth check, tobacco and naswar.
- **Phase 3:** SOFA-2, APACHE II, Phoenix; dosing helpers (paediatric mg/kg, insulin, TB) only with a formulary and a paediatric pharmacist; frailty, Revised Geneva.

Superseded scores (CHADS2, MDRD, MELD-Na, Pooled Cohort Equations) appear only as a toggle inside their replacement, with a "superseded by X (year)" chip, because local protocols and FCPS/MRCP syllabi still use them.

---

## 5. First-launch flow

```
Splash
  → "Who is using this app?"            first launch only
       ├─ Doctor / healthcare professional
       │    → Declaration sheet: "I am a registered healthcare professional.
       │      These tools support, not replace, clinical judgement."  [I confirm]
       │    → Doctor home
       └─ Common man / general public
            → Short disclaimer: "This app does not diagnose. In an emergency call 1122."  [OK]
            → Public home
```

Rules:
- Choices are stored on the phone (shared preferences). No account, nothing sent anywhere.
- Mode can be changed in Settings. Switching to Doctor shows the declaration again if it was never confirmed.
- The declaration is a label, not a barrier. Every Doctor tool must be safe to show to a layperson who taps through — this is the main reason dosing waits for Phase 3.
- Public users may open a Doctor tool from search only after the declaration; otherwise search shows Public tools only.

---

## 6. Screen designs

### S0 — Splash
Logo and app name; under 1 s; no network call.

### S2 — Mode selector
Two cards with an icon each: "Doctor / Healthcare professional" and "General public". One line under each saying what it contains.

### S3 — Declaration / disclaimer sheets
As in Section 5. Links to full terms and privacy policy (hosted page, also bundled offline).

### S4 — Home (per mode)
- Search bar (names plus common abbreviations and lay words: "egfr", "cha2", "sugar").
- Favourites row (star on any tool).
- Recently used (last 5, stored locally; cleared from Settings).
- Category grid. Doctor: Kidney, Heart, Acute care, Lab, Body, Mother & baby, Children, Liver, Dengue, Diabetes, Utilities. Public: Weight, Sugar, Blood pressure, Heart, Pregnancy, Dengue, Ramadan, Heat, Converter.

### S5 — Calculator screen (shared)
- Inputs from the tool definition: number fields with unit toggle, sliders only where precision doesn't matter, yes/no and choice chips for score items.
- Range checks reject impossible values with a message ("Creatinine 45 mg/dL is outside 0.1–20").
- Result updates live once all required inputs are valid; no "Calculate" button needed for formulas.

### S6 — Result panel
- **Doctor:** value with unit, band, guideline interpretation (wording from the source), points breakdown for scores, "Show formula" expander, citation, formula version, last-reviewed date.
- **Public:** one plain-language sentence, colour band **with a text label** (never colour alone), one next step, red-flag list, "15 out of 100 people like you" picture where the tool gives a risk.
- Both: "Not a diagnosis" footer; copy result as text (useful for notes).

### S7 — Red-flag screen (Public)
Full screen, red, "Go to hospital now / Call 1122", list of signs. Triggered by thresholds in P3, P4, P7, P9.

### S8 — Settings
Mode, units default, BMI standard, clear recents and favourites, privacy / ad choices (reopens the consent form), About.

### 6.1 Ads (AdMob, account homilabs.smc@gmail.com)
- **Placement:** one adaptive banner at the bottom of Home (S4) and Settings (S8) only.
- **Never** an ad on the calculator screen while entering values, on the result panel, on the red-flag screen (S7), or on the onboarding / declaration sheets — an ad must never sit next to or delay a medical result.
- **No interstitials** in release 1 (they interrupt clinical use). A rewarded or interstitial ad can be reconsidered later only at a natural break, with a cap.
- **Consent:** Google UMP consent form at first launch where required (UK and other regions with consent rules), reopenable from Settings. Non-personalised ads where consent is refused.
- **Ad content:** block sensitive categories in AdMob (pharmacy/prescription drugs, dating, gambling, "miracle cure" health) so no ad looks like medical advice.
- **IDs:** app `ca-app-pub-2087846699268567~1518498085` (AndroidManifest), banner `ca-app-pub-2087846699268567/7044101590` (`lib/app/config.dart`). Debug builds use Google's test banner ID; only release builds use the real unit. Never tap own live ads.
- **Sensitive-category blocking** in AdMob is account-wide (affects all HomiLabs apps) — not changed; waiting for Homi's decision.
- **Play:** "Contains ads" declared; Data safety lists the data the AdMob SDK collects (device / advertising ID, approximate location, app interactions).

### S9 — About
Disclaimer, list of sources per tool, licence credits, HomiLabs, app version and build.

---

## 7. Calculator engine

The correctness of the formulas is the product, so the engine is separate from the UI and fully unit-tested.

- **`lib/calc/`** — pure Dart, no Flutter imports. One file per calculator: a `CalcDefinition` (id, version, name and aliases, mode(s), inputs with units, ranges and defaults, citation, last-reviewed date, reviewer) and a pure `compute(inputs) → CalcResult` (value, band id, breakdown).
- **Bands and interpretation text** live in data (`assets/calc/<id>.json`), so wording can be corrected without touching maths and reviewed as text by a clinician.
- **Units:** values are converted to one internal unit at the edge (`lib/calc/units.dart`); formulas only ever see internal units.
- **Golden vectors:** `test/golden/<id>.json` holds cases with their source (paper's worked example, official calculator, or boundary value) and expected result. A single test runner loads every file; a calculator with no golden file fails CI.
- **Generic UI:** S5/S6 are built from the definition, so a new score needs a definition, a compute function, bands JSON and golden vectors — no new screen.
- **Register:** `docs/calculator-register.md` lists every tool with source, version, licence status, golden-vector count, reviewer and sign-off date. A tool ships only when its row is complete.

---

## 8. App structure (Flutter)

```
lib/
  main.dart
  app/            router.dart (go_router), theme.dart, l10n setup, config.dart
  calc/           definitions, compute functions, units, bands loader (pure Dart)
  features/
    onboarding/   mode selector, declaration
    home/         search, categories, favourites, recents
    calculator/   generic input form + result panel + red-flag screen
    settings/
    about/
  shared/         widgets (band chip, unit field, risk icon array)
assets/
  calc/           bands and interpretation text per tool
  who_growth/     WHO 2006 LMS tables
test/
  golden/         golden vectors per calculator
docs/
```

State: Riverpod; persistence: `shared_preferences` only (mode, units, favourites, recents). No database needed in release 1.

---

## 9. Validation process (every tool)

1. **Source check** — the developer pulls the primary source (derivation paper, guideline text or official calculator) and records the exact formula, coefficients, cut-offs and version in the register.
2. **Golden vectors** — at least: the source's worked examples, 3 cases checked on an official calculator, and boundary values at every cut-off and unit conversion. Extra cases for known error hotspots (MELD caps, Child-Pugh, when they arrive).
3. **Code + tests** — `flutter test` must pass; CI fails if any tool lacks golden vectors.
4. **Clinician review** — a clinician who didn't write the code checks the inputs, result and interpretation text against the source in the app, and signs off in the register.
5. **Plain-English check** — Public result text is tried with 5–8 non-medical users (include women and older users).
6. **Yearly guideline check** — the register is reviewed at least once a year for guideline changes.

Open items the research flagged before coding: WHO 2019 region chart for Pakistan; Pakistan Hypertension League 4th edition BP categories; BMI obesity cut-off (25 vs 27.5); IDF-DAR items and any 2026 update; Ramadan "see your doctor" timing; FIB-4 cut-off pairs; corrected sodium factor; Pakistani crisis helpline numbers (Phase 2).

---

## 10. Packages (pubspec.yaml, proposed)

| Package | Why |
|---|---|
| `flutter_riverpod` | State and DI (HomiLabs standard) |
| `go_router` | Navigation |
| `shared_preferences` | Mode, settings, favourites |
| `intl` | Number and date formats |
| `hijri` (or similar, to choose) | Hijri date for Ramadan tools, with ±1 day offset |
| `firebase_crashlytics` (optional, see 14.5) | Crash reports only |
| `google_mobile_ads` | AdMob banners (Section 6.1) |
| User Messaging Platform (bundled with `google_mobile_ads`) | Ad consent form |

No network use by the app itself; only the ad SDK (and Crashlytics, if chosen) go online.

---

## 11. Build phases (one piece at a time, verify, then next)

1. **Skeleton** — project, theme, onboarding flow, mode storage, empty homes. Check on a phone.
2. **Engine + first 5 tools** — engine, units (with the D28 lab converter, since every lab field depends on it), golden-vector runner, generic calculator screen; BMI, MAP, eGFR CKD-EPI 2021, Cockcroft-Gault, CHA2DS2-VA.
3. **Doctor batch A** — HAS-BLED, Wells/PERC, CURB-65, NEWS2, qSOFA, GCS, QTc, electrolytes, BSA/IBW.
4. **Doctor batch B (Pakistan)** — APRI/FIB-4, dengue, IDF-DAR Ramadan, HbA1c↔eAG, obstetric, paeds fluids, Parkland, WHO growth/MUAC, IMCI, drip rate.
5. **Public mode** — P1–P10 with plain-language results and the red-flag screen; plain-English user testing.
6. **Release prep** — About, sources, privacy policy page, store listing, screenshots, signing, Play declarations, `release-check.sh` style checks.

Each batch: source check → golden vectors → code → tests → device test → commit. Clinician review (Homi) of all tools after the last batch, before release.

---

## 12. Google Play requirements

- **Health apps declaration** in Play Console.
- Store description includes, word for word: "not a medical device and does not diagnose, treat, cure, or prevent any medical condition", plus a reminder to consult a healthcare professional.
- Privacy policy as a web page (not PDF), linked in the Console and inside the app.
- **Web pages on tools.homilabs.org** (Hostinger; Homi, 9 Nov): a new tool card on the home page `index.html`, plus its own folder like `lingo15/`, because a medical app with ads needs a fuller privacy policy and a medical disclaimer than the shared `privacy.html#slug` sections hold:
  - `https://tools.homilabs.org/medicalcalc/` — `index.html` (app page), `privacy.html`, `terms.html` (includes the medical disclaimer)
  - Source kept in this repo under `web/medicalcalc/`; written in Build Phase 6 and uploaded by Homi (or via the Hostinger file browser). Never touch other apps' folders or sections.
- Data safety form: no data collected by the app itself; declare AdMob SDK data (and Crashlytics if used). "Contains ads" = yes.
- Countries: all except the EU member states (L10). UK, Switzerland and Norway stay in, so the UMP consent form is needed.
- Target audience: adults (18+); nothing aimed at children.
- No account → no account-deletion requirement.
- Content rating questionnaire (medical reference).

---

## 13. Critique — risks to resolve

| Risk | Mitigation |
|---|---|
| A wrong formula harms a patient | Section 9; nothing ships without golden vectors + clinician sign-off |
| Public users treat a result as a diagnosis | Plain wording, "not a diagnosis" on every result, red-flag screen, no dosing |
| Pakistan's regulator (DRAP) issues software rules | Verifiable outputs, reference bands, no dosing; recheck DRAP before each release |
| EU treats risk-score calculators as Class IIa devices | Legal advice, or restrict the app to Pakistan / exclude the EU in Play (14.7) |
| Copyright claim on a questionnaire | Licence register; MMSE/MoCA excluded; credits in About |
| Ads look like medical advice or sit next to a result | Placement rules and blocked categories (Section 6.1) |
| Public text too technical | Plain-English test with non-medical users |
| Scope creep to 100+ tools | Release 1 list is fixed; new tools go through the register |
| Guideline changes (like CHA2DS2-VA) | Version and review date on every result; yearly check |

---

## 14. Decisions

### 14.1 Decided (Homi, 9 Nov 2026)

| # | Question | Decision |
|---|---|---|
| 14.2 | Clinical reviewer | **Homi reviews every calculator once the whole app is built** (9 Nov, replaces per-batch sign-off). Until signed off in `docs/calculator-register.md`, each result shows "Review pending"; no Play release before sign-off of every tool |
| 14.4 | Money | Free with AdMob ads, account homilabs.smc@gmail.com (L9, Section 6.1) |
| 14.6 | GCS commercial use | Follows from 14.4: email the GCS team (glasgowcomascale.org) before D11 ships |
| 14.7 | Countries | All except the EU (L10) |
| 14.12 | AdMob IDs | App "Medical Calc" (Android, not yet on a store): app ID `ca-app-pub-2087846699268567~1518498085`; banner unit "Home banner": `ca-app-pub-2087846699268567/7044101590` (created 9 Nov). Link the store listing in AdMob after the Play release |
| 14.9 | BMI obese cut-off | Asian cut-offs as built: overweight 23, obese 25 (Homi's review, 9 Nov) |
| 14.13 | Clinical review | All 38 tools reviewed and passed by Homi on 9 Nov 2026, with the open points in `docs/calculator-register.md` accepted as built (AHA/ACC 2025 BP categories, Hillier sodium headline, IDF-DAR 2026 with in-between totals in the higher band, WHO 2009/2012 dengue fluids) |
| 14.10 | Release 1 size | Full Section 4 list, in batches (L11); all 37 tools kept after review of the list, plus D28 lab converter = 38 (Homi, 9 Nov) |

### 14.2 Still open

| # | Question | Recommendation |
|---|---|---|
| 14.1 | **App name** | Keep "Medical Calc (working title)"; choose the real name before the store listing |
| 14.3 | **WHO chart region** for Pakistan | Resolved 9 Nov: South Asia (Kaptoge 2019 appendix 1 lists Pakistan under South Asia) |
| 14.5 | **Crashlytics**: include? | Yes — crash reports only, declared in Data safety; needs a Firebase project |
| 14.11 | **Reviewer's name** | Homi to give it |
