# Licensing, Regulation, Google Play Policy and Validation for a Free/Ad-Supported Medical Calculator App (Flutter, Pakistan + global Google Play; doctor mode + public mode)

Research date: 9 Nov 2026. About 16 tool calls. Many findings come from secondary sources (law-firm commentary, CamCOPS documentation, consultancies). Primary pages were fetched only for Google Play's health policy and the GCS permissions page. Items marked UNVERIFIED in Gaps are background knowledge that was not confirmed in this session. Re-check them before relying on them.

## Copyright and licensing of clinical scores and questionnaires

### Takeaway
A published formula or scoring method is generally not copyrightable, because copyright covers expression and not a "system or method of operation". The questionnaire wording, item text and forms can be protected, though. The real risk is in a few proprietary instruments: MMSE (PAR) and MoCA need written permission or a licence, and should be excluded or licensed. PHQ-9/GAD-7, GCS (clinical use, with attribution), EPDS (with attribution) and QRISK3 (LGPL, mandatory disclaimer) are usable on stated terms.

### Cited Findings
- **The formula itself:** US 17 U.S.C. §102(b) says copyright does not extend to "any idea, procedure, process, system, method of operation…". A Copyright Office Review Board letter applies this to say a copyright holder cannot use copyright to control use of the system itself. — [Copyright Office Review Board (Accugrid)](https://www.Copyright.gov/rulings-filings/review-board/docs/accugrid.pdf)
- **Facts and compilations:** Feist holds that facts without minimal creativity are not protected. A compilation is protected only through original selection or arrangement. The merger doctrine can bar protection where there are only one or a few ways to express an idea. — [Feist (Wikipedia)](https://en.wikipedia.org/wiki/Feist_Publications,_Inc._v._Rural_Telephone_Service_Co.); [Lexplug outline](https://www.lexplug.com/outlines/intellectual-property/copyright-law/requirements-for-protection/subject-matter-eligibility-102/originality-feist-v-rural)
- **PHQ-9 / GAD-7:** The PHQ screeners site instructions, as quoted by CamCOPS, say no permission is required to reproduce, translate, display or distribute them. CamCOPS lists both as public domain. They were developed by Spitzer, Williams and Kroenke with an educational grant from Pfizer, and translations exist in about 80 languages. — [CamCOPS PHQ-9](https://camcops.readthedocs.io/en/latest/tasks/phq9.html); [CamCOPS GAD-7](https://camcops.readthedocs.io/en/stable/tasks/gad7.html); [IntuitionLabs listing](https://intuitionlabs.ai/software/outcome-measurement-quality-improvement/standardized-assessment-tools-phq-9-gad-7/phq-screeners). The permission quote comes from a 2012 snapshot; phqscreeners.com was not fetched directly.
- **MMSE:** PAR holds an exclusive licence. In 2011 it brought a copyright claim that led to the takedown of the "Sweet 16" cognitive test. Its terms say the test may not be reproduced in whole or part, in any form or language, without PAR's written permission. No court has ruled on PAR's position, and commentators (GeriPal) argue the law may not support it. — [RAPS](https://www.raps.org/resource/copyright-claim-threatens-medical-diagnostic-test.html); [Mind Hacks](https://mindhacks.com/2011/12/29/diagnostic-test-takedown-by-copyright-bullies/); [GeriPal](https://geripal.org/2011/12)
- **MoCA:** The official permission page says MoCA may be used, reproduced and distributed WITH prior written permission and a Licensing Agreement. Training and certification have been mandatory since 1 Sep 2019 for clinicians who interpret subscores; they are optional for total-score-only use, and some specialists are exempt. The vendor runs its own official MoCA apps (MoCA Duo, sold by Test MoCA Inc.). One third-party note says development of electronic versions is now prohibited. This is unconfirmed but consistent with the vendor controlling digital versions. — [MoCA permission](https://mocacognition.com/permission); [MoCA mandatory training](https://mocacognition.com/mandatory-moca-test-training/); [MoCA FAQ](https://mocacognition.com/faq/); [CamCOPS MoCA](https://camcops.readthedocs.io/en/stable/tasks/moca.html); [MoCA Duo App Store](https://apps.apple.com/app/id1206246590)
- **Glasgow Coma Scale:** The official site says the GCS, GCS Aid, GCS-P, the GCS-P Age CT prognostic charts and the verbal-score imputation tool "may all be used for clinical care and clinical research at no cost. No license is required." Copyright of Glasgow University and Sir Graham Teasdale must be acknowledged. Commercial software is not addressed, and the site says to use Contact Us. — [glasgowcomascale.org/permissions](https://glasgowcomascale.org/permissions); [GCS disclaimer](https://glasgowcomascale.org/disclaimer/)
- **EPDS:** Copyright is held via the Royal College of Psychiatrists (Cox, Holden & Sagovsky 1987). Reproductions state that users may reproduce the scale without further permission if they cite the authors, title and source of the paper in all copies. — [NJ Dept of Health EPDS PDF](https://nj.gov/health/fhs/maternalchild/documents/PPD-Edinburgh-Scale.pdf); [CamCOPS EPDS](https://camcops.readthedocs.io/en/latest/tasks/epds.html); [LOINC 71354-5](https://loinc.org/71354-5)
- **QRISK3:** The original model formula, including variable names and beta coefficients, is LGPL, © ClinRisk Ltd. If a score is displayed, ClinRisk's disclaimer "must be displayed or otherwise be made easily accessible, e.g. by a prominent link alongside it". ClinRisk says it cannot control misuse such as altered coefficients, wrong inputs or poor programming. Implementers must check their results match the original code at qrisk.org. Ports carry their own licences (CRAN package mostly GPL-3; npm port LGPL-3.0). — [CRAN QRISK3 COPYRIGHTS](https://archive.linux.duke.edu/cran/web/packages/QRISK3/COPYRIGHTS); [rdrr QRISK3](https://rdrr.io/cran/QRISK3/); [npm qrisk3-2017](https://npmjs.com/package/qrisk3-2017)
- **How a reputable open project classifies instruments:** CamCOPS publishes an "intellectual property status" for each task (PHQ-9/GAD-7 public domain; MoCA, MMSE restricted). It is a useful reference model for an app's own licence register. — [CamCOPS MoCA](https://camcops.readthedocs.io/en/stable/tasks/moca.html)

### Inferences
- **Implement freely (formula-based):** The equations and score tables come from journal papers. Write the item labels in your own words, cite the paper, and don't copy proprietary form layouts or wording. Examples are Framingham, the ASCVD Pooled Cohort Equations, AHA PREVENT, SCORE2, Apgar, Bishop, CHA2DS2-VASc, eGFR (CKD-EPI), BMI and MELD. Licence status for these was not confirmed in this session.
- **Questionnaires:** For PHQ-9, GAD-7, EPDS and AUDIT, reproduce the exact validated wording, because changing it breaks validity. Show the attribution each copyright holder asks for.
- **Exclude from v1:** MMSE and MoCA, unless a written licence is obtained. Simply re-wording them does not avoid the problem, since validity depends on the exact items, and both holders actively enforce their rights.
- **QRISK3:** If included, ship the ClinRisk disclaimer next to the result, keep the LGPL notice, check the output against qrisk.org test cases, and keep the code module open-source-compliant under LGPL.
- **GCS:** Acknowledge © University of Glasgow / Sir Graham Teasdale, and use the current GCS structure and wording (including "Not testable"). The app is free but ad-funded, so email the GCS team to confirm commercial-app use.

### Gaps
- UNVERIFIED (not checked this session): FINDRISC (Finnish Diabetes Association; reportedly free for non-commercial use with attribution); AUDIT (WHO; reportedly freely usable); NIHSS (NIH public domain; the certification and training images are a separate matter); APACHE II (formula published 1985 and widely implemented; APACHE IV is proprietary, from Cerner/Oracle); AHA PREVENT (equations published in Circulation 2023/24, with AHA terms for the online tool); SCORE2 (ESC charts © ESC); WHO CVD risk charts; Braden Scale (copyright held by Barbara Braden and Nancy Bergstrom; permission is reportedly required for commercial use); STOP-BANG (University Health Network Toronto; reportedly free for clinical use but licensed for commercial use); Apgar and Bishop (old published scores, generally treated as free). Each needs checking against the holder's site before inclusion.
- The current phqscreeners.com terms were not fetched directly.
- I found no reliable source on how MDCalc handles licensing. By reputation it partners with or credits score creators ("creator insights"), but this is not verified.
- No court case squarely decides whether a clinical score formula is copyrightable. A US case about MMPI scoring data was mentioned on a forum but not verified.
- Pakistan copyright law (Copyright Ordinance 1962) was not researched. Its idea/expression principle is presumed to be similar.

## Google Play policy for health and medical apps (2024–2026)

### Takeaway
All health apps must complete the Health apps declaration and have a privacy policy. An app that is not a regulated device must include in its store description the exact disclaimer "not a medical device and does not diagnose, treat, cure, or prevent any medical condition", plus a reminder to consult a healthcare professional. Regulated apps get a "Medical Device" label and must show proof of approval when asked. The updated medical functionality policy took effect on 28 May 2025.

### Cited Findings
- All developers must complete the **Health apps declaration** form under Play Console > App content. — [Google Play Health Content and Services](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)
- **Privacy policy:** It must be linked both in the Play Console field and inside the app. It must be public, not geofenced, not a PDF and not editable, and must cover all handling of personal and sensitive data. — [Google Play policy](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)
- **Regulated medical devices:** They must be declared, are labelled "Medical Device" on Google Play, and must provide proof of approval, clearance or certification on request. — [Google Play policy](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)
- **Disclaimer for other health apps:** The description must state the app is "not a medical device and does not diagnose, treat, cure, or prevent any medical condition", and the app must remind users to consult a healthcare professional. Misleading or potentially harmful health functionality is prohibited. — [Google Play policy](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)
- **Effective date:** The updated medical functionalities policy took effect on 28 May 2025, with added medical guidance and disclaimer requirements. Google also incorporated elements of the MDCG guidance for EU device apps. The latter is reported in a third-party post. — [Policy preview](https://support.google.com/googleplay/android-developer/answer/13996823); [Google Groups summary](https://groups.google.com/g/barnabas-support/c/T8YBbypVXl0)
- **Hardware and sensor claims:** App-only oximetry is not allowed. Apps that depend on hardware must say so and list compatible devices. — [Google Play policy](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)
- **Health misinformation:** Claims contradicting medical consensus are prohibited. — [Google Play policy](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)

### Inferences
- For a non-device calculator, put Google's exact disclaimer sentence in the full description, and repeat it in-app on first launch and in About. Add "consult a healthcare professional" on each result screen in public mode.
- An offline app that collects no data still needs a privacy policy URL and Data safety answers ("no data collected"). Ad SDKs such as AdMob do collect data (device IDs, ad interactions), so the Data safety form must declare them.
- If the app has no accounts, Play's account-deletion requirement does not apply. Adding sign-in (for example for doctor verification) triggers it.

### Gaps
- Not fetched (UNVERIFIED): Play's ads policy rules for health apps; the Families/Target audience rules (keep the app 18+ or general adult and avoid child appeal, otherwise the Families ad-SDK rules apply); Health Connect (irrelevant unless the app reads health data); Data safety form specifics; and the account deletion policy (in force since 2024 for apps with account creation). Google's ads policies restrict ads for prescription drugs and unproven treatments. Whether a medical app may show general AdMob ads was not confirmed, but many medical calculator apps on Play do show ads.
- Exact rules for apps aimed at healthcare professionals were not found in the policy text retrieved.

## Medical device / SaMD status (FDA, EU MDR, UK MHRA, DRAP Pakistan)

### Takeaway
A simple, transparent calculator whose output a clinician can check is generally outside device regulation or under enforcement discretion. This holds in the US (non-device CDS criteria, eased in the Jan 2026 guidance) and the UK (MHRA: easy-to-verify calculators are unlikely to be devices). In the EU, however, MDCG 2019-11 lists risk-score and dose calculators that inform therapy decisions as Class IIa under Rule 11. Pakistan's DRAP Medical Devices Rules 2017 include software in the device definition, but I found no SaMD-specific guidance. Patient-specific dosing, drug-specific calculators, opaque outputs and public-facing diagnosis push an app toward regulation.

### Cited Findings
- **FDA CDS guidance, Jan 2026:** Issued 6 Jan 2026, superseding the Sept 2022 guidance, without public comment. Most of the language saying time-critical software automatically fails Criterion 3 was removed, though one passage still says it does. FDA will use enforcement discretion when a CDS function gives a single recommendation that is clinically appropriate. The guidance still covers only HCP-facing CDS; patient/consumer-facing tools are not covered. — [Covington](https://www.cov.com/news-and-insights/insights/2026/01/5-key-takeaways-from-fdas-revised-clinical-decision-support-cds-software-guidance); [Cooley](https://www.cooley.com/news/insight/2026/2026-01-20-automation-bias-and-clinical-practice-fda-makes-incremental-updates-to-clinical-decision-support-software-guidance); [FDA Law Blog](https://www.thefdalawblog.com/2026/01/a-busy-day-in-the-cdrh-neighborhood-updates-to-the-cds-and-general-wellness-guidance-documents/); [Jones Day](https://www.jonesday.com/es/insights/2026/01/a-relaxing-2026-fda-updates-general-wellness-and-clinical-decision-support-software-guidance)
- **Conflicting dates:** One source says the guidance was re-issued on 29 Jan 2026, another says final publication was 11 Mar 2026. — [Mondaq/Katten](https://www.mondaq.com/unitedstates/healthcare/1741104/fda-clinical-decision-support-software-guidance-refresh-clearer-rules-broader-innovation); [Mindbowser](https://www.mindbowser.com/?p=113790)
- **EU MDCG 2019-11 Rule 11 example:** "Calculating medical values: calculator for risk scores or medication doses informing the therapeutical decision" is Class IIa. Rule 11 has sub-rules for diagnosis/therapy decisions, physiological monitoring, and a residual Class I category. Rev.1 was published in June 2025 with more examples. — [OpenRegulatory MDCG 2019-11](https://openregulatory.com/mdcg/mdcg-2019-11); [Emergo by UL on Rev.1](https://www.emergobyul.com/news/european-revision-primary-software-guidance-mdcg-2019-11-revision-1-small-changes-meaningful); [Johner Institute Rule 11](https://www.johner-institute.com/articles/regulatory-affairs/mdr-rule-11-software/)
- **UK MHRA, as summarised by EFPIA (Sept 2024):** Calculators whose results are easy to verify are unlikely to be devices. Calculators tied to specific devices or drugs are likely devices regardless of complexity. EFPIA is lobbying for simple calculators to be classed as non-devices in the EU. — [EFPIA position paper](https://www.efpia.eu/media/b4bnh2ef/efpia-position-on-medical-calculator-qualification_v5_sept2024.pdf)
- **Pakistan:** Devices are regulated by DRAP under the Medical Devices Rules 2017, framed under the DRAP Act 2012. The definition includes software used for diagnosis, monitoring or treatment. Classes run A to D. The Medical Device Board handles establishment licensing and registration. An online e-service portal opened in July 2025. No SaMD- or CDS-specific DRAP guideline was found. — [Freyr](https://www.freyrsolutions.com/fr/medical-devices/medical-device-registration-in-pakistan); [MedDeviceGuide Pakistan](https://meddeviceguide.com/blog/pakistan-drap-medical-device-registration-classification-import-licensing-guide); [DRAP site](https://www.dra.gov.pk/2021)
- **Regional comparison, India:** CDSCO finalised its Medical Device Software guidance (CDSCO/MD/GD/MDSW/01/2026) in July 2026 under India's MDR 2017, using classes A to D. It is a possible model for DRAP. — [CDSCO guidance PDF](https://www.cdsco.gov.in/opencms/export/sites/CDSCO_WEB/Pdf-documents/Guidance-document-on-Medical-Device-Software-under-MDR-2017.pdf); [PureGlobal](https://www.pureglobal.com/news/india-cdsco-medical-device-software-guidance-2026)

### Inferences
- **Lower-risk design:** Show the formula, inputs, units and citation for every result, so a clinician can check it independently (FDA Criterion 4; MHRA "easy to verify"). Offer established, published scores only, with no proprietary algorithm. Present output as a score or risk category with the source's interpretation bands, not as an instruction ("start statin", "give X mg").
- **Features that push toward regulation:** patient-specific drug dosing (especially paediatric or insulin); drug-specific calculators; outputs a user cannot verify; AI or novel models; consumer-facing results framed as diagnosis or treatment; and alarm or monitoring functions.
- **Public mode:** This is the higher-risk mode under the FDA framework, because the CDS non-device carve-out covers HCP users only. Public mode should be educational (BMI, waist-hip ratio, PHQ-9 self-check with "talk to a doctor") and avoid treatment decisions. Its wording must also stay in line with the Play disclaimer.
- **EU:** Strictly, a risk-score calculator could be Class IIa. If the app is distributed in the EU without CE marking, the risk stays low only if outputs are positioned as reference or education and are easy to verify. The developer could also consider geo-restricting the doctor mode. This is a judgement call for legal advice.
- **Pakistan:** No practical SaMD enforcement path was found. Because the definition includes software, avoid diagnosis or treatment claims in Urdu or English marketing.

### Gaps
- FDA guidance text and its four Criteria wording were not fetched directly (fda.gov/media/109618/download).
- MHRA's own software and apps guidance was not fetched. The UK position is from EFPIA's summary.
- No DRAP SaMD guideline was found. dra.gov.pk should be checked for any 2025–2026 software or digital health notice, and the Rules 2017 text itself was not read.
- IEC 62304 was not researched. Background (UNVERIFIED): it is the software lifecycle standard used for regulated device software (safety classes A/B/C), not legally required for non-device apps, but useful as a lightweight model (requirements, traceability, risk analysis, verification records).

## Liability, disclaimers and doctor-mode gate

### Takeaway
The minimum is Google's mandated disclaimer sentence plus "consult a healthcare professional". Score-specific disclaimers must be added where holders require them (QRISK3). For the doctor mode, a self-declaration gate is the common practice. A PMDC registration check adds friction and personal data collection, and I found no public API for it.

### Cited Findings
- Google's required wording: "not a medical device and does not diagnose, treat, cure, or prevent any medical condition", plus a reminder to consult a healthcare professional. — [Google Play policy](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en)
- QRISK3 requires ClinRisk's disclaimer to be shown or prominently linked wherever the score is displayed. — [CRAN QRISK3 COPYRIGHTS](https://archive.linux.duke.edu/cran/web/packages/QRISK3/COPYRIGHTS)
- The GCS site publishes its own disclaimer page. — [GCS disclaimer](https://glasgowcomascale.org/disclaimer/)

### Inferences
- Suggested in-app disclaimer for both modes, drafted by me and not legal text: "This app is for educational and reference use. It is not a medical device and does not diagnose, treat, cure, or prevent any medical condition. Results depend on the information you enter and on published formulas, which have limits. Always consult a qualified healthcare professional for medical advice, diagnosis or treatment. In an emergency, call 1122/115 or go to the nearest hospital." The doctor-mode version adds: "Intended to support, not replace, clinical judgement. Verify results independently before use in patient care."
- **Doctor-mode gate:** A one-time "I am a registered healthcare professional" confirmation, stored locally, keeps the app offline with no data collected. A PMDC number check would mean collecting identifiers, likely through a backend, which raises privacy duties and Play Data safety declarations.

### Gaps
- No Pakistan-specific case law or product-liability guidance for health apps was researched. Consumer protection acts are provincial, and the PMDC verification portal or API was not checked.
- No MDCalc disclaimer text was retrieved for comparison.

## Validation and testing best practice

### Takeaway
Calculator apps do make clinically significant errors. A 2014 JMIR audit found 98.6% overall accuracy, but the errors clustered in Child-Pugh and MELD and about half changed prognosis. Insulin-dose apps were far worse. The defence is golden test vectors from the published sources and official reference calculators, independent clinician review, and citation and version shown for each calculator.

### Cited Findings
- **JMIR 2014:** 14 apps and 13 functions were tested (1240 tests, 17 errors, 98.6% accuracy). 6 of 14 apps were 100% accurate. Errors were concentrated in Child-Pugh and MELD, across 8 apps. 8 of the 17 errors (47%) were clinically significant, changing prognosis. The authors call for greater scrutiny. — [JMIR 2014;16(2):e32 (PMC3936266)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3936266)
- **BMC Medicine 2015:** Most insulin dose calculator apps gave no protection against, and might actively contribute to, dosing risks. Errors from misinterpreting medical principles were common. — [BMC Medicine s12916-015-0314-7](https://link.springer.com/content/pdf/10.1186/s12916-015-0314-7.pdf)
- **QRISK3:** ClinRisk names altered coefficients, wrong inputs and poor programming as misuse risks, and requires implementers to check their results against the original code. — [CRAN QRISK3 COPYRIGHTS](https://archive.linux.duke.edu/cran/web/packages/QRISK3/COPYRIGHTS)

### Inferences
- **Golden vectors:** For each calculator, build a set of test vectors from (a) worked examples in the source paper, (b) the official reference implementation where one exists (qrisk.org, the ACC ASCVD estimator, AHA PREVENT's online tool, the official SCORE2 charts), and (c) boundary values at each cut-off and each unit conversion. Run them as Dart unit tests in CI.
- **MELD and Child-Pugh:** Test these specifically, as they were the known error hotspots (MELD lower bounds of 1.0 and a creatinine cap of 4.0; MELD-Na and MELD 3.0 versions).
- **Units:** Most errors in this kind of app come from unit mix-ups (mg/dL vs µmol/L, mmol/L). Force explicit unit selectors and add range checks that reject impossible values.
- **Review:** A second clinician should review each calculator against the source and sign off, and the sign-off should be recorded. Show in the app the source citation, formula version (for example "PCE 2013" vs "PREVENT 2023"), a last-reviewed date and the app build.
- **Change process:** Keep a register of guideline versions and review it at least yearly (eGFR race-free CKD-EPI 2021, MELD 3.0, SCORE2 updates, QRISK annual releases).

### Gaps
- No post-2015 audit of calculator app accuracy was found within budget. Newer studies may exist.
- IEC 62304 and ISO 14971 details were not retrieved (see above).

## Privacy (Pakistan PDPB and an offline-first approach)

### Takeaway
As of May 2026, Pakistan had no enacted comprehensive data protection law. The Personal Data Protection Bill (2023 draft, also called the 2025/2026 Act in drafts) was still pending and had missed repeated deadlines. An offline-only app that stores nothing and collects no data reduces risk sharply. Ad SDKs still collect data and must be disclosed.

### Cited Findings
- As of March and May 2026 there was no enacted comprehensive law. The bill is pending in Parliament; the 2023 draft was approved by Cabinet. Drafts are variously called the PDP Act 2025 or 2026, but there was no Act number, assent or Gazette notice. — [Mondaq (Mar 2026)](https://www.mondaq.com/privacy-protection/1716564/why-pakistan-is-stalling-on-data-protection-a-nations-digital-dilema); [Recording Law guide 2026](https://recording-law.vercel.app/world-data-privacy-laws/pakistan-data-privacy-laws); [Chambers 2026](https://practiceguides.chambers.com/practice-guides/data-protection-privacy-2026/pakistan)
- The Ministry of IT set a two-week deadline in Feb 2026, after the bill was delayed again in March 2025. A National Commission for Personal Data Protection is planned. — [CW Pakistan](https://cwpakistan.com/pakistans-it-ministry-sets-two-week-deadline-to-finalize-personal-data-protection-bill/); [ARY News](https://arynews.tv/tag/pakistan-it-ministry/)
- Currently applicable law includes PECA 2016 (cybercrime), per guides. — [Recording Law guide](https://recording-law.vercel.app/world-data-privacy-laws/pakistan-data-privacy-laws)

### Inferences
- Do all calculation on the device. Save no patient data by default; any optional history should stay local and encrypted, with a single "clear" control. Collect no analytics in v1, or only consent-gated analytics. This keeps the Data safety entries minimal apart from the ad SDK.
- Because the app is distributed globally, GDPR and UK GDPR apply to EU and UK users through the ads (consent for personalised ads via Google's UMP/CMP). Offering non-personalised ads, or using AdMob's consent tools, reduces exposure.

### Gaps
- Status after May 2026 is unverified. Check the National Assembly and Senate trackers.
- The Google Play account-deletion and Data safety specifics, and the ad-consent (UMP) requirements, were not fetched in this session.
