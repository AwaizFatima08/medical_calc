# Public / "Common man" mode: which health calculators and self-checks to include (Pakistan, English + Urdu)

Research date: 9 Nov 2026. About 17 search calls. Most findings come from search-result summaries, and few primary pages were fetched in full, so check every threshold against the primary guideline before it goes into code. Where a statement is standard clinical knowledge I did not re-verify in this session, it appears under Inferences and is marked "(not verified this session)".

---

## 1. Which consumer features have evidence of high user interest?

### Takeaway
BMI is clearly the most-installed single calculator category: the top BMI app has about 10M+ installs. I found no reliable cross-feature ranking for the other calculators (BMR/TDEE, due date, ovulation and so on), so the priority list below is a judgement, not data. Pakistan's disease burden is a stronger reason to prioritise diabetes, blood pressure and weight tools than download counts are. Its diabetes prevalence is the highest in the world.

### Cited Findings
- Appovo "BMI Calculator" (com.appovo.bmicalculator): AppBrain estimates about 24M downloads in total and about 220k in the last 30 days. Its Google Play listing shows 10,000,000+ installs, a 4.56 rating and about 132k reviews. — [AppBrain](https://www.appbrain.com/app/bmi-calculator/com.appovo.bmicalculator); [Similarweb](https://www.similarweb.com/app/google/com.appovo.bmicalculator/peru)
- Other BMI apps have 100k to 1M+ installs, for example "BMI Calculator: Calculate BMI". — [AppBrain](https://www.appbrain.com/app/bmi-calculator-calculate-bmi/com.bmi.calculators)
- Caveat: AppBrain numbers are third-party estimates, and Google Play publishes only install ranges. — same sources
- The IDF Diabetes Atlas puts Pakistan's age-standardised adult (20–79) diabetes prevalence at **31.4% (2024)**, the highest in the world, projected to reach 34.2% by 2050. That is about 34.5M adults. — [IDF Diabetes Atlas, Pakistan](https://diabetesatlas.org/data-by-location/country/pakistan)
- Press reports say more than 9.3M Pakistanis are unaware they have diabetes. One outlet gives 30.8% instead of 31.4%. — [ProPakistani](https://propakistani.pk/2025/04/09/pakistan-tops-global-diabetes-rankings/); [The News](https://thenews.com.pk/print/1299445-pakistan-ranks-first-globally-in-diabetes-prevalence)

### Inferences
- **Recommended ranking for the Public mode.** It combines the interest evidence (BMI dominates), the burden in Pakistan (diabetes, hypertension, obesity, CVD) and how safe each tool is for a layperson:
  1. **BMI with Asian cut-offs, plus waist-to-height / waist circumference.** Highest user interest. Use the Asian thresholds (see section 3).
  2. **Diabetes risk test (IDRS first; FINDRISC or ADA as an option).** Pakistan has the world's highest prevalence and a large undiagnosed share.
  3. **Home blood pressure reading interpreter.** AHA/ACC 2025 categories, with red flags at >180/120.
  4. **Blood sugar reading interpreter (fasting, after meals, random) and HbA1c ↔ average glucose.** Interpretation only, never treatment advice.
  5. **10-year heart risk (WHO 2019 non-laboratory chart, South Asia region).** Inputs: age, sex, smoking, systolic BP, BMI.
  6. **Calorie needs (BMR/TDEE) and ideal / healthy weight range.**
  7. **Pregnancy due date and week; period and ovulation calendar.** Strong interest is likely but was not measured here. Ovulation must carry a "not contraception" warning.
  8. **Mood and anxiety self-check (PHQ-9 / GAD-7, Urdu-validated).** Needs a crisis pathway.
  9. **Water intake, heart-rate zones, step/calorie burn, sleep-duration check.** Low risk, "wellness" tier.
  10. **Smoking pack-years / naswar and other tobacco use, and STOP-Bang snoring check.**
  11. **Child growth (WHO growth standards, weight/height-for-age).** Useful, but needs careful wording.
- Alcohol units and AUDIT-C are of low relevance in Pakistan, where alcohol is legally restricted for Muslims and uncommon. A hidden or optional module at most (inference).

### Gaps
- No Google Trends data or app-store dataset ranked calculator *features* against each other (BMI vs due date vs ovulation, etc.). Pakistan-specific Google Trends was not pulled in this session.
- No survey of Pakistani users' health-app feature preferences was found.

---

## 2. Validated lay risk tests: free to use? Validated in South Asians / Pakistan?

### Takeaway
- **IDRS (MDRF Indian Diabetes Risk Score):** the best-validated lay diabetes score in South Asians, with several Indian validations. It has 4 items and no lab test. I found no Pakistani validation.
- **FINDRISC:** used in Pakistani community screening, but no formal Pakistani validation was found.
- **ADA Risk Test:** no South Asian validation was found.
- **WHO 2019 non-lab CVD chart for South Asia:** fits a lay app and has been checked against the lab-based chart in India.
- **Urdu PHQ-9, GAD-7 and STOP-Bang:** all exist with Pakistani validation studies.
- **QRISK3:** includes "Pakistani" as an ethnicity, but its licensing and need for cholesterol make it a poorer fit (see Gaps).

### Cited Findings
**Diabetes risk scores**
- IDRS validations in India: Mangalore (n=551) found a score ≥60 gave the best balance of sensitivity and specificity for undiagnosed diabetes. Jaipur found a score >60 gave sensitivity 62.2% and specificity 73.7%. Jabalpur (n=911) reported excellent predictive value. A Shimla study says region-specific validation is needed. — [IJCMPH Mangalore](https://www.ijcmph.com/index.php/ijcmph/article/download/3831/2617/15164); [PubMed 21121209](https://pubmed.ncbi.nlm.nih.gov/21121209); [PubMed 25355391](https://pubmed.ncbi.nlm.nih.gov/25355391/); [PMC5729677](https://pmc.ncbi.nlm.nih.gov/articles/PMC5729677)
- A UCL study found the MDRF-IDRS performs well among Indians and Americans across ethnic groups in the US. — [UCL Discovery (Diabetes Technol Ther 2019)](https://discovery-pp.ucl.ac.uk/10088595/1/dia.2019.0354.pdf)
- FINDRISC in Pakistan, Rawalpindi (PLOS Global Public Health, 2025): a feasibility study of 260 adults in a low-income settlement. More women than men were high or very high risk (30% vs 13%). The authors *state* FINDRISC has high sensitivity and specificity in South Asians, citing other work. — [PMC12266448](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12266448/)
- FINDRISC was also used in Karachi squatter settlements (AKU) as a simple, non-invasive screen. — [AKU eCommons](https://ecommons.aku.edu/pakistan_fhs_mc_fam_med/282); [PMC5408870](https://pmc.ncbi.nlm.nih.gov/articles/PMC5408870)
- ADA and Asian Americans: at a BMI cut-point ≥23 for screening, sensitivity is 84.7%. Below 23, specificity falls to 13.1%. The ADA changed only the *screening* BMI cut-point for Asian Americans, not the overweight definition. An Indian consensus also recommends BMI ≥23 for diabetes screening. — [PMC4407753 (Araneta et al., Diabetes Care 2015)](https://pmc.ncbi.nlm.nih.gov/articles/PMC4407753); [PMC4555479](https://pmc.ncbi.nlm.nih.gov/articles/PMC4555479); [MDedge](https://mdedge.com/content/ada-lowers-bmi-cut-point-asian-americans-risk-type-2-diabetes)

**Cardiovascular risk**
- WHO 2019 revised CVD risk charts cover 21 GBD regions and include a **South Asia non-laboratory chart**. Inputs: age, sex, smoking, systolic BP, BMI. — [Frontiers Public Health 2024](https://frontiersin.org/articles/10.3389/fpubh.2024.1407918/full); [WHORiskCalculator R package](https://cran.r-universe.dev/WHORiskCalculator/doc/readme?highlight=hljs)
- In rural India, the non-lab chart against the lab chart at a 5% cut-off had sensitivity 86.5% and specificity 90.3%. The authors call it suitable for resource-limited settings. A two-stage approach (non-lab first, lab test if ≥10%) is seen as cost-effective. — [PMC9438460](https://pmc.ncbi.nlm.nih.gov/articles/PMC9438460); [Frontiers 2024](https://frontiersin.org/articles/10.3389/fpubh.2024.1407918/full)
- Among Indian adults aged 45+ (national sample), 68.8% had 10-year risk <10% and 2.8% had risk ≥20%. — [Frontiers 2024](https://frontiersin.org/articles/10.3389/fpubh.2024.1407918/full)
- An open-source implementation exists (R package `WHORiskCalculator`, "WHOrisk"), useful as a reference for test vectors. — [CRAN readme](https://archive.linux.duke.edu/cran/web/packages/WHORiskCalculator/readme/README.html)

**Mental health (Urdu)**
- Urdu PHQ-9, primary care in Gilgit, Lahore and Karachi (JPMA 2018): Cronbach's α 0.91, single factor, judged valid for screening and monitoring. — [PubMed 30108380](https://pubmed.ncbi.nlm.nih.gov/30108380/)
- Urdu PHQ-9 in pregnant women in rural Pakistan, against SCID: at a cut-off ≥10, sensitivity 94.7% and specificity 88.9%. — [PeerJ 5185 (Gallis et al. 2018)](https://peerj.com/articles/5185)
- Urdu PHQ-9 in coronary artery disease patients: at a cut-off ≥6, sensitivity and specificity were both 76%. The best cut-off differs by population. — [UTS OPUS](https://opus.lib.uts.edu.au/handle/10453/114867)
- Urdu GAD-7, primary care (Gilgit military hospital, JPMA 2017): described as a validated, brief, self-administered Urdu tool. — [JPMA 8391](https://archive.jpma.org.pk/article-details/8391)
- Urdu GAD-7, clinical sample of 267 (2026, early access): α 0.896, AUC 0.970, and at cut-off 10 sensitivity 98.6% and specificity 81.4%. — [PagePress HLS 14309](https://www.pagepressjournals.org/hls/article/view/14309)

**Sleep apnoea**
- Urdu STOP-Bang (Rawal Med J 2016, Karachi DUHS): tested on bilingual students and staff. The snippets showed no accuracy figures against polysomnography, and the authors call for testing in sleep-disorder populations. — [RMJ](https://www.rmj.org.pk/?mno=204573)
- Meta-analyses found STOP-Bang valid in the general population and commercial drivers, and in sleep-clinic and surgical groups. — [PMC8590671](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8590671/); [PMC4678295](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4678295/)

### Inferences
- **Diabetes score choice:** use **IDRS** as the primary test. It is built on South Asians and has 4 items: age, waist, physical activity, family history. Score bands (not verified this session): <30 low, 30–50 moderate, ≥60 high. A 60 cut-off is consistent with the validations cited above. FINDRISC could be offered second, as it has the most international evidence and has been used in Pakistan. When running the ADA Risk Test, apply the Asian BMI bands.
- **Licences (not verified this session):** PHQ-9 and GAD-7 are generally described as free to use (Pfizer released them without permission requirements). FINDRISC is generally cited as free for non-commercial and public-health use. IDRS was published openly by MDRF. Check each licence before a commercial release.
- **CVD:** prefer the **WHO non-lab South Asia chart** over QRISK3 or Framingham for a lay mode. It needs no cholesterol, is WHO-endorsed and covers the right region. Show the result as a band (<5%, 5–<10, 10–<20, 20–<30, ≥30%) and not as a precise number.
- **PHQ-9 cut-offs:** use the standard severity bands (5/10/15/20). Mark ≥10 as "talk to a doctor". **Any non-zero answer on item 9 (self-harm thoughts) must trigger an immediate crisis screen** with Pakistani helpline numbers. Those numbers need sourcing, for example Umang 0311-7786264 (not verified this session).

### Gaps
- No Pakistani validation of IDRS was found.
- No Pakistani validation of FINDRISC against OGTT or HbA1c was found.
- QRISK3 licensing terms and lay suitability were not researched this session.
- No validation of the WHO non-lab chart in Pakistani cohorts specifically was found (only Indian ones).
- No Urdu validation of AUDIT-C was found. It was not searched, given its low relevance.

---

## 3. Asian / South Asian BMI and waist cut-offs: which should a Pakistan app use?

### Takeaway
Use the **WHO Asia-Pacific BMI bands**, which Pakistani literature also applies: overweight from **23**, obese from **25**. Use the **IDF South Asian waist cut-offs**: **≥90 cm men, ≥80 cm women**. Show the standard WHO international bands only as a secondary reference.

### Cited Findings
- The Asia-Pacific provisional cut-offs (IOTF/IASO) are overweight 23 and obese 25. A JPMA review applied them to Pakistan (overweight >23, obese >25). — [JPMA 2356](https://archive.jpma.org.pk/article-details/2356); [PubMed 12481671](https://pubmed.ncbi.nlm.nih.gov/12481671)
- A Pakistan analysis says the 23 threshold may give "a more accurate determination of the health of Pakistanis". A CMAJ study of Pakistan's National Health Survey used 27 for obesity, a deliberate alternative and not the consensus. — [AKU eCommons](https://ecommons.aku.edu/pakistan_fhs_mc_chs_chs/597); [CMAJ 175:1071](https://www.cmaj.ca/content/175/9/1071)
- IDF 2005 worldwide metabolic syndrome definition: waist **90 cm (men) / 80 cm (women) for South and South-East Asians**, against 94/80 for Europeans. Central obesity is mandatory in the IDF definition. The older ATP III cut-offs were 102/88. Sources differ slightly between "≥" and ">". — [MJA 2005](https://www.mja.com.au/journal/2005/183/4/mainstreaming-metabolic-syndrome-definitive-definition); [Rev Esp Cardiol](https://www.revespcardiol.org/index.php/en-a-new-international-diabetes-federation-articulo-13082910)
- The ADA uses BMI ≥23 as the diabetes *screening* trigger for Asian Americans. — [PMC4407753](https://pmc.ncbi.nlm.nih.gov/articles/PMC4407753)

### Inferences
- Bands to code for adults:
  - Underweight <18.5
  - Normal 18.5–22.9
  - Overweight / "at risk" 23–24.9
  - Obese I 25–29.9
  - Obese II ≥30

  This follows the WHO 2004 Lancet expert consultation on Asian BMI, which also gives 27.5 and 32.5 as public-health action points. **The primary Lancet 2004 paper was not fetched this session.**
- Waist-to-height ratio: ≥0.5 is the widely used "keep your waist to less than half your height" message (NICE 2022). Not verified this session, but simple and language-neutral, so it suits low literacy.
- Show users which standard is applied ("South Asian standard") with a toggle, because international apps will give a different label for the same BMI.
- BMI is not for children (they need BMI-for-age percentiles), pregnancy or very muscular people. State this in the UI.

### Gaps
- The full text of the WHO 2004 Lancet consultation was not retrieved.
- No current (2024–2026) Pakistan Endocrine Society or Ministry of Health guideline on BMI or waist was found.

---

## 4. Which tools are risky for laypeople and should be excluded or doctor-only?

### Takeaway
Leave out **insulin dosing, any prescription-drug dosing, and any tool that tells users to change medication**. Children's paracetamol and ibuprofen by weight is the borderline case. Caregivers make frequent errors in both directions, so offer it only as a weight-to-mg/mL lookup with the product's concentration chosen explicitly and hard caps. Defer it to a later release, or leave it out of version 1.

### Cited Findings
- Bangladesh 2026: 113 caregivers of under-5s were compared against 15 mg/kg. Dosing inaccuracy was highly prevalent, mostly underdosing. The authors recommend standardised syringes and simpler instructions. — [Banglajol CBMJ 87636](https://banglajol.info/index.php/CBMJ/article/view/87636)
- Sri Lanka 2012: 43% of children received a supra-therapeutic paracetamol dose (>15 mg/kg/dose), and only one caregiver could calculate a weight-based dose. — [J Fam Med Prim Care, DOAJ](https://doaj.org/article/b8c347a5a5594d219dd31f78af67fec8)
- New Zealand: the Poisons Centre receives about 804 calls a year about paracetamol in children, almost a third from administration errors. Medsafe reports acute liver failure after a suspected overdose and advises putting the child's weight on prescriptions. — [Medsafe 2019](https://www.medsafe.govt.nz/Profs/PUArticles/September2019/Paracetamol-dangerous-when-not-used-correctly.htm); [NZ Doctor](https://www.nzdoctor.co.nz/article/undoctored/study-prevent-paracetamol-poisoning-children)
- A US study found most parents read dosing charts correctly, but errors occurred when age and weight were discordant. — [MDedge / J Fam Pract](https://www.mdedge.com/jfponline/article/60873/liquid-medication-dosing-errors/page/0/2)
- Lahore study of older women with type 2 diabetes: those with *inadequate* health literacy changed their medication doses without advice more often. The snippet's numbers (12.3% vs 2.8%) are worded ambiguously, so check them in the paper. — [typeset summary](https://typeset.io/pdf/association-of-health-literacy-and-medication-adherence-with-1au0akouzf.pdf)
- AHA/ACC 2025: cuffless devices (watches, rings) are **not** recommended for BP assessment. Only validated oscillometric cuff monitors are. — [AHA Top Things to Know](https://professional.heart.org/en/science-news/2025-high-blood-pressure-guideline\top-things-to-know); [JournalFeed](https://journalfeed.org/article-a-day/2025/new-2025-aha-acc-hypertension-guidelines/)

### Inferences
- **Exclude from Public mode:**
  - insulin dose and carb-ratio calculators
  - sliding scales
  - anticoagulant, antibiotic or steroid dosing
  - "should I stop or adjust my BP or diabetes tablet" logic
  - eGFR or anything else needing lab values beyond the user's own glucose reading
  - pregnancy-medication safety lookups
  - diagnosis-style symptom checkers
- **If children's paracetamol or ibuprofen dosing is ever added:**
  - require the weight in kg (never age alone)
  - require the user to pick the exact syrup strength (e.g. 120 mg/5 mL vs 250 mg/5 mL, both common in Pakistan; not verified)
  - output mL with a syringe picture
  - cap at the adult maximum
  - block ibuprofen under 3 months / 5 kg
  - add "dehydration, kidney problems → ask a doctor"
  - limit doses per 24 h
  - get sign-off from a paediatric pharmacist

  All dose numbers must come from the BNF for Children or WHO and be reviewed by a doctor.
- **Smartwatch heart-rate and BP:** label them as wellness only, consistent with the AHA position on cuffless BP.

### Gaps
- No Pakistan-specific study of paediatric paracetamol dosing errors was found.
- Pakistan DRAP rules on whether a dosing calculator counts as a regulated medical device were not researched. This needs a separate check.

---

## 5. Result thresholds and "see a doctor when" messages for the core tools

### Takeaway
Each tool needs fixed bands from a named guideline, a red / amber / green colour, and an explicit escalation line. Below are the thresholds verified this session.

### Cited Findings
- **BP (AHA/ACC 2025):**
  - Normal <120/<80
  - Elevated 120–129 / <80
  - Stage 1: 130–139 or 80–89
  - Stage 2: ≥140 or ≥90
  - **Severe hypertension: >180/120** without organ damage. With organ damage it is a **hypertensive emergency** (ICU care).
  - Home monitoring with validated oscillometric cuffs is endorsed.
  - [AHA](https://professional.heart.org/en/science-news/2025-high-blood-pressure-guideline\top-things-to-know); [Guideline Central](https://www.guidelinecentral.com/insights/aug-2025-accaha-bp-guideline-video/); [Pharmacy Times 2026](https://www.pharmacytimes.com/view/new-2025-hypertension-management-guidelines-include-key-updates)
- **HbA1c ↔ average glucose (ADAG, Nathan 2008):** eAG (mg/dL) = 28.7 × A1C − 46.7, R² = 0.84. A1C 7% ≈ 154 mg/dL and 6.5% ≈ 140 mg/dL. eAG is an estimate and not diagnostic. The mmol/L form (1.59 × A1C − 2.59) comes only from a secondary site. — [PMC2742903](https://pmc.ncbi.nlm.nih.gov/articles/PMC2742903); [PMC2850190](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2850190/); [metabolicum](https://metabolicum.com/learn/calculators/eag)
- **Diabetes risk:** IDRS ≥60 means high risk, so get a blood test. — [IJCMPH](https://www.ijcmph.com/index.php/ijcmph/article/download/3831/2617/15164)
- **CVD:** non-lab risk ≥10% means see a doctor for a lab-based assessment (two-stage approach). — [Frontiers 2024](https://frontiersin.org/articles/10.3389/fpubh.2024.1407918/full)
- **PHQ-9:** Urdu PHQ-9 ≥10 detects depression with high sensitivity in Pakistani women. — [PeerJ 5185](https://peerj.com/articles/5185)
- **GAD-7:** Urdu GAD-7 ≥10 is the best cut-off. — [PagePress HLS](https://www.pagepressjournals.org/hls/article/view/14309)

### Inferences
These thresholds are standard guideline values not re-verified this session. Verify them before coding.

- **Blood pressure, home reading:**
  - Advise an average of 2 readings, morning and evening, over several days.
  - Amber: ≥130/80 on the home average.
  - Red, "recheck in 5 min; if still >180/120 see a doctor today"; with chest pain, breathlessness, weakness or numbness, trouble speaking, vision change or severe headache: **"go to emergency / call 1122 now"**.
  - Low BP plus fainting also gets a red flag.
- **Blood sugar from a home glucometer (ADA thresholds):**
  - Fasting 70–99 normal, 100–125 "prediabetes range — get a lab test", ≥126 "diabetes range — see a doctor".
  - 2-hour or random ≥200 "see a doctor".
  - **<70 low: take 15 g of fast sugar and recheck in 15 minutes. <54 or confused: emergency.**
  - **>300, or >250 with vomiting, drowsiness or rapid breathing: emergency** (DKA risk).
  - A meter reading never diagnoses diabetes; a lab test is needed.
- **HbA1c bands:** <5.7 normal, 5.7–6.4 prediabetes, ≥6.5 diabetes range. For people with diabetes, ADA's general target is <7, but the doctor sets individual targets.
- **BMI:**
  - ≥25 (Asian) or waist above the cut-off: suggest a diabetes risk test and a BP check.
  - <18.5: suggest a doctor visit if weight loss is unexplained.
- **Pregnancy due date (Naegele's rule, LMP + 280 days):**
  - Always add "book antenatal care".
  - Danger signs (bleeding, severe headache or blurred vision, swelling of face and hands, fits, fever, reduced baby movements, leaking fluid) → urgent care.
- **Ovulation and period calendar:** "not reliable for avoiding pregnancy". Irregular cycles (<21 or >35 days), bleeding after menopause or between periods → see a doctor.
- **Child growth (WHO 2006 Child Growth Standards, 0–5 years):**
  - Show "below/above the usual range".
  - Below −2 SD weight-for-height, or a visible thin child, → nutrition clinic or LHW (Lady Health Worker) referral.
  - Avoid stigmatising words ("stunted").
- **Calorie needs (BMR via Mifflin-St Jeor):** set a floor (e.g. do not suggest <1200 kcal for women or <1500 for men). Turn it off in pregnancy and for under-18s.
- **Water intake:** give a general guide only. Warn people with heart or kidney disease to follow their doctor's fluid limit.
- **Heart-rate zones (220 − age):** warn about chest pain or dizziness during exercise, and that heart medicines (beta-blockers) change heart rate.
- **Pack-years:** ≥20 pack-years at age 50–80 matches USPSTF lung-screening eligibility, but CT screening is scarce in Pakistan. Use the result mainly as a quit-smoking prompt. Add naswar, gutka, paan and shisha questions, which matter in Pakistan.

### Gaps
- The ADA Standards of Care 2026 glucose thresholds were not fetched this session.
- The WHO non-lab chart risk colour bands were not fetched from the WHO primary document.
- Pakistan emergency and mental-health helpline numbers need verification. 1122 Rescue is provincial; check coverage.

---

## 6. Best practice for presenting results to laypeople (risk communication, colour, red flags, Urdu literacy)

### Takeaway
Pakistan's adult literacy is about 55% (women about 42%), and health literacy is low. Present results as **one plain sentence + a colour band + an icon** ("1 in 10 people like you…" with an icon array), with a clear next step. Offer Urdu **audio** for every result. The tested Urdu tools (PHQ-9, GAD-7, STOP-Bang) should use their validated Urdu wording, not new translations.

### Cited Findings
- Pakistan's adult literacy was 55% (men 67%, women 42%), as cited in a 2021 Lahore study. — [PMC8523976](https://pmc.ncbi.nlm.nih.gov/articles/PMC8523976)
- Low health literacy in Asian countries is put at 75–82% of the population. In Pakistan it is linked to late presentation and poor treatment compliance. — [MDPI IJERPH 20:729](https://mdpi-res.com/d_attachment/ijerph/ijerph-20-00729/article_deploy/ijerph-20-00729.pdf)
- Islamabad marginalised communities (n=26,571, provisionally accepted 2025): poor nutritional literacy in 89.1%. — [Frontiers Public Health 2025](https://www.frontiersin.org/journals/public-health/articles/10.3389/fpubh.2025.1698201/full)
- Health literacy is lower in rural than in urban Punjab. — [South Asian Studies (PU)](https://sasj.pu.edu.pk/9/article/view/1206)
- Icon arrays raised accuracy for both low- and high-numeracy people and remove "denominator neglect". Graphical grids add to the benefit of natural frequencies. Caveats: icon arrays may not help people low in *both* numeracy and graph literacy, and they can make risks seem less serious than numbers do. — [PMC4504147](https://pmc.ncbi.nlm.nih.gov/articles/PMC4504147); [Galesic et al. 2009 (MPG)](https://pure.mpg.de/pubman/item/item_2099767_5/component/file_2562291/MG_Using_2009.pdf); [PMC2775772](https://pmc.ncbi.nlm.nih.gov/articles/PMC2775772); [PMC2988162](https://pmc.ncbi.nlm.nih.gov/articles/PMC2988162)
- Validated Urdu versions exist for PHQ-9, GAD-7 and STOP-Bang. — sources in section 2

### Inferences
- **Result card pattern:**
  1. Headline in plain words ("Your blood pressure is high").
  2. Colour band. Use green / yellow / orange / red plus a text label and icon, never colour alone, for colour-blind users.
  3. "What it means" in one sentence.
  4. "What to do now": one action.
  5. "See a doctor today / go to emergency if…" as a bullet list of red flags.
  6. Source line ("Based on: AHA 2025 / WHO / IDF").
- Use natural frequencies ("about 15 out of 100 people like you will have a heart attack or stroke in 10 years") with a 100-person icon array. Do not show percentages alone, and avoid decimals.
- **Urdu:**
  - Grade 5–6 reading level with short sentences.
  - Use common words with the English term in brackets where people know it (e.g. "شوگر (ذیابیطس)" for diabetes; "بلڈ پریشر").
  - Nastaliq font at a large size, right-to-left.
  - Read-aloud audio for every result. Per CLAUDE.md, Urdu narration goes through the `voice-voxcpm2` recipe and Homi checks it by ear.
  - Allow Roman Urdu search.
- Units: mg/dL by default (most Pakistani glucometers and labs report mg/dL; not verified), kg and cm with feet/inches entry, mmHg.
- Do not show a "risk score number" as a diagnosis. Always say "this is a screening estimate, not a diagnosis".
- Red-flag screens must interrupt the flow (full-screen, red) and offer one-tap "Call 1122" / "Call helpline". Do not bury them below the result.
- Store nothing sensitive (mental-health answers, pregnancy) without explicit consent; offer local-only storage.
- Get Urdu texts reviewed by a Pakistani doctor and tested with low-literacy users (e.g. 5–8 people, including women and rural users) before release.

### Gaps
- No Pakistan-specific study on colour or traffic-light comprehension or Urdu health-app usability was found.
- No national health literacy survey for Pakistan was found; figures are local studies only.
- No Pakistan regulatory guidance (DRAP) on health-app disclaimers was researched.
