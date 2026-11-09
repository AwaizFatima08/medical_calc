# Clinician ("Doctor mode") calculators for a Pakistan-focused health calculator app

Research date: 9 Nov 2026. 16 web searches/fetches. Notes on sourcing: usage/popularity and guideline-status claims are cited. The per-calculator inputs/outputs in the master table are standard textbook definitions written from general medical knowledge. They are NOT individually sourced here and must be checked against the original derivation papers or MDCalc pages before coding. That is flagged in the Gaps sections.

## Q1. Which calculators are most used (MDCalc, Medscape, QxMD, surveys)?

### Takeaway
No public, whole-platform ranking of MDCalc (or Medscape/QxMD) calculator usage was found. The best hard data are: one peer-reviewed MDCalc page-view study (stroke tools only, 2016–2018), MDCalc's current "Trending" list, and GP surveys (France, UK, US). Together they point to a stable core: Cockcroft-Gault/CKD-EPI, MAP, CHA2DS2-VASc, HAS-BLED, NIHSS, Wells DVT/PE, ASCVD/QRISK-type CV risk, ABCD2 and CURB-65.

### Cited Findings
- JMIR Med Inform 2021 analysed MDCalc page views Jan 2016–Dec 2018. Of 454 calculators, 48 were stroke-related. The 5 most used stroke-related calculators were CHA2DS2-VASc, Mean Arterial Pressure, HAS-BLED, NIHSS and CHADS2. NIHSS grew fastest (+238.1% between first and last quarters). Most access was via web browser. — [Usage Patterns of Web-Based Stroke Calculators, JMIR Med Inform 2021 (PMC8369374)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8369374/)
- The same paper says MDCalc is used by more than 65% of US physicians monthly. — [PMC8369374](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8369374/)
- MDCalc homepage "Trending" list (fetched 9 Nov 2026), in order: Creatinine Clearance (Cockcroft-Gault); Weight-based Levothyroxine Dose (adults); CKD-EPI eGFR; Mean Arterial Pressure; SpO2/FiO2 ratio. MDCalc labels these "new and featured tools", so this is not a strict usage ranking. — [MDCalc homepage](https://www.mdcalc.com/)
- The MDCalc app listing claims 900+ calculators, scores and tools, and names Cockcroft-Gault and Wells' criteria among featured tools. This is promotional, not usage data. — [Similarweb MDCalc app listing](https://www.similarweb.com/app/apple/1001640662); [Similarweb Android](https://similarweb.com/app/google/com.mdaware.mdcalc)
- UK GP survey (2020 follow-up of a 2014 survey of 401 GPs): familiarity was highest for QRISK, ABCD(2), CHADS(-VASc), HAS-BLED and Wells DVT/PE. Use rose for QRISK (+31.2%), ABCD (+13.5%), CHADS (+54.6%), Wells DVT (+33.2%) and Wells PE (+43.6%). JBS calculator use fell 45.9%. — [BJGP Open, Oct 2020 (DOAJ)](https://doaj.org/article/717f39939c9f4fa388402a1ebd7d4659)
- French GP survey (2013): MMSE 95%, Fagerström 90%, Hamilton scale 65%, McIsaac 61%, CAGE/DETA 45%, osteoporosis SCORE 33%, CHADS2 28%. — [Int J Gen Med, Jun 2013 (DOAJ)](https://doaj.org/article/e3f2cf0ab71a45bbba1064a6cd5fa7ef)
- US qualitative study (2024, 20 outpatient physicians): more than 20 calculators were mentioned and ASCVD risk was the most common. Tools that are easy to reach, have simple inputs and are trusted get used more. Residents used more calculators, and used them more often, than attendings. — [Med Decis Making 2024 (IDEAS/RePEc)](https://ideas.repec.org/a/sae/medema/v44y2024i8p900-913.html); [PubMed 39377500](https://pubmed.ncbi.nlm.nih.gov/39377500/)

### Inferences
- Popularity tracks guideline embedding (CHA2DS2-VASc, Wells, QRISK/ASCVD rose as guidelines adopted them) and input simplicity. That favours bedside, few-input tools for a phone app.
- Renal function (CrCl/eGFR) and MAP are consistently top or near-top. They are simple formulas and should be the first screen of Doctor mode.

### Gaps
- No whole-platform MDCalc, Medscape or QxMD Calculate top-N ranking was found. MDCalc has not published one that search could surface. Ranking below Tier 1 is therefore expert judgement, not data.
- No usage data for Pakistani physicians specifically.

## Q2. Category-by-category list: what each does, inputs, output, endorsing guideline, specialty, popularity

### Takeaway
About 45 tools cover almost all common Doctor-mode needs. Guideline status changed for several of them in 2023–2025: CHA2DS2-VA (ESC 2024), PREVENT (AHA/ACC 2025 BP guideline), MELD 3.0 (OPTN 2023), SOFA-2 (JAMA 2025), Phoenix paediatric sepsis (2024) and CKD-EPI 2021 race-free. The app should ship the current versions and label older ones.

### Cited Findings (guideline status)
- **CHA2DS2-VA**: the ESC 2024 AF guideline removed the female-sex point. Anticoagulation is recommended at a score of 2 or more and considered at 1, regardless of sex. The change is Level of Evidence C (consensus). — [Wikipedia: CHA2DS2-VASc](https://en.wikipedia.org/wiki/CHA2DS2%E2%80%93VASc_score); [MDedge/Cardiology News](https://mdedge.com/cardiology/article/271567/arrhythmias-ep/goodbye-chadsvasc-sex-complicates-stroke-risk-scoring-af)
  - A critique found that after recalibration, 13.6% of women who had an ischaemic stroke scored 1 or less on CHA2DS2-VA. — [Acta Neurol Belg (Springer)](https://link.springer.com/article/10.1007/s13760-025-02916-7)
- **eGFR**: the 2021 CKD-EPI creatinine equation removes the Black-race coefficient (NKF-ASN Task Force). KDIGO 2024 recommends creatinine-based equations first, and the combined creatinine-cystatin C equation where eGFRcr is unreliable. — [Quest Diagnostics summary](https://www.questdiagnostics.com/healthcare-professionals/diagnostic-insights/articles/2022/new-guidelines-assessing-chronic-kidney-disease); [Tufts CKD-EPI equations page](https://www.tuftsmedicine.org/research-clinical-trials/research-institutes-research-specialty/chronic-kidney-disease-epidemiology-collaboration-ckd-epi/gfr-estimation/estimating-equations); [CCLM 2024 review](https://www.degruyterbrill.com/document/doi/10.1515/cclm-2024-1082/html)
- **PREVENT**: the 2025 AHA/ACC high blood pressure guideline replaces the Pooled Cohort Equations with PREVENT. PREVENT gives 10-year total CVD risk (ASCVD plus heart failure) from age 30. For stage 1 hypertension, drug therapy starts at a 10-year risk of 7.5% or more (the PCE threshold was 10%). — [ACC: New in Clinical Guidance, Oct 2025](https://www.acc.org/latest-in-cardiology/articles/2025/10/01/01/new-in-clinical-guidance-hbp); [Radcliffe Cardiology](https://www.radcliffecardiology.com/news/new-bp-guideline-adopts-prevent-risk-assessment); [TCTMD](https://www.tctmd.com/news/prevent-equations-bp-guidelines-means-better-treatment-accaha-say)
- **WHO CVD risk charts (2019, HEARTS)**: lab and non-lab regional versions exist. A population study found the non-lab model classifies people almost identically to the lab model. A rural Indian study found the non-lab charts had 86.5% sensitivity and 90.3% specificity against lab charts at a 5% cut-off. — [PMC8925162](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8925162/); [PMC9438460](https://pmc.ncbi.nlm.nih.gov/articles/PMC9438460)
  - Caution: in Sri Lankans, agreement between Framingham and WHO/ISH charts was poor. — [Authorea preprint on South Asian risk models](https://authorea.com/doi/full/10.22541/au.159318492.20249418)
- **GRACE**: the ESC 2023 ACS guideline uses GRACE above 140 as a high-risk feature favouring early invasive management, per summaries. MDCalc states the ESC 2023 and ACC/AHA 2025 ACS guidelines both use GRACE. — [PCR Online ESC 2023 ACS summary](https://www.pcronline.com/News/Congress-coverages/ESC/2023/2023-ESC-Guidelines-for-the-management-of-acute-coronary-syndromes); [MDCalc/Scholastica GRACE review](https://mdcalc.scholasticahq.com/article/145098-updated-grace-acs-risk-and-mortality-calculator)
- **HEART**: no ESC 2023 endorsement was found. A 2023 meta-analysis found GRACE and HEART both have low specificity for MACE, so they work better for rule-out. — [Arch Acad Emerg Med, Jul 2023 (DOAJ)](https://doaj.org/article/e348e78d1d104deaac242687050051e0)
- **qSOFA**: Surviving Sepsis Campaign 2021 makes a strong recommendation (moderate-quality evidence) against qSOFA as a single screening tool compared with SIRS, NEWS or MEWS. A positive qSOFA should still prompt concern for sepsis. — [SSC 2021, Evans et al. (PMC8486643)](https://pmc.ncbi.nlm.nih.gov/articles/8486643/); [Full text PDF](https://emcrit.org/wp-content/uploads/2022/02/Evans2021_Article_SurvivingSepsisCampaignInterna.pdf)
- **SOFA-2**: published in JAMA, 29 Oct 2025 (2025;334(23):2090–2103, doi 10.1001/jama.2025.20516). It keeps 6 organ systems (0–24) with revised variables and thresholds. AUROC for ICU mortality is 0.79 vs 0.77 for the original SOFA. It was derived from 3.34 million encounters in 1,319 ICUs across 9 countries. 40% of patients score lower than on original SOFA and 11% score higher. It is not yet validated outside the ICU. — [PubMed 41159833](https://pubmed.ncbi.nlm.nih.gov/41159833/); [ReachMD](https://reachmd.com/news/updated-sofa-2-score-enhances-measurement-of-organ-dysfunction-in-icu-patients/2484244/)
- **Phoenix Sepsis Score (paediatric)**: JAMA, Feb 2024. It replaces the 2005 SIRS-based criteria and scores respiratory, cardiovascular, coagulation and neurological systems. Sepsis is a score of 2 or more with suspected infection. Septic shock is sepsis plus 1 or more cardiovascular points. In-hospital mortality was 7.1% in higher-resource and 28.5% in lower-resource settings. It is not a screening tool and excludes neonates and preterm infants. — [SCCM blog](https://sccm.org/blog/sccm-task-force-develops-new-criteria-to-identify-pediatric-sepsis); [MDCalc/Scholastica review](https://mdcalc.scholasticahq.com/article/158895.pdf)
- **MELD 3.0**: OPTN adopted it in July 2023, replacing MELD-Na for adult and adolescent liver allocation. It adds female sex and albumin to address sex disparity. Simulation showed fewer waitlist deaths than MELD-Na (7,788 vs 7,850). — [PMC10363200](https://pmc.ncbi.nlm.nih.gov/articles/PMC10363200); [Healio 2024](https://cm.healio.com/news/hepatology/20241127/meld-30-reduces-sexbased-disparities-in-liver-transplant-access-waitlist-outcomes); [OPTN presentation 2022](https://optn.transplant.hrsa.gov/media/uq4bmlan/liver_meld_peld_1a_1b_presentation_winter-2022-pc.pdf)
- **CURB-65 / CRB-65 in Pakistan**: a prospective Aga Khan University (Karachi) study found CURB-65 classed 46% and CRB-65 24.8% of CAP patients as low risk. Both, especially CURB-65, identified reasonable numbers of patients who could be discharged from the ER. — [AKU Scholars](https://scholars.aku.edu/en/publications/prospective-comparison-of-prediction-rules-of-mortality-risk-for-)

### Master table (standard definitions, not individually sourced; verify each before coding)
Type: **F** = simple formula, **S** = multi-item score/checklist. **Lab?**: Y = needs a lab value, N = bedside only, (Y) = optional or one lab item.
Tier: **1** = ship in v1 (high use plus guideline-backed); **2** = v1 if feasible; **3** = later or specialist.

| Tier | Calculator | Category / specialty | Type | Lab? | Inputs | Output | Endorsing guideline / status |
|---|---|---|---|---|---|---|---|
| 1 | Cockcroft-Gault CrCl | Renal; all prescribers (drug dosing) | F | Y | age, weight (actual/ideal/adjusted), sex, serum creatinine | mL/min | still used for drug-dosing labels; MDCalc #1 trending |
| 1 | eGFR CKD-EPI 2021 (creatinine; + optional cr-cys) | Renal, GP, IM | F | Y | age, sex, creatinine (± cystatin C) | mL/min/1.73 m², CKD G stage | KDIGO 2024; NKF-ASN race-free |
| 1 | Mean arterial pressure | ICU, ED, anaesthesia | F | N | SBP, DBP | mmHg | top-5 MDCalc stroke-study usage |
| 1 | CHA2DS2-VA (with CHA2DS2-VASc toggle) | Cardiology, IM, GP | S | N | CHF, HTN, age, DM, stroke/TIA, vascular disease (± sex) | 0–8/9; OAC advice | ESC 2024 (VA); ACC/AHA 2023 still VASc |
| 1 | HAS-BLED | Cardiology | S | (Y) | HTN, abnormal renal/liver function, stroke, bleeding, labile INR, elderly, drugs/alcohol | 0–9; bleeding risk | ESC AF guidelines |
| 1 | Wells DVT | ED, IM | S | N | 10 clinical items | likely/unlikely | NICE NG158, ESC |
| 1 | Wells PE | ED, IM | S | N | 7 items | likely/unlikely (or 3-tier) | ESC 2019 PE, NICE |
| 1 | PERC rule | ED | S | N | 8 items incl. SpO2 | rule-out yes/no | ACEP |
| 1 | CURB-65 / CRB-65 | Pulmonary, IM, ED | S | (Y) CURB needs urea | confusion, urea, RR, BP, age ≥65 | 0–5; site of care | NICE CAP; validated at AKU Karachi |
| 1 | GCS | ED, neuro, ICU, trauma | S | N | eye, verbal, motor | 3–15 | universal |
| 1 | NEWS2 | Wards, ED | S | N | RR, SpO2 (scale 1/2), O2, SBP, HR, consciousness, temp | 0–20; escalation | RCP UK; SSC 2021 prefers over qSOFA alone |
| 1 | qSOFA (with SSC caveat) | ED, wards | S | N | RR ≥22, altered mentation, SBP ≤100 | 0–3 | Sepsis-3; SSC 2021: not as sole screen |
| 1 | Anion gap (± albumin-corrected) | ICU, IM, nephro | F | Y | Na, Cl, HCO3 (± albumin) | mEq/L | standard |
| 1 | Corrected calcium (albumin) | IM, onc, nephro | F | Y | Ca, albumin (g/dL or g/L) | mg/dL / mmol/L | widely used; ionised Ca preferred |
| 1 | Corrected sodium (hyperglycaemia) | ED, endo, ICU | F | Y | Na, glucose | mEq/L (Katz 1.6 / Hillier 2.4) | DKA/HHS protocols |
| 1 | Serum osmolality (calc) and osmolal gap | ICU, tox | F | Y | Na, glucose, urea/BUN (± measured osm, ethanol) | mOsm/kg | standard |
| 1 | QTc (Bazett, Fridericia, Framingham) | Cardiology, psych, all prescribers | F | N | QT, HR or RR | ms | Fridericia preferred at high HR |
| 1 | BMI, BSA (Mosteller), IBW (Devine), adjusted BW, lean BW | Nutrition, onc, pharmacy | F | N | height, weight, sex | kg/m², m², kg | standard; BSA used for chemo dosing |
| 1 | Gestational age / EDD (Naegele, by LMP or CRL/US) | Obstetrics, GP | F | N | LMP or US date and GA | EDD, current GA | ACOG/RCOG dating |
| 1 | Paediatric maintenance fluids (Holliday-Segar 4-2-1) | Paeds | F | N | weight | mL/h, mL/day | NICE NG29 notes isotonic fluids |
| 1 | Parkland burns fluid (+ TBSA Rule of 9s / Lund-Browder) | ED, surgery, burns | F | N | weight, %TBSA | mL in 24 h (half in 8 h) | ATLS/ABA |
| 1 | Unit converter (glucose, creatinine, urea/BUN, cholesterol, TG, Ca, Hb, bilirubin) | All | F | N | value and unit | converted value | Pakistani labs report in mixed units |
| 1 | Infusion / drip rate (mcg/kg/min ↔ mL/h; drops/min) | ICU, ED, nursing | F | N | dose, weight, concentration, drop factor | mL/h, gtt/min | standard |
| 2 | HEART score | ED, cardiology | S | Y (troponin) | history, ECG, age, risk factors, troponin | 0–10 | widely used; no ESC 2023 endorsement found |
| 2 | GRACE (ACS) | Cardiology | S | Y (creatinine, troponin) | age, HR, SBP, creatinine, Killip, arrest, ST deviation, enzymes | in-hospital / 6-mo mortality | ESC 2023 (>140 = high risk) |
| 2 | TIMI UA/NSTEMI | Cardiology | S | (Y) | 7 items | 0–7 | older; GRACE preferred by ESC |
| 2 | CV risk: WHO 2019 charts (lab and non-lab, South Asia) | GP, IM | S/F | non-lab N | age, sex, smoking, SBP, BMI or (cholesterol, diabetes) | 10-yr risk band | WHO HEARTS; best for Pakistan |
| 2 | CV risk: PREVENT | GP, cardiology | F | Y | age 30–79, sex, TC, HDL, SBP, BP Rx, DM, smoking, eGFR (± UACR, HbA1c, SDI) | 10/30-yr CVD, ASCVD, HF risk | AHA/ACC 2025 BP guideline (not calibrated for South Asians; see Q4) |
| 2 | Child-Pugh | Hepatology, GI, IM | S | Y | bilirubin, albumin, INR, ascites, encephalopathy | A/B/C | standard; drug labels use it |
| 2 | MELD 3.0 (and MELD-Na) | Hepatology | F | Y | bilirubin, INR, creatinine, Na, albumin, sex | score; 90-day mortality | OPTN 2023 |
| 2 | FIB-4 | Hepatology, GP, endo (MASLD) | F | Y | age, AST, ALT, platelets | <1.3 / 1.3–2.67 / >2.67 | AASLD/EASL MASLD guidance; HBV/HCV common in Pakistan |
| 2 | APRI | Hepatology (HCV) | F | Y | AST, AST ULN, platelets | ratio | WHO HCV/HBV guidelines for low-resource settings |
| 2 | A-a gradient / P/F ratio / S/F ratio | ICU, pulm | F | Y (ABG); S/F N | FiO2, PaO2, PaCO2, age, altitude; SpO2 | mmHg / ratio | S/F ratio is MDCalc-trending; useful without ABG |
| 2 | Free water deficit | ICU, nephro | F | Y | Na, weight, sex, age | litres | standard |
| 2 | FENa / FEUrea | Nephro, ICU | F | Y | urine and plasma Na/Cr (urea) | % | standard; FEUrea if on diuretics |
| 2 | Bishop score | Obstetrics | S | N | dilation, effacement, station, consistency, position | 0–13 | NICE induction guidance (NG207) |
| 2 | NIHSS | Neuro, ED | S | N | 11 items | 0–42 | AHA/ASA stroke; top-5 MDCalc stroke study |
| 2 | ABCD2 | Neuro, GP | S | N | age, BP, clinical features, duration, diabetes | 0–7 | NICE now advises against it for TIA triage (see Q3) |
| 2 | PHQ-9 / GAD-7 (validated Urdu versions exist) | Psych, GP | S | N | 9 / 7 items | severity bands | widely endorsed; check Urdu licence/validation |
| 2 | Paediatric weight-based dosing helper (mg/kg → dose, max cap) | Paeds | F | N | weight, mg/kg, frequency, max dose, formulation strength | mg, mL | high safety risk; formulary-backed only |
| 2 | WHO growth z-scores (WFA, HFA, WFH, BMI-for-age, MUAC) | Paeds, nutrition | F (LMS tables) | N | age, sex, weight, height | z-score, SAM/MAM | WHO 2006 standards; Pakistan NNS stunting/wasting |
| 3 | SOFA / SOFA-2 | ICU | S | Y (many) | 6 organ systems | 0–24 | SOFA-2 JAMA 2025 |
| 3 | APACHE II | ICU | S | Y (many) | 12 physiology items + age + chronic health | 0–71; mortality | older; heavy inputs |
| 3 | Phoenix Sepsis Score | PICU, paeds | S | Y | resp, CV, coag, neuro | ≥2 = sepsis | SCCM 2024 |
| 3 | Revised Geneva | ED | S | N | 8 items | probability | ESC PE alternative to Wells |
| 3 | HOMA-IR | Endo (research) | F | Y (fasting insulin) | fasting glucose, fasting insulin | index | not guideline-endorsed for diagnosis |
| 3 | Insulin helpers (total daily dose, correction factor 1800/1500, ICR 500 rule) | Endo | F | N | weight, TDD | units | high risk; show "guide only, individualise" |
| 3 | Clinical Frailty Scale (Rockwood) | Geriatrics, ICU triage | S (picture scale) | N | 1–9 description | category | NICE (COVID critical care) |
| 3 | BMR / energy needs (Mifflin-St Jeor, Harris-Benedict) | Nutrition | F | N | weight, height, age, sex, activity | kcal/day | ASPEN/ESPEN simple weight-based 25–30 kcal/kg alternative |
| 3 | MAP / pre-eclampsia helpers (BP-based) | Obstetrics | F | N | SBP, DBP | mmHg | flag ≥140/90 per ISSHP/ACOG |
| 3 | Pregnancy-safe dose and drug tools | — | — | — | — | — | out of scope for calculators |

### Inferences
- About 23 Tier-1 tools are almost all simple formulas or bedside scores. Only renal, electrolyte and unit-conversion tools need labs, and those labs are cheap. That fits a low-resource market.
- Unit conversion should be built in everywhere, not just as a standalone tool. Pakistani labs report in mixed units (glucose mg/dL is common, creatinine mg/dL, some private labs SI), so every lab input needs a unit toggle.

### Gaps
- Exact coefficients (CKD-EPI 2021, MELD 3.0, PREVENT, SOFA-2 thresholds, Phoenix) were not pulled from primary texts in this pass. Implement only from the primary papers or official calculators: KDIGO/NKF, OPTN, the AHA PREVENT online tool or the R/SAS package, JAMA supplements.
- Medscape and QxMD Calculate catalogue and usage data were not retrieved.
- Licensing: PHQ-9 and GAD-7 are free to use. NIHSS and GCS are free, but the GCS team asks for standardised wording. Licensing for the Urdu validated versions was not checked.

## Q3. Which calculators are outdated or superseded and should be avoided or labelled?

### Takeaway
Avoid or clearly label: MDRD and race-based CKD-EPI 2009, CHADS2, Pooled Cohort Equations as the primary US tool (now PREVENT), MELD and MELD-Na (now MELD 3.0 for allocation), qSOFA as a lone sepsis screen, SIRS-based paediatric sepsis (now Phoenix), and possibly original SOFA as SOFA-2 is adopted.

### Cited Findings
- The 2021 CKD-EPI equation removed the race coefficient. Race should not be in GFR equations (NKF-ASN). KDIGO 2024 recommends validated creatinine equations with cystatin C as a complement. — [Quest Diagnostics](https://www.questdiagnostics.com/healthcare-professionals/diagnostic-insights/articles/2022/new-guidelines-assessing-chronic-kidney-disease); [CCLM 2024](https://www.degruyterbrill.com/document/doi/10.1515/cclm-2024-1082/html)
- CHADS2 was still among the top 5 MDCalc stroke tools in 2016–2018. — [PMC8369374](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8369374/). ESC has since moved to CHA2DS2-VA (2024). — [MDedge](https://mdedge.com/cardiology/article/271567/arrhythmias-ep/goodbye-chadsvasc-sex-complicates-stroke-risk-scoring-af)
- PCE has been replaced by PREVENT in the 2025 AHA/ACC BP guideline. — [ACC](https://www.acc.org/latest-in-cardiology/articles/2025/10/01/01/new-in-clinical-guidance-hbp)
- MELD-Na has been replaced by MELD 3.0 for US allocation (July 2023). — [PMC10363200](https://pmc.ncbi.nlm.nih.gov/articles/PMC10363200)
- SSC 2021 recommends against qSOFA as a single screening tool. — [PMC8486643](https://pmc.ncbi.nlm.nih.gov/articles/8486643/)
- Paediatric SIRS-based (2005) sepsis criteria are replaced by Phoenix (2024). — [SCCM](https://sccm.org/blog/sccm-task-force-develops-new-criteria-to-identify-pediatric-sepsis)
- Original SOFA has been unchanged for 30 years, and SOFA-2 now exists. — [PubMed 41159833](https://pubmed.ncbi.nlm.nih.gov/41159833/)
- The UK GP survey showed declining use of the JBS calculator (−45.9%). — [BJGP Open 2020](https://doaj.org/article/717f39939c9f4fa388402a1ebd7d4659)

### Inferences
- The app should show a "superseded by X (year)" chip rather than silently drop older scores. Clinicians in Pakistan may still see CHA2DS2-VASc, MELD-Na or ASCVD in local protocols and exam syllabi (FCPS/MRCP), so keep them as a toggle inside the newer tool.
- The ACC/AHA 2023 AF guideline still uses CHA2DS2-VASc. Offer both with a toggle, defaulting to CHA2DS2-VA.

### Gaps
- NICE's position on ABCD2 (NICE NG128, 2019, advises against risk scores to triage suspected TIA) is from memory and was not re-verified in this pass.
- MDRD: no specific "withdrawn" statement was retrieved, but KDIGO uses CKD-EPI. Verify before writing a public note.
- Whether Pakistani bodies (PSN, PCS) formally adopt CKD-EPI 2021, CHA2DS2-VA or PREVENT was not found.

## Q4. Which are most useful in a low-resource / Pakistani hospital setting (limited labs)?

### Takeaway
Prioritise bedside, no-lab tools: NEWS2, GCS, CRB-65, Wells/PERC, CHA2DS2-VA, MAP, S/F ratio, Holliday-Segar, Parkland, WHO non-lab CVD charts and WHO growth z-scores. Add cheap-lab tools (creatinine → CrCl/eGFR, electrolytes, APRI/FIB-4 for the large hepatitis B/C burden). PREVENT and SOFA-2 are lower priority: they need many labs and have not been validated in South Asians or outside the ICU.

### Cited Findings
- The WHO 2019 non-lab CVD charts classify almost identically to the lab charts and were judged suitable for resource-limited settings in India. — [PMC8925162](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8925162/); [PMC9438460](https://pmc.ncbi.nlm.nih.gov/articles/PMC9438460)
- Older WHO/ISH charts placed Pakistan in the EMR-D sub-region, not South Asia. Confirm which 2019 region chart applies to Pakistan. — [WHO/ISH simplified tools (NCBI Bookshelf)](https://ncbi.nlm.nih.gov/books/NBK148602/bin/simplifiedtools-m2.pdf)
- SOFA relies on labs often unavailable in low-resource settings. NEWS2 has been studied as an alternative for sepsis screening. — [J Glob Antimicrob Resist, Dec 2024 (DOAJ)](https://doaj.org/article/8021e9efbdff469390a52d86878bd014)
- qSOFA's usefulness in LMICs is not well established, per an AKU Karachi COVID-19 study. — [BMC Infect Dis 2022, s12879-022-07535-8](https://link.springer.com/10.1186/s12879-022-07535-8)
- CRB-65 (no urea needed) and CURB-65 were prospectively evaluated at AKU Karachi. — [AKU Scholars](https://scholars.aku.edu/en/publications/prospective-comparison-of-prediction-rules-of-mortality-risk-for-)
- Phoenix in-hospital mortality was 28.5% in lower-resource settings vs 7.1% in higher-resource settings. The score was designed with LMIC data. — [SCCM](https://sccm.org/blog/sccm-task-force-develops-new-criteria-to-identify-pediatric-sepsis)
- In a large CAP cohort, qSOFA parameters had prognostic accuracy similar to CRB, but the ≥2 cut-off lacked sensitivity. The authors suggest adding age ≥65. — [TU Dresden / ERS](https://fis.tu-dresden.de/portal/en/publications/validation-of-the-qsofa-score-compared-to-the-crb65-score-for-risk-prediction-in-communityacquired-pneumonia(3d327cf7-0271-441d-b444-49eff867a4cd).html)

### Inferences
- PREVENT was derived in US cohorts. Its inputs (UACR, HbA1c, US social deprivation index) are often missing or don't apply in Pakistan, so the WHO South Asia/EMR chart should be the default CV risk tool, with PREVENT as an optional "US guideline" tool.
- Pakistan has one of the highest HCV burdens globally (not re-sourced here), so APRI and FIB-4 are higher value locally than their MDCalc ranking suggests.
- Paediatric tools matter more in Pakistan's case mix: WHO z-scores, Holliday-Segar, weight-based dosing, Parkland, Phoenix. High stunting and wasting rates and high under-5 mortality are well documented but were not re-sourced in this pass.
- Offline use, an Urdu UI, mg/dL defaults and a clear "decision support, not a substitute for judgement" disclaimer are design requirements, not calculators.

### Gaps
- No Pakistani validation of NEWS2, HEART or WHO 2019 charts was found.
- No Pakistani survey of which calculators doctors use. A quick survey of local doctor contacts or Facebook groups would fill this.
- Pakistan HCV prevalence and NNS 2018 stunting/wasting figures need sourcing if the report cites them.
