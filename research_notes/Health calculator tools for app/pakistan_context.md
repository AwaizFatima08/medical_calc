# Pakistan context: disease burden, local guidelines, units and competing apps for a health calculator app

Research date: 9 Nov 2026. Search-based. Many figures come from press reports of primary sources, and these are flagged. Primary documents worth opening before building: IDF Atlas country page, NNS 2018 Key Findings PDF, PHL 4th guideline (JPMA Aug 2023 supplement), NIH/CDC dengue advisory 2025, and the IDF-DAR 2021 guidelines.

## Q1. Prevalence and burden in Pakistan (latest figures)

### Takeaway
Pakistan's disease burden is a double one. NCDs are very high: diabetes is about 31% of adults, the highest prevalence in the world, and hypertension, CKD and obesity (on Asian BMI cut-offs) are high too. Communicable, maternal and child problems remain heavy: about 40% of children are stunted and 18% wasted, about 42% of women are anaemic, HCV is the largest absolute burden in the world, TB is about 260 per 100,000, and dengue rises every year. Heat stroke is a recurring summer emergency.

### Cited Findings
**Diabetes**
- IDF Diabetes Atlas 11th ed. (2025, data year 2024): adult (20–79) age-standardised diabetes prevalence 31.4%, about 34.5 million adults. Highest prevalence in the world and 4th highest absolute number. Projection for 2050 is 70.2 million — [IDF Atlas Pakistan page](https://diabetesatlas.org/data-by-location/country/pakistan); [The News](https://thenews.com.pk/print/1299445-pakistan-ranks-first-globally-in-diabetes-prevalence)
- Some outlets report 30.8%, which looks like a secondary-reporting discrepancy. The IDF page gives 31.4% — [ProPakistani](https://propakistani.pk/2025/04/09/pakistan-tops-global-diabetes-rankings/)
- About 9.3 million undiagnosed, and about 230,000 diabetes-related deaths a year (press, citing the Atlas) — [Pak Observer](https://pakobserver.net/idf-report-reveals-diabetes-prevalence-in-pakistan/); [Bol News](https://www.bolnews.com/latest-news/pakistan-records-worlds-highest-diabetes-rate-in-2025/)

**Hypertension / NCDs**
- There is no recent nationally representative figure. A WHO STEPS survey 2013–14 (Sindh and Punjab) found hypertension in 53%. A Lahore study found 40.1%. KP lists hypertension as its most common NCD (29.2%) — [EMHJ 2022, NCD burden in Pakistan](https://www.emro.who.int/emhj-volume-28-2022/volume-28-issue-11/burden-of-noncommunicable-diseases-in-pakistan.html); [APP](https://www.app.com.pk/?p=942127)

**CKD**
- Karachi community study (AKU): CKD prevalence 12.5% (95% CI 11.4–13.8), and 74.4% of people with CKD were also hypertensive — [BMC Research Notes / Springer](https://link.springer.com/article/10.1186/1756-0500-7-179); [PMC3972995](https://pmc.ncbi.nlm.nih.gov/articles/PMC3972995/)
- In rural South Asia, CKD was found in 16.9% of hypertensive adults in Pakistan — [Duke Scholars](https://scholars.duke.edu/publication/1331097)

**Obesity**
- National Health Survey 1990–94 using Asian cut-offs (overweight ≥23, obese ≥27): about 25% overweight or obese, 10.3% obese. Even lower cut-offs may better predict hypertension and diabetes risk — [CMAJ/PMC1609152](https://pmc.ncbi.nlm.nih.gov/articles/PMC1609152); [AKU eCommons](https://ecommons.aku.edu/pakistan_fhs_mc_chs_chs/635)
- A survey presented at a Pakistan Endocrine Society conference (2018, press report) used South Asian bands (23–27.5 overweight, 27.5–32.5 obesity class I): 29% overweight, 31% class I, 13% class II, 7% class III. The methods are unverified — [FoodNavigator Asia](https://www.foodnavigator-asia.com/Article/2018/05/16/Half-of-Pakistan-s-population-found-to-be-obese-and-facing-high-diabetes-risk)

**Maternal health**
- MMR 155 per 100,000 live births (UN inter-agency estimate, 2023), about 11,000 maternal deaths, about 4.1% of global deaths. Leading causes: PPH, hypertensive disorders (pre-eclampsia/eclampsia), sepsis — [The News](https://thenews.com.pk/amp/1298129-pakistan-among-four-nations-driving-half-of-global-maternal-deaths-in-2023-un-report)
- WHO statement: MMR fell from 276 (2006) to 155 — [TNN](https://tnnenglish.com/who-raises-alarm-over-maternal-and-newborn-deaths-in-pakistan-calls-for-urgent-action)
- PDHS 2017-18: about half of women had 4+ ANC visits (37% in 2012-13). In Sindh, 54.1% had 4+ visits — [Express Tribune](https://tribune.com.pk/story/1918319/entertainment); [Dawn](https://www.dawn.com/news/1434119)
- Anaemia in pregnancy: local estimates of "up to 70%" (an upper bound, not a national survey) — [Dawn "Mothers at risk"](https://www.dawn.com/news/2009614)

**Child malnutrition and anaemia (NNS 2018)**
- Stunting 40.2% (severe 19.6%). Balochistan 46.6%, Sindh 45.5%. Wasting 17.7%, the highest ever recorded nationally — [NNS 2018 Key Findings (UNICEF)](https://www.unicef.org/pakistan/media/1871/file/KeyFindings-NationalNutritionSurvey2018.pdf); [Dawn](https://www.dawn.com/news/1493318)
- Anaemia: 53.7% of children under 5 and 42.7% of women of reproductive age (NNS 2018) — [MDPI Nutrients 2023 / PMC10421143](https://pmc.ncbi.nlm.nih.gov/articles/PMC10421143)
- WHO modelled estimates are different: stunting 36.7%, wasting 7.1% (2018). The national survey is the preferred source — [WHO EMRO](https://applications.emro.who.int/docs/WHOEMNUT302E-eng.pdf)

**Hepatitis B/C**
- WHO Global Hepatitis Report 2024: Pakistan has the highest number of HCV infections in the world, about 8.8 million. Unsafe injections cause 44% of new HCV infections — [Arab News](https://www.arabnews.com/node/2494516/pakistan)
- JPMA commentary: HCV prevalence 7.5% (modelled adult 7.7%, 2022), about 19,000 deaths a year. The PM's Hepatitis C Elimination Programme was launched on 29 Jul 2024 (PKR 68.25 bn) — [JPMA](https://www.jpma.org.pk/index.php/public_html/article/view/22824/3866)
- A local physician quoted a figure of 4.8%, which conflicts with the WHO-based estimates — [ProPakistani](https://propakistani.pk/2024/04/17/pakistan-has-the-highest-number-of-hepatitis-c-infections-in-the-world-who/)

**TB**
- WHO country profile 2022: 608,000 incident cases, 258 per 100,000 (189–350) — [WHO TB profile via AIDS Data Hub](https://www.aidsdatahub.org/sites/default/files/resource/pakistan-tb-profile-2022.pdf)
- World Bank/WHO series: 266 per 100,000 in 2024 (aggregator) — [Statistics of the World](https://statisticsoftheworld.com/country/pakistan/WHO.TB_INCIDENCE)

**Dengue**
- National confirmed cases: 21,016 (2023), 24,182 (2024), 33,394 (2025) — [Dawn](https://www.dawn.com/news/1983155)

**Heat stroke (Karachi, June–July 2024)**
- The official Sindh toll was about 49–60 heat-related deaths. Advocacy and media estimates were 500–600, and the true number is disputed. Hospitals reported dozens of heat-stroke deaths over 10 days — [Geo](https://www.geo.tv/latest/552084-heatwave-death-toll-climbs-to-49-as-four-more-die-in-karachi); [Express Tribune "Doubts linger"](https://tribune.com.pk/story/2482071/entertainment); [Times of Oman](https://timesofoman.com/article/148148-pakistan-over-500-dead-in-last-month-in-karachi-due-to-severe-heatwave); [Dawn](https://www.dawn.com/news/1846538)

**Diarrhoea / ORS**
- ORS use in childhood diarrhoea in Sindh rose from 45.2% to 52% (PDHS, provincial) — [Dawn](https://www.dawn.com/news/1434119)

**Tobacco / naswar**
- GATS Pakistan 2014: smokeless tobacco 7.7% of adults (11.4% of men, 3.7% of women), over 9.6 million users. Naswar is the most common product, followed by paan/gutka — [PMC7733056](https://pmc.ncbi.nlm.nih.gov/articles/PMC7733056); [PMC5503251](https://pmc.ncbi.nlm.nih.gov/articles/PMC5503251)
- Semi-urban Islamabad: 16.0% use smokeless tobacco (men 21.6%) — [EMHJ 2014](https://www.emro.who.int/emhj-vol-20-2014/volume-20-6/smokeless-tobacco-consumption-in-a-multi-ethnic-community-in-pakistan-a-cross-sectional-study.html)

### Inferences (problem → calculator mapping, ranked by burden × fit for each mode)
1. **Diabetes, the top priority.** Doctor mode: HbA1c↔eAG converter, insulin dose/correction-factor and carb tools, IDF-DAR Ramadan risk score, DKA fluid/potassium helper. Public mode: diabetes risk score (an Asian/Indian-type risk score; no Pakistan-validated one found), glucose unit converter, Ramadan pre-fast risk check.
2. **Hypertension/CVD.** BP classification per PHL; CV risk (WHO/ISH 2019 risk charts, South Asia region, are the most applicable; Framingham/ASCVD/QRISK3 overestimate or are not calibrated for Pakistan). QRISK3 does include a "Pakistani" ethnicity option, which is useful for doctors.
3. **CKD.** eGFR (CKD-EPI 2021, plus Schwartz for children), creatinine clearance (Cockcroft-Gault) for drug dosing, KDIGO staging with ACR in mg/mmol or mg/g.
4. **Maternal.** EDD/gestational age (Naegele, plus ultrasound dating), pregnancy anaemia (Hb <11 g/dL) and iron deficit (Ganzoni), pre-eclampsia risk factors / MAP, Bishop score, PPH blood-loss / shock index, weight gain by BMI category.
5. **Child nutrition.** WHO 2006 weight-for-height/length, height-for-age and BMI-for-age z-scores; MUAC tape bands (<11.5 cm SAM, 11.5–12.5 MAM, 6–59 months); RUTF dosing; paediatric drug-dose-by-weight; growth charts. Very high relevance given 40% stunting and 18% wasting.
6. **Anaemia.** Hb classification by WHO age/sex/pregnancy cut-offs (with altitude/smoking adjustment), MCV-based work-up, Mentzer index (thalassaemia trait is common in Pakistan; no prevalence figure found in this search).
7. **Hepatitis.** APRI and FIB-4 (validated in Pakistani HCV cohorts; see Q2), Child-Pugh, MELD-Na.
8. **Dengue.** WHO 2009 classification with warning signs, critical-phase day counter, hematocrit-rise tracker, fluid-rate calculator (crystalloid mL/kg/h by ideal body weight), plus a public "danger signs → go to hospital" checklist.
9. **Diarrhoea/dehydration.** WHO IMCI dehydration assessment (no/some/severe), Plan A/B/C ORS volumes (Plan B: 75 mL/kg over 4 h), zinc dosing, maintenance fluid (Holliday-Segar).
10. **Heat stroke.** Heat index / heat-risk checker for the public; a clinician cooling checklist.
11. **TB.** Weight-band dosing for adult and child FDC regimens (per NTP Pakistan); a symptom-screen checklist.
12. **Tobacco.** Pack-years, plus a smokeless/naswar "tins per week" exposure field (no standard naswar index found).
- Obesity: BMI with Asian cut-offs (23 / 27.5) and waist cut-offs. Calculator choice must expose both the WHO-international and Asian bands.

### Gaps
- No recent nationally representative hypertension prevalence was found (the National Diabetes Survey of Pakistan 2016–17 and NHSP data were not retrieved).
- No national pre-eclampsia prevalence figure was found.
- No hepatitis B national prevalence (often cited as about 2.5% from the 2007–08 survey, but not verified here).
- The national ORS-use figure from PDHS 2017-18 was not retrieved. No under-5 diarrhoea mortality figure.
- No newer GATS than 2014 was found.
- No GBD/IHME Pakistan top-causes ranking was retrieved in this session.
- Thalassaemia trait prevalence was not searched.

## Q2. Pakistani or regional guidelines the app must follow

### Takeaway
Pakistan has its own hypertension guideline (PHL, 4th edition 2023 in JPMA) and NIH/CDC dengue advisories that broadly follow WHO 2009. For most other areas, Pakistani practice follows international guidelines (ADA/IDF, KDIGO, WHO IMCI, WHO growth standards), plus the IDF-DAR Ramadan guidelines. Asian BMI cut-offs are widely used locally.

### Cited Findings
- **Pakistan Hypertension League:** 3rd National Hypertension Guideline (2018), PDF on phlpk.org. A 4th edition was endorsed in 2022 and published as a JPMA supplement in Aug 2023. The specific BP targets could not be read from the snippet — [PHL 2018 PDF](https://phlpk.org/wp-content/uploads/2022/09/3rd-Hypertension-Guideline-2018-PHL.pdf); [JPMA issue](https://jpma.org.pk/index.php/public_html/issue/view/57/8)
- **Dengue (NIH/CDC Islamabad advisory, Mar 2025):** warning signs are severe abdominal pain, persistent vomiting, fall from fever to hypothermia, bleeding, altered mental status and falling platelets. Early shock signs are restlessness, cold clammy skin, rapid weak pulse and narrowing pulse pressure, and these require hospital referral. Hematocrit must be interpreted alongside vitals and haemodynamics when judging fluid adequacy — [NHSRC Advisory 2025](https://nhsrc.gov.pk/SiteImage/Downloads/Advisory-Dengue%20Fever-2025%20(March%202025).docx); [NHSRC advisory PDF](https://nhsrc.gov.pk/SiteImage/Misc/files/Advisory%20for%20the%20Prevention%20and%20Control%20of%20Oengue%20Fever.pdf)
- The April 2024 advisory covers oral fluids at home and home isolation for mild illness, says corticosteroids have no proven benefit, and sends patients to hospital for danger signs (the index text was partly garbled) — [NHSRC](https://nhsrc.gov.pk/SiteImage/Misc/files/Advisory%20for%20the%20Prevention%20and%20Control%20of%20Oengue%20Fever.pdf)
- A newer CDC-NIH advisory calls for standardised clinical case-management protocols — [Dawn](https://www.dawn.com/news/1983155)
- Pakistani hospital protocol example: BKMC/MTI Swabi dengue clinical case management (2024) — [BKMC PDF](https://bkmcs.edu.pk/wp-content/uploads/2024/04/Dengue-Clinical-Case-Managment-BKMC-MTI-Swabi.pdf)
- Pakistani dengue studies use WHO 2009 classification (Rawalpindi 2024 cohort, Islamabad 2019) — [IJMS](https://ijms.pitt.edu/IJMS/article/download/4012/3248/41599); [PMC8577943](https://rcastoragev2.blob.core.windows.net/9155e69fbfb13b1f9991864d524d8e77/PMC8577943.pdf)
- **IDF-DAR Ramadan risk calculator (2021):** score 0–3 = low risk, 3.5–6 = moderate, >6 = high. A 2026 update reportedly keeps the same categories and thresholds (Thieme 2025/26 article; verify) — [Thieme](https://thieme-connect.de/products/ejournals/html/10.1055/s-0045-1813010); [Sanofi Campus risk-calculation tool](https://www.campus.sanofi/qa/patient-support/diabetes/tools-and-resources/pre-ramadan-assessment-and-risk-calculation)
- Validation: in a 2021 Ramadan study (n=659), hypoglycaemia rose from about 6% in low-risk to about 35% in high-risk patients. In Bahrain (2023, n=757) the main drivers were T1D, prior hypoglycaemia, renal impairment and a poor previous Ramadan. One 2022 study judged the score conservative — [PMC9969239](https://pmc.ncbi.nlm.nih.gov/articles/PMC9969239); [PubMed 36989583](https://pubmed.ncbi.nlm.nih.gov/36989583)
- Bangladesh (regional comparator): about 61% of fasting T2D patients were high-risk — [Banglajol](https://www.banglajol.info/index.php/JACEDB/article/download/87008/57164/243307)
- **Liver fibrosis scores validated in Pakistani HCV patients:** Liaquat University 2009 (biopsy, n=158): APRI <1 ruled out advanced fibrosis in about 70%, FIB-4 <1.45 in about 74%. APRI >1 and FIB-4 predicted advanced fibrosis in 87% and 98% respectively — [JCPSP 2009](https://jcpsp.pk/archive/2009/Aug2009/04.pdf)
- Karachi (FibroScan comparison, n=250): FIB-4 AUC 0.994 vs APRI 0.866 — [The Professional Med J](https://theprofesional.com/index.php/tpmj/article/view/8915)
- Karachi 2020: in indeterminate APRI (0.5–2), adding FIB-4 is a low-cost strategy — [J Family Med Prim Care / DOAJ](https://doaj.org/article/11274de5ea5d4b11bfcc2472af6dbcd4)
- In ESRD/dialysis patients (mostly HCV), APRI was more accurate than FIB-4 — [J Transl Intern Med 2018](https://www.degruyterbrill.com/document/doi/10.2478/jtim-2018-0008/html)
- **Asian BMI cut-offs** are used in Pakistani research and by the Pakistan Endocrine Society (23 / 27.5) — [FoodNavigator Asia](https://www.foodnavigator-asia.com/Article/2018/05/16/Half-of-Pakistan-s-population-found-to-be-obese-and-facing-high-diabetes-risk); [CMAJ](https://www.cmaj.ca/node/8931.full.print)

### Inferences
- Dengue module: follow WHO 2009 (probable dengue → warning signs → severe dengue) with the NIH danger-sign list verbatim. Fluid calculators should follow the WHO 2009/2012 handbook regimens (5–7 mL/kg/h tapering), because no Pakistan-specific mL/kg table was found.
- Ramadan module: this is a strong differentiator. Implement the IDF-DAR 2021 scoring items exactly, with the published 0–3 / 3.5–6 / >6 bands, and show the "verify against current IDF-DAR edition" date.
- Hypertension: implement PHL 4th-edition categories once the JPMA supplement has been read. Until then, mirror ISH 2020 (the likely basis; unverified).
- Liver: provide APRI (cut-offs 0.5/1.0/1.5/2.0) and FIB-4 (1.45 / 3.25), and note that APRI may perform better in dialysis patients.

### Gaps
- No Pakistan Society of Nephrology guideline or eGFR-equation recommendation was found. It is not known whether Pakistani labs report CKD-EPI 2009, 2021 or MDRD eGFR.
- Diabetic Association of Pakistan and Pakistan Endocrine Society diabetes guidelines (e.g. targets, insulin titration) were not retrieved.
- The PHL BP targets themselves were not extracted.
- No national dengue clinical-management guideline with a fluid table was retrieved, only advisories.
- No NTP Pakistan weight-band TB dosing table was retrieved.
- No Pakistan-specific diabetics-who-fast percentage was found (EPIDIAR-type data were not retrieved).

## Q3. Units and calendar needs

### Takeaway
Pakistani lab reports use conventional US-style units: glucose in mg/dL, creatinine in mg/dL, HbA1c in %, Hb in g/dL. The app should default to these and offer SI conversion for doctors trained or working abroad (UK/Gulf). Hijri calendar support is needed for Ramadan features.

### Cited Findings
- Chughtai-style (major Pakistani lab chain) reports: HbA1c in % (normal <5.7, pre-diabetes 5.7–6.4, diabetes >6.4). Creatinine reported in mg/dL (e.g. 0.55–1.02 mg/dL female range). These are examples from uploaded reports, not an official table — [Scribd report example](https://www.scribd.com/document/684403729/Report-Viewer); [Scribd](https://www.scribd.com/document/756274432/Report-Viewer)
- Chughtai Lab diabetes testing overview — [Chughtai Lab](https://chughtailab.com/everything-you-need-to-know-about-diabetes-medical-tests-and-procedures-at-chughtai-lab/)
- Reference intervals vary between labs — [Scribd normal range sheet](https://www.scribd.com/document/1061969484/Lab-Normal-Reference-Ranges-1)

### Inferences
- Defaults: glucose mg/dL (mmol/L toggle, factor 18), creatinine mg/dL (µmol/L toggle, ×88.4), urea/BUN mg/dL, Hb g/dL, HbA1c % (with IFCC mmol/mol toggle), cholesterol mg/dL, platelets ×10^3/µL (dengue), weight kg, height in feet+inches and cm (public users commonly state height in feet/inches; no survey source found, this is general knowledge).
- Calendar: Gregorian for EDD and vaccines, plus a Hijri display (Umm al-Qura or a local moon-sighting offset of ±1 day, since Pakistan's Ruet-e-Hilal Committee decides moon sighting) for the Ramadan module.
- Temperature in °F is common in Pakistani households for fever (general knowledge, unsourced), so the public mode should accept °F.

### Gaps
- No authoritative source found on which units every major Pakistani lab (Chughtai, Excel, AKU, Shaukat Khanum, IDC) uses, or on which eGFR equation they print.
- No source on Pakistani preference for feet/inches vs cm or °F vs °C.

## Q4. Competing apps in Pakistan and the gaps they leave

### Takeaway
Pakistani doctors and students rely on international references (Medscape is the most used named app in student surveys). Local platforms (Marham, oladoc, Sehat Kahani) are telemedicine and booking services, not clinical calculators. No Urdu, offline, Pakistan-guideline calculator app turned up in this search.

### Cited Findings
- CMH Lahore survey (2023, n=357 students): Medscape was the most used app (29.3%), then Gray's Anatomy (25%) and Pharmapedia (23.9%, a Pakistani drug-reference app) — [Journal of Aziz Fatimah / DOAJ](https://doaj.org/article/e2d2743f249341ee91268517188b3f31)
- AKU clinical-year students: 54% use apps to look up disease criteria and about 42% for drug searches. Only 39% feel their colleges encourage app use. Barriers are no institutional subscriptions and not knowing how to use the apps — [PMC10413307](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10413307/); [AKU scholars](https://scholars.aku.edu/en/publications/usage-and-types-of-mobile-medical-applications-amongst-medical-st/)
- 2019 student study: Medscape was used by 31.7% — [PMC6500810](https://pmc.ncbi.nlm.nih.gov/articles/PMC6500810)
- Marham (founded 2015, Lahore): doctor search, booking, online consultation — [CB Insights](https://www.cbinsights.com/company/marham)
- oladoc (formerly Mydoctor.pk, 2016, Lahore): appointment booking — [CB Insights compare](https://www.cbinsights.com/compare/marham-vs-oladoc)
- Sehat Kahani (2017): telemedicine with a female doctor network. A 2025 MoU with the Ministry of Health and 10 more telemedicine centres were announced in Nov 2025 — [APP](https://www.app.com.pk/?p=1302726); [Together Prize](https://wearetogetherprize.com/sehatkahani)
- Telehealth companies grew 900% during the pandemic — [Arab News](https://arabnews.pk/node/1826911/pakistan)

### Inferences
- Gaps to target: (1) Urdu UI and Urdu patient explanations (none of the international calculators offer this); (2) offline use; (3) Pakistani guideline defaults (PHL, NIH dengue, Asian BMI, IDF-DAR Ramadan); (4) mg/dL-first units; (5) a dual doctor/public mode. MDCalc and Medscape are English, US/EU-guideline oriented, and Medscape needs login and is heavy.
- Telemedicine apps are adjacent, not competitors. A "see a doctor" referral link could be a future integration.

### Gaps
- No usage survey of Pakistani house officers or PG trainees was found. MDCalc use in Pakistan has not been measured in any source found.
- No Play Store download figures were retrieved for local apps (Pharmapedia, Marham, oladoc, Sehat Kahani).
- Not checked: any existing Urdu calculator apps on Play Store (a manual Play Store search is recommended).

## Q5. Workforce and connectivity: why offline-first

### Takeaway
Fewer than half of Pakistanis use the internet, with a large urban–rural gap, and median mobile speeds are modest. This supports an offline-first app with no login, which also fits house officers in busy public hospitals.

### Cited Findings
- DataReportal Digital 2025: 116 million internet users (45.7% penetration), 190 million mobile connections (75.2%), median mobile download 20.89 Mbps — [DataReportal 2025](https://datareportal.com/reports/digital-2025-pakistan)
- Digital 2026: internet penetration 45.6% — [DataReportal 2026](https://datareportal.com/reports/digital-2026-pakistan)
- Rural internet penetration about 36.5% (2024), with about 62% of people living in rural areas (secondary source) — [ts2.tech](https://ts2.tech/?p=20368899)
- PBS PSLM 2025: individual mobile/smartphone ownership (age 10+) at 50% (45% in 2019). More than 70% of households use internet services — [APP](https://www.app.com.pk/?p=1140479); [FAFEN](https://fafen.org/pslm-mobile-internet-access-rises-computer-ownership-stays-flat/)
- PTA: mobile broadband penetration 60.32% at end-2025 — [Profit](https://profit.pakistantoday.com.pk/2026/01/20/pakistans-mobile-subscriber-base-tops-200-million-by-end-of-2025-pta-data-shows/)

### Inferences
- Bundle all formulas and content locally, keep the APK small (low-end Android is common), add no mandatory account, and make updates optional through app releases.
- Shared family phones are common (ownership 50% vs household access 96%), so the public mode should not assume one user and should keep history private or optional.

### Gaps
- No figures were found on the number of house officers or PG trainees (PMDC registration data, CPSP trainee numbers), or on doctor-to-population ratios.
- No study was found on hospital Wi-Fi availability or on doctors' data costs in Pakistan.
