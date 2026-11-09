#!/usr/bin/env python3
"""Independent reference implementation used to write test/golden/*.json.

Formulas are typed again from the primary sources (not copied from the Dart
code), so the Dart tests compare two independent implementations. Each case
says where its expected value comes from.
"""
import json, math, os, sys

OUT = os.path.join(os.path.dirname(__file__), '..', 'test', 'golden')

from decimal import Decimal, ROUND_HALF_UP
def r(v, d=0):
    # Round half away from zero, like Dart's toStringAsFixed.
    q = Decimal(1).scaleb(-d)
    s = str(Decimal(repr(v)).quantize(q, rounding=ROUND_HALF_UP if v >= 0 else ROUND_HALF_UP))
    if '.' in s:
        s = s.rstrip('0').rstrip('.')
    return s

def write(tool_id, source, cases):
    with open(os.path.join(OUT, f'{tool_id}.json'), 'w') as f:
        json.dump({'id': tool_id, 'source': source, 'cases': cases}, f, indent=1, ensure_ascii=False)

# ---------- eGFR CKD-EPI 2021 (Inker NEJM 2021) ----------
def ckd(scr, age, female):
    k = 0.7 if female else 0.9
    a = -0.241 if female else -0.302
    return 142 * min(scr/k, 1)**a * max(scr/k, 1)**-1.2 * 0.9938**age * (1.012 if female else 1)

def stage(e):
    return ('G1: normal or high' if e >= 90 else 'G2: mildly decreased' if e >= 60 else
            'G3a: mildly to moderately decreased' if e >= 45 else 'G3b: moderately to severely decreased' if e >= 30 else
            'G4: severely decreased' if e >= 15 else 'G5: kidney failure')

cases = []
for scr, age, sex in [(0.8, 50, 1), (1.0, 60, 0), (0.7, 30, 1), (0.9, 40, 0), (2.5, 70, 0), (1.4, 45, 1), (6.0, 55, 0), (0.5, 25, 0)]:
    e = ckd(scr, age, sex == 1)
    cases.append({'name': f"Scr {scr} mg/dL, {age} y, {'F' if sex else 'M'}", 'inputs': {'scr': scr, 'age': age, 'sex': sex},
                  'expect': {'headline': r(e), 'band': stage(round(e, 6))}})
write('egfr', 'Reference implementation of Inker 2021 equation (tool/golden_ref.py); spot-check against kidney.org calculator during review', cases)

# ---------- Cockcroft-Gault ----------
cases = []
for age, wt, scr, sex in [(60, 70, 1.0, 0), (80, 50, 1.2, 1), (40, 90, 0.8, 0), (75, 60, 2.0, 1)]:
    c = (140-age)*wt/(72*scr)*(0.85 if sex else 1)
    cases.append({'name': f"{age} y, {wt} kg, Scr {scr}, {'F' if sex else 'M'}", 'inputs': {'age': age, 'weight': wt, 'scr': scr, 'sex': sex},
                  'expect': {'headline': r(c)}})
# Textbook example: 60 y male 70 kg Scr 1.0 → 77.8 mL/min
cases[0]['expect_note'] = '(140−60)×70/72 = 77.8 → 78'
write('cockcroft_gault', 'Cockcroft & Gault 1976 formula (tool/golden_ref.py)', cases)

# ---------- MAP ----------
cases = [
  {'name': '120/80', 'inputs': {'sbp': 120, 'dbp': 80}, 'expect': {'headline': '93', 'band': 'At or above 65 mmHg'}},
  {'name': '80/50', 'inputs': {'sbp': 80, 'dbp': 50}, 'expect': {'headline': '60', 'band': 'Below 65 mmHg'}},
  {'name': '90/52 → 64.67', 'inputs': {'sbp': 90, 'dbp': 52}, 'expect': {'headline': '65', 'band': 'Below 65 mmHg'}},
  {'name': '93/51 → 65', 'inputs': {'sbp': 93, 'dbp': 51}, 'expect': {'headline': '65', 'band': 'At or above 65 mmHg'}},
]
write('map', 'MAP = DBP + (SBP−DBP)/3, worked by hand', cases)

# ---------- CHA2DS2-VA / VASc ----------
def cha(chf=0, htn=0, age=0, dm=0, stroke=0, vasc=0, version=0, sex=0):
    return {'chf': bool(chf), 'htn': bool(htn), 'age': age, 'dm': bool(dm), 'stroke': bool(stroke), 'vasc': bool(vasc), 'version': version, 'sex': sex}
cases = [
  {'name': 'VA: nothing', 'inputs': cha(), 'expect': {'headline': '0', 'band': 'Low risk'}},
  {'name': 'VA: female only (sex ignored)', 'inputs': cha(sex=1), 'expect': {'headline': '0', 'band': 'Low risk'}},
  {'name': 'VA: hypertension', 'inputs': cha(htn=1), 'expect': {'headline': '1', 'band': 'Intermediate risk'}},
  {'name': 'VA: age ≥75', 'inputs': cha(age=2), 'expect': {'headline': '2', 'band': 'High risk'}},
  {'name': 'VA: all items', 'inputs': cha(1,1,2,1,1,1), 'expect': {'headline': '8', 'band': 'High risk'}},
  {'name': 'VASc: female only', 'inputs': cha(version=1, sex=1), 'expect': {'headline': '1', 'band': 'Low risk'}},
  {'name': 'VASc: female + HTN', 'inputs': cha(htn=1, version=1, sex=1), 'expect': {'headline': '2', 'band': 'Intermediate risk'}},
  {'name': 'VASc: male HTN + DM', 'inputs': cha(htn=1, dm=1, version=1), 'expect': {'headline': '2', 'band': 'High risk'}},
  {'name': 'VASc: all items, female', 'inputs': cha(1,1,2,1,1,1, version=1, sex=1), 'expect': {'headline': '9', 'band': 'High risk'}},
]
write('cha2ds2va', 'Point tables from Lip 2010 (VASc) and ESC 2024 (VA), worked by hand', cases)

# ---------- Body size ----------
def body(kg, cm, sex, std):
    b = kg/(cm/100)**2
    return {'inputs': {'weight': kg, 'height': cm, 'sex': sex, 'standard': std}, 'bmi': r(b, 1)}
cases = []
for kg, cm, sex, std, band in [(70, 170, 0, 0, 'Overweight / at risk (Asian cut-offs)'), (70, 170, 0, 1, 'Normal'),
                                (60, 165, 1, 0, 'Normal (Asian cut-offs)'), (90, 165, 1, 0, 'Obese class II (Asian cut-offs)'),
                                (45, 170, 0, 1, 'Underweight'), (110, 175, 0, 1, 'Obese class II'), (95, 175, 0, 1, 'Obese class I')]:
    c = body(kg, cm, sex, std)
    cases.append({'name': f'{kg} kg {cm} cm std {std}', 'inputs': c['inputs'], 'expect': {'headline': c['bmi'], 'band': band}})
write('body_size', 'BMI = kg/m²; Asian bands WHO 2004 / WPRO 2000, WHO international bands; worked by hand', cases)

# ---------- Lab units (D28): value in unit → base ----------
lab = [
 ('creatinine', 'µmol/L', 88.42, 1.0, 'mg/dL'),
 ('glucose', 'mmol/L', 5.5, 99.088, 'mg/dL'),
 ('urea', 'urea mg/dL', 42.8, 20.0, 'BUN mg/dL'),
 ('urea', 'urea mmol/L', 7.0, 19.6, 'BUN mg/dL'),
 ('albumin', 'g/L', 40, 4.0, 'g/dL'),
 ('calcium', 'mmol/L', 2.5, 10.02, 'mg/dL'),
 ('bilirubin', 'µmol/L', 17.1, 1.0, 'mg/dL'),
 ('cholesterol', 'mmol/L', 5.0, 193.35, 'mg/dL'),
 ('triglycerides', 'mmol/L', 1.7, 150.569, 'mg/dL'),
 ('haemoglobin', 'g/L', 120, 12.0, 'g/dL'),
 ('hba1c', 'mmol/mol', 53, 6.999, '%'),
 ('vitamin_d', 'nmol/L', 75, 30.048, 'ng/mL'),
 ('uric_acid', 'µmol/L', 357, 6.002, 'mg/dL'),
 ('magnesium', 'mmol/L', 1.0, 2.431, 'mg/dL'),
 ('phosphate', 'mmol/L', 1.0, 3.097, 'mg/dL'),
 ('iron', 'µmol/L', 20, 111.7, 'µg/dL'),
 ('lactate', 'mmol/L', 2, 18.016, 'mg/dL'),
 ('ammonia', 'µmol/L', 30, 51.09, 'µg/dL'),
 ('vitamin_b12', 'pmol/L', 200, 271.0, 'pg/mL'),
 ('free_t4', 'pmol/L', 12.87, 1.0, 'ng/dL'),
]
write('lab_units', 'Standard SI conversion factors (e.g. AMA Manual of Style SI table); HbA1c by IFCC–NGSP master equation', 
      [{'name': f'{q} {v} {u} → {bu}', 'quantity': q, 'unit': u, 'value': v, 'base': b} for q, u, v, b, bu in lab])

# ================= Batch 2 =================
# HAS-BLED (Pisters 2010)
hb = ['h','renal','liver','stroke','bleed','inr','elderly','drugs','alcohol']
def hbi(*on): return {k: (k in on) for k in hb}
write('hasbled', 'HAS-BLED point table (Pisters 2010), by hand', [
  {'name': 'none', 'inputs': hbi(), 'expect': {'headline': '0', 'band': 'Low to moderate bleeding risk'}},
  {'name': 'elderly + drugs', 'inputs': hbi('elderly','drugs'), 'expect': {'headline': '2', 'band': 'Low to moderate bleeding risk'}},
  {'name': 'elderly + drugs + inr', 'inputs': hbi('elderly','drugs','inr'), 'expect': {'headline': '3', 'band': 'High bleeding risk'}},
  {'name': 'all 9', 'inputs': hbi(*hb), 'expect': {'headline': '9', 'band': 'High bleeding risk'}},
])

# QTc
def qtc(qt, hr, f):
    rr = 60/hr
    return qt/math.sqrt(rr) if f == 0 else qt/rr**(1/3)
cases = []
def qband(v, sex):
    lim = 460 if sex else 450
    return '500 ms or more: markedly prolonged' if v >= 500 else (f"Prolonged ({'female' if sex else 'male'} limit {lim} ms)" if v >= lim else 'Within normal limits')
for qt, hr, sex, f in [(400, 60, 0, 0), (400, 80, 0, 0), (400, 80, 1, 0), (420, 80, 1, 1), (440, 100, 0, 0), (360, 120, 0, 1), (380, 75, 0, 0)]:
    v = qtc(qt, hr, f)
    band = qband(v, sex)
    cases.append({'name': f'QT {qt} HR {hr} sex {sex} f {f} → {v:.1f}', 'inputs': {'qt': qt, 'hr': hr, 'sex': sex, 'formula': f},
                  'expect': {'headline': r(v), 'band': band}})
write('qtc', 'Bazett and Fridericia formulas; AHA/ACCF/HRS 2009 limits; reference implementation', cases)

# Wells / PERC
dvt = ['d_cancer','d_paralysis','d_bed','d_tender','d_leg','d_calf','d_pitting','d_collateral','d_prior','d_alt']
pe = ['p_dvt','p_likely','p_hr','p_immob','p_prior','p_haemoptysis','p_cancer']
perc = ['r_age','r_hr','r_sat','r_leg','r_haemoptysis','r_surgery','r_prior','r_hormone']
def w(test, *on):
    d = {k: (k in on) for k in dvt+pe+perc}; d['test'] = test; return d
write('wells_perc', 'Wells 2000/2003 and PERC 2004 point tables, by hand', [
  {'name': 'DVT: tender + calf', 'inputs': w(0,'d_tender','d_calf'), 'expect': {'headline': '2', 'band': 'DVT likely'}},
  {'name': 'DVT: tender + calf + alternative', 'inputs': w(0,'d_tender','d_calf','d_alt'), 'expect': {'headline': '0', 'band': 'DVT unlikely'}},
  {'name': 'DVT: alternative only = −2', 'inputs': w(0,'d_alt'), 'expect': {'headline': '-2', 'band': 'DVT unlikely'}},
  {'name': 'PE: HR + immob + haemoptysis = 4', 'inputs': w(1,'p_hr','p_immob','p_haemoptysis'), 'expect': {'headline': '4', 'band': 'PE unlikely', 'detail': 'moderate clinical probability'}},
  {'name': 'PE: likely + HR = 4.5', 'inputs': w(1,'p_likely','p_hr'), 'expect': {'headline': '4.5', 'band': 'PE likely'}},
  {'name': 'PE: all = 12.5', 'inputs': w(1,*pe), 'expect': {'headline': '12.5', 'band': 'PE likely', 'detail': 'high clinical probability'}},
  {'name': 'PERC: none', 'inputs': w(2), 'expect': {'headline': 'PERC negative'}},
  {'name': 'PERC: age only', 'inputs': w(2,'r_age'), 'expect': {'headline': 'PERC positive', 'band': '1 of 8 criteria present'}},
  {'name': 'PERC ignores DVT items', 'inputs': w(2,'d_cancer','p_dvt'), 'expect': {'headline': 'PERC negative'}},
])

# CURB-65
def curb(conf, bun, rr, sbp, dbp, age):
    d = {'confusion': conf, 'rr': rr, 'sbp': sbp, 'dbp': dbp, 'age': age}
    if bun is not None: d['urea'] = bun
    return d
write('curb65', 'Lim 2003 CURB-65; urea >7 mmol/L = BUN >19.6 mg/dL; by hand', [
  {'name': 'healthy 40 y, BUN 12', 'inputs': curb(False, 12, 18, 120, 80, 40), 'expect': {'headline': '0', 'band': 'Low severity (CURB-65 0–1)'}},
  {'name': 'BUN exactly 19.6 does not count', 'inputs': curb(False, 19.6, 18, 120, 80, 40), 'expect': {'headline': '0'}},
  {'name': 'BUN 20 counts (urea mg/dL 42.8)', 'inputs': curb(False, 20, 18, 120, 80, 40), 'expect': {'headline': '1'}},
  {'name': 'age 70, RR 30', 'inputs': curb(False, 10, 30, 120, 80, 70), 'expect': {'headline': '2', 'band': 'Moderate severity (CURB-65 2)'}},
  {'name': 'DBP 60 counts', 'inputs': curb(True, 25, 32, 100, 60, 80), 'expect': {'headline': '5', 'band': 'High severity (CURB-65 3–5)'}},
  {'name': 'CRB-65 without urea: age 70', 'inputs': curb(False, None, 18, 120, 80, 70), 'expect': {'headline': '1', 'band': 'Intermediate risk (CRB-65 1–2)'}},
  {'name': 'CRB-65 0', 'inputs': curb(False, None, 18, 120, 80, 30), 'expect': {'headline': '0', 'band': 'Low risk (CRB-65 0)'}},
])

# qSOFA
write('qsofa', 'Seymour 2016, by hand', [
  {'name': 'none', 'inputs': {'rr': False, 'mental': False, 'sbp': False}, 'expect': {'headline': '0', 'band': 'qSOFA negative'}},
  {'name': 'RR + SBP', 'inputs': {'rr': True, 'mental': False, 'sbp': True}, 'expect': {'headline': '2', 'band': 'qSOFA positive'}},
])

# GCS
write('gcs', 'Teasdale 1974, by hand', [
  {'name': 'E4 V5 M6', 'inputs': {'e': 4, 'v': 5, 'm': 6}, 'expect': {'headline': '15', 'band': 'Mild (13–15)'}},
  {'name': 'E3 V4 M6 = 13', 'inputs': {'e': 3, 'v': 4, 'm': 6}, 'expect': {'headline': '13', 'band': 'Mild (13–15)'}},
  {'name': 'E2 V3 M5 = 10', 'inputs': {'e': 2, 'v': 3, 'm': 5}, 'expect': {'headline': '10', 'band': 'Moderate (9–12)'}},
  {'name': 'E2 V2 M4 = 8', 'inputs': {'e': 2, 'v': 2, 'm': 4}, 'expect': {'headline': '8', 'band': 'Severe (8 or less)'}},
  {'name': 'E1 V1 M1 = 3', 'inputs': {'e': 1, 'v': 1, 'm': 1}, 'expect': {'headline': '3', 'band': 'Severe (8 or less)'}},
])

# NEWS2 (RCP 2017 chart)
def n2(rr, spo2, scale, o2, sbp, pulse, acvpu, temp):
    return {'rr': rr, 'spo2': spo2, 'scale': scale, 'o2': o2, 'sbp': sbp, 'pulse': pulse, 'acvpu': acvpu, 'temp': temp}
write('news2', 'RCP NEWS2 chart 2017, by hand', [
  {'name': 'all normal', 'inputs': n2(16, 98, 0, 0, 120, 70, 0, 37.0), 'expect': {'headline': '0', 'band': 'Low clinical risk (0)'}},
  {'name': 'RR 22, pulse 95, temp 38.5 = 4', 'inputs': n2(22, 96, 0, 0, 120, 95, 0, 38.5), 'expect': {'headline': '4', 'band': 'Low clinical risk (1–4)'}},
  {'name': 'single 3 (RR 26)', 'inputs': n2(26, 98, 0, 0, 120, 70, 0, 37.0), 'expect': {'headline': '3', 'band': 'Low–medium clinical risk (a single parameter scored 3)'}},
  {'name': 'O2 + SpO2 94 + SBP 105 + pulse 112 = 2+1+1+2 = 6', 'inputs': n2(18, 94, 0, 2, 105, 112, 0, 37.0), 'expect': {'headline': '6', 'band': 'Medium clinical risk (5–6)'}},
  {'name': 'sick: RR 30, SpO2 90, O2, SBP 88, P 135, confused, 39.5 = 3+3+2+3+3+3+2 = 19', 'inputs': n2(30, 90, 0, 2, 88, 135, 3, 39.5), 'expect': {'headline': '19', 'band': 'High clinical risk (7 or more)'}},
  {'name': 'scale 2: SpO2 90 on air = 0', 'inputs': n2(16, 90, 1, 0, 120, 70, 0, 37.0), 'expect': {'headline': '0'}},
  {'name': 'scale 2: SpO2 97 on O2 = 3 + O2 2 = 5', 'inputs': n2(16, 97, 1, 2, 120, 70, 0, 37.0), 'expect': {'headline': '5'}},
  {'name': 'boundaries: RR 8, SBP 220, temp 35.0', 'inputs': n2(8, 96, 0, 0, 220, 70, 0, 35.0), 'expect': {'headline': '9'}},
])

# Anion gap, corrected Ca, corrected Na, osmolality
write('anion_gap', 'AG = Na − (Cl + HCO3); Figge correction; by hand', [
  {'name': '140/104/24 = 12', 'inputs': {'na': 140, 'cl': 104, 'hco3': 24}, 'expect': {'headline': '12', 'band': 'Within usual range (3–12)'}},
  {'name': 'DKA 135/100/10 = 25', 'inputs': {'na': 135, 'cl': 100, 'hco3': 10}, 'expect': {'headline': '25', 'band': 'Raised (above 12)'}},
  {'name': 'AG 10 with albumin 2.0 → corrected 15', 'inputs': {'na': 140, 'cl': 106, 'hco3': 24, 'alb': 2.0}, 'expect': {'headline': '10', 'band': 'Raised (above 12)', 'detail': '15 mmol/L'}},
])
write('corrected_calcium', 'Payne 1973, by hand', [
  {'name': 'Ca 8.0, alb 2.5 → 9.2', 'inputs': {'ca': 8.0, 'alb': 2.5}, 'expect': {'headline': '9.2', 'band': 'Within usual range (8.5–10.5)'}},
  {'name': 'Ca 7.0, alb 3.5 → 7.4', 'inputs': {'ca': 7.0, 'alb': 3.5}, 'expect': {'headline': '7.4', 'band': 'Low (below 8.5 mg/dL)'}},
  {'name': 'Ca 10.2, alb 3.0 → 11', 'inputs': {'ca': 10.2, 'alb': 3.0}, 'expect': {'headline': '11', 'band': 'High (above 10.5 mg/dL)'}},
])
write('corrected_sodium', 'Hillier 1999 (2.4) and Katz 1973 (1.6), by hand', [
  {'name': 'Na 130, glucose 600 → Hillier 142, Katz 138', 'inputs': {'na': 130, 'glu': 600}, 'expect': {'headline': '142', 'detail': 'Katz (1.6 per 100 mg/dL): 138'}},
  {'name': 'Na 125, glucose 100 → 125', 'inputs': {'na': 125, 'glu': 100}, 'expect': {'headline': '125', 'band': 'Low (below 135)'}},
  {'name': 'glucose below 100 → no correction', 'inputs': {'na': 140, 'glu': 80}, 'expect': {'headline': '140'}},
])
write('osmolality', '2Na + glu/18 + BUN/2.8, by hand', [
  {'name': '140, 90, 14 → 290', 'inputs': {'na': 140, 'glu': 90, 'bun': 14}, 'expect': {'headline': '290', 'band': 'Within usual range (275–295)'}},
  {'name': 'gap 300 − 290 = 10', 'inputs': {'na': 140, 'glu': 90, 'bun': 14, 'measured': 300}, 'expect': {'detail': 'Osmolal gap: 10'}},
  {'name': 'gap 320 − 290 = 30', 'inputs': {'na': 140, 'glu': 90, 'bun': 14, 'measured': 320}, 'expect': {'detail': 'Osmolal gap: 30'}},
])

# ================= Batch 3 =================
import datetime as dt
def d(y, m, dd): return dt.date(y, m, dd).isoformat()
def ga_case(name, today, lmp=None, scan=None, w=None, days=None):
    if lmp is None:
        lmp_d = dt.date.fromisoformat(scan) - dt.timedelta(days=w*7 + (days or 0))
        inputs = {'method': 1, 'scan': scan, 'scan_w': w, 'today': today}
        if days is not None: inputs['scan_d'] = days
    else:
        lmp_d = dt.date.fromisoformat(lmp); inputs = {'method': 0, 'lmp': lmp, 'today': today}
    ga = (dt.date.fromisoformat(today) - lmp_d).days
    edd = lmp_d + dt.timedelta(days=280)
    mon = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][edd.month-1]
    return {'name': name, 'inputs': inputs, 'expect': {'headline': f'{ga//7}w {ga%7}d', 'detail': f'Due date: {edd.day} {mon} {edd.year}'}}
write('gestational_age', 'Naegele rule LMP + 280 days; Python datetime reference', [
  ga_case('LMP 1 Jan 2026, today 9 Nov 2026', d(2026,11,9), lmp=d(2026,1,1)),
  ga_case('LMP 15 Jun 2026, today 9 Nov 2026', d(2026,11,9), lmp=d(2026,6,15)),
  ga_case('across leap day: LMP 1 Feb 2028', d(2028,5,1), lmp=d(2028,2,1)),
  ga_case('scan 1 Sep 2026 at 12w 3d', d(2026,11,9), scan=d(2026,9,1), w=12, days=3),
  ga_case('scan without days', d(2026,11,9), scan=d(2026,10,1), w=20),
])
def bishop(dl, ef, st, co, po): return {'dilation': dl, 'effacement': ef, 'station': st, 'consistency': co, 'position': po}
write('bishop', 'Bishop 1964 table, by hand', [
  {'name': 'all lowest = 0', 'inputs': bishop(0,0,0,0,0), 'expect': {'headline': '0', 'band': 'Unfavourable cervix (6 or less)'}},
  {'name': '1+1+2+1+1 = 6', 'inputs': bishop(1,1,2,1,1), 'expect': {'headline': '6', 'band': 'Unfavourable cervix (6 or less)'}},
  {'name': '= 7', 'inputs': bishop(2,1,2,1,1), 'expect': {'headline': '7', 'band': 'Intermediate (7)'}},
  {'name': '2+2+2+1+1 = 8', 'inputs': bishop(2,2,2,1,1), 'expect': {'headline': '8', 'band': 'Favourable cervix (8 or more)'}},
  {'name': 'max 13', 'inputs': bishop(3,3,3,2,2), 'expect': {'headline': '13'}},
])
def hs(kg):
    day = 100*kg if kg <= 10 else 1000+50*(kg-10) if kg <= 20 else 1500+20*(kg-20)
    return {'name': f'{kg} kg', 'inputs': {'weight': kg}, 'expect': {'headline': r(day/24), 'band': f'{r(day)} mL per 24 hours'}}
write('holliday_segar', 'Holliday-Segar 1957; 4-2-1 check: 25 kg = 65 mL/h', [hs(5), hs(10), hs(15), hs(20), hs(25), hs(70)])
def pk(kg, tbsa=None, regions=()):
    inp = {'weight': kg}
    if tbsa is not None: inp.update({'method': 0, 'tbsa': tbsa}); t = tbsa
    else:
        pts = {'head':9,'r_arm':9,'l_arm':9,'front':18,'back':18,'r_leg':18,'l_leg':18,'perineum':1}
        inp['method'] = 1; t = 0
        for k in pts: inp[k] = k in regions; t += pts[k] if k in regions else 0
    tot = 4*kg*t
    return {'name': f'{kg} kg {t}%', 'inputs': inp, 'expect': {'headline': r(tot), 'band': f'TBSA {r(t)}%', 'detail': f'First 8 hours: {r(tot/2)} mL ({r(tot/16)} mL/h)'}}
write('parkland', 'Parkland 4 mL/kg/%TBSA; classic example 70 kg 30% = 8400 mL', [pk(70, 30), pk(80, regions=('front','r_arm')), pk(20, 12)])
def dh(kg, months, g, e, dr, p): return {'weight': kg, 'age': months, 'general': g, 'eyes': e, 'drink': dr, 'pinch': p}
write('dehydration', 'WHO 2005 / IMCI 2014 classification and plan volumes, by hand', [
  {'name': 'well → Plan A', 'inputs': dh(10, 18, 0,0,0,0), 'expect': {'headline': 'No dehydration', 'band': 'Plan A: treat at home'}},
  {'name': 'one some-sign only → Plan A', 'inputs': dh(10, 18, 1,0,0,0), 'expect': {'headline': 'No dehydration'}},
  {'name': 'restless + sunken → Plan B 750 mL', 'inputs': dh(10, 18, 1,1,0,0), 'expect': {'headline': 'Some dehydration', 'band': 'Plan B: ORS in the clinic'}},
  {'name': 'lethargic + slow pinch → some', 'inputs': dh(10, 18, 2,0,0,1), 'expect': {'headline': 'Some dehydration'}},
  {'name': 'lethargic + sunken → Plan C, 8 months', 'inputs': dh(8, 8, 2,1,0,0), 'expect': {'headline': 'Severe dehydration', 'detail': 'Under 12 months: 240 mL in the first 1 hour, then 560 mL'}},
  {'name': 'drinks poorly + very slow pinch, 3 y', 'inputs': dh(14, 36, 0,0,2,2), 'expect': {'headline': 'Severe dehydration', 'detail': '12 months or older: 420 mL in the first 30 minutes, then 980 mL'}},
])
def fib(ctx, age, ast, alt, uln, plt):
    f = age*ast/(plt*math.sqrt(alt)); a = ast/uln/plt*100
    masld = ctx == 1
    low = (2.0 if age >= 65 else 1.3) if masld else 1.45; high = 2.67 if masld else 3.25
    band = (f'Low risk of advanced fibrosis (below {r(low,2)})' if f < low else f'High risk of advanced fibrosis (above {r(high,2)})' if f > high
            else f'Indeterminate ({r(low,2)}–{r(high,2)})')
    return {'name': f'ctx{ctx} {age}y AST{ast} ALT{alt} plt{plt} → FIB4 {f:.3f} APRI {a:.3f}',
            'inputs': {'context': ctx, 'age': age, 'ast': ast, 'alt': alt, 'uln': uln, 'plt': plt},
            'expect': {'headline': r(f, 2), 'band': band, 'detail': f'APRI {r(a, 2)}'}}
write('apri_fib4', 'Sterling 2006 / Wai 2003 formulas, reference implementation', [
  fib(0, 50, 40, 40, 40, 250), fib(0, 55, 90, 80, 40, 120), fib(0, 60, 120, 60, 40, 60),
  fib(1, 45, 30, 50, 40, 220), fib(1, 70, 45, 40, 40, 160), fib(1, 50, 60, 70, 40, 140)])
def a1c(x):
    e = 28.7*x - 46.7
    band = 'Diabetes range (6.5% or more)' if x >= 6.5 else 'Prediabetes range (5.7–6.4%)' if x >= 5.7 else 'Normal range (below 5.7%)'
    return {'name': f'{x}%', 'inputs': {'a1c': x}, 'expect': {'headline': r(e), 'band': band}}
write('a1c_eag', 'ADAG 2008: 7% = 154 mg/dL, 6% = 126 mg/dL', [a1c(5.0), a1c(5.7), a1c(6.0), a1c(6.5), a1c(7.0), a1c(9.0)])
write('drip_rate', 'mL/h = V/t; drops/min = mL/h × factor / 60; by hand', [
  {'name': '1000 mL over 8 h, 20 drop set', 'inputs': {'volume': 1000, 'time': 8, 'factor': 20}, 'expect': {'headline': '125', 'band': '42 drops/min'}},
  {'name': '500 mL over 4 h, 15 drop set', 'inputs': {'volume': 500, 'time': 4, 'factor': 15}, 'expect': {'headline': '125', 'band': '31 drops/min'}},
  {'name': '100 mL over 30 min, 60 micro', 'inputs': {'volume': 100, 'time': 0.5, 'factor': 60}, 'expect': {'headline': '200', 'band': '200 drops/min'}},
])

# ================= Public mode =================
write('p_units', 'Exact definitions: 1 in = 2.54 cm, 1 lb = 0.45359237 kg, °F = °C × 9/5 + 32; glucose 18.016', [
  {'name': '5.5 mmol/L', 'quantity': 'glucose', 'unit': 'mmol/L', 'value': 5.5, 'base': 99.088},
  {'name': '98.6 °F = 37 °C', 'quantity': 'temperature', 'unit': '°F', 'value': 98.6, 'base': 37.0},
  {'name': '104 °F = 40 °C', 'quantity': 'temperature', 'unit': '°F', 'value': 104, 'base': 40.0},
  {'name': '5.5 ft = 167.64 cm', 'quantity': 'height', 'unit': 'ft', 'value': 5.5, 'base': 167.64},
  {'name': '66 in = 167.64 cm', 'quantity': 'height', 'unit': 'in', 'value': 66, 'base': 167.64},
  {'name': '154 lb = 69.85 kg', 'quantity': 'weight', 'unit': 'lb', 'value': 154, 'base': 69.853},
])
def pb(kg, ft=None, inch=None, cm=None, sex=0, waist=None):
    i = {'weight': kg, 'sex': sex}
    if cm is not None: i.update({'hunit': 0, 'height': cm}); h = cm
    else:
        i.update({'hunit': 1, 'feet': ft}); h = (ft*12 + (inch or 0))*2.54
        if inch is not None: i['inches'] = inch
    if waist is not None: i['waist'] = waist
    return i, kg/(h/100)**2
cases = []
for args, band in [((70,), dict(ft=5, inch=6), ), ]: pass
for kwargs, band in [(dict(kg=70, ft=5, inch=6), 'Overweight / at risk'), (dict(kg=80, ft=5, inch=6), 'Obese class I'), (dict(kg=60, ft=5, inch=6), 'Normal'),
                     (dict(kg=63, cm=165), 'Overweight / at risk'), (dict(kg=45, cm=165), 'Underweight')]:
    i, b = pb(**kwargs)
    cases.append({'name': f'{kwargs} → {b:.2f}', 'inputs': i, 'expect': {'headline': r(b, 1), 'band': band}})
i, b = pb(80, cm=170, sex=1, waist=85)
cases.append({'name': 'woman waist 85 ≥ 80', 'inputs': i, 'expect': {'detail': 'is at or above 80 cm'}})
write('p_bmi', 'BMI with WHO 2004 Asian cut-offs; 5 ft 6 in = 167.64 cm; reference implementation', cases)
write('p_diabetes_risk', 'IDRS point table (Mohan 2005), by hand', [
  {'name': 'young, slim, active, no family = 0', 'inputs': {'age': 0, 'waist': 0, 'activity': 0, 'family': 0}, 'expect': {'headline': '0', 'band': 'Low risk'}},
  {'name': '20+10+0+0 = 30 medium', 'inputs': {'age': 20, 'waist': 10, 'activity': 0, 'family': 0}, 'expect': {'headline': '30', 'band': 'Medium risk'}},
  {'name': '30+10+20+0 = 60 high', 'inputs': {'age': 30, 'waist': 10, 'activity': 20, 'family': 0}, 'expect': {'headline': '60', 'band': 'High risk'}},
  {'name': 'max 100', 'inputs': {'age': 30, 'waist': 20, 'activity': 30, 'family': 20}, 'expect': {'headline': '100', 'band': 'High risk'}},
])
def bp(s_, d_, **sym):
    i = {'sbp': s_, 'dbp': d_}
    for k in ['s_chest','s_breath','s_weak','s_vision','s_head']: i[k] = sym.get(k, False)
    return i
write('p_bp', 'AHA/ACC 2025 categories, by hand', [
  {'name': '118/76 normal', 'inputs': bp(118, 76), 'expect': {'headline': '118/76', 'band': 'Normal', 'emergency': False}},
  {'name': '125/78 elevated', 'inputs': bp(125, 78), 'expect': {'band': 'Elevated'}},
  {'name': '128/82 stage 1 (diastolic)', 'inputs': bp(128, 82), 'expect': {'band': 'High: stage 1'}},
  {'name': '145/85 stage 2', 'inputs': bp(145, 85), 'expect': {'band': 'High: stage 2', 'emergency': False}},
  {'name': '180/110 stage 2, not severe', 'inputs': bp(180, 110), 'expect': {'band': 'High: stage 2'}},
  {'name': '190/100 severe, no symptoms', 'inputs': bp(190, 100), 'expect': {'band': 'Severely high', 'emergency': False}},
  {'name': '190/100 + chest pain → emergency', 'inputs': bp(190, 100, s_chest=True), 'expect': {'band': 'Severely high', 'emergency': True}},
  {'name': '130/85 + weakness → emergency', 'inputs': bp(130, 85, s_weak=True), 'expect': {'band': 'High: stage 1', 'emergency': True}},
  {'name': '85/55 low', 'inputs': bp(85, 55), 'expect': {'band': 'Low'}},
])
def sg(g, when, **sym):
    i = {'glu': g, 'when': when}
    for k in ['s_drowsy','s_vomit']: i[k] = sym.get(k, False)
    return i
write('p_sugar', 'ADA 2026 thresholds, by hand', [
  {'name': 'fasting 92', 'inputs': sg(92, 0), 'expect': {'band': 'Normal fasting sugar'}},
  {'name': 'fasting 100', 'inputs': sg(100, 0), 'expect': {'band': 'Raised (prediabetes range)'}},
  {'name': 'fasting 126', 'inputs': sg(126, 0), 'expect': {'band': 'High (diabetes range if repeated)'}},
  {'name': 'after meal 139', 'inputs': sg(139, 1), 'expect': {'band': 'Normal after a meal'}},
  {'name': 'after meal 200', 'inputs': sg(200, 1), 'expect': {'band': 'High (diabetes range if repeated)'}},
  {'name': 'low 65', 'inputs': sg(65, 2), 'expect': {'band': 'Low sugar', 'emergency': False}},
  {'name': 'very low 50', 'inputs': sg(50, 2), 'expect': {'band': 'Very low sugar', 'emergency': False}},
  {'name': 'low 50 + drowsy → emergency', 'inputs': sg(50, 2, s_drowsy=True), 'expect': {'band': 'Very low sugar', 'emergency': True}},
  {'name': '350 + vomiting → emergency', 'inputs': sg(350, 2, s_vomit=True), 'expect': {'band': 'Very high sugar', 'emergency': True}},
  {'name': '350 no symptoms', 'inputs': sg(350, 2), 'expect': {'band': 'High', 'emergency': False}},
])
pdd = ga_case('LMP 1 Jun 2026', d(2026,11,9), lmp=d(2026,6,1))
edd = dt.date(2026,6,1) + dt.timedelta(days=280)
ga = (dt.date(2026,11,9) - dt.date(2026,6,1)).days
write('p_due_date', 'LMP + 280 days; Python datetime reference', [
  {'name': 'LMP 1 Jun 2026', 'inputs': {'lmp': d(2026,6,1), 'today': d(2026,11,9)},
   'expect': {'headline': f"{edd.day} {['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][edd.month-1]} {edd.year}",
              'band': f'You are {ga//7} weeks {ga%7} days pregnant'}},
])
def hi_f(t, rh):
    s_ = 0.5*(t + 61 + (t-68)*1.2 + rh*0.094)
    if (s_ + t)/2 < 80: return s_
    h = (-42.379 + 2.04901523*t + 10.14333127*rh - .22475541*t*rh - .00683783*t*t - .05481717*rh*rh
         + .00122874*t*t*rh + .00085282*t*rh*rh - .00000199*t*t*rh*rh)
    if rh < 13 and 80 <= t <= 112: h -= ((13-rh)/4)*math.sqrt((17-abs(t-95))/17)
    elif rh > 85 and 80 <= t <= 87: h += ((rh-85)/10)*((87-t)/5)
    return h
def hband(h): return ('Extreme danger' if h >= 125 else 'Danger' if h >= 103 else 'Extreme caution' if h >= 90 else 'Caution' if h >= 80 else 'Low heat risk')
cases = []
for c, rh in [(25, 40), (32, 50), (35, 60), (40, 30), (45, 10), (29, 90), (38, 70)]:
    h = hi_f(c*9/5+32, rh)
    cases.append({'name': f'{c} °C {rh}% → {h:.1f} °F', 'inputs': {'temp': c, 'rh': rh, 's_confused': False, 's_hot': False},
                  'expect': {'headline': r((h-32)*5/9), 'band': hband(h), 'emergency': False}})
cases.append({'name': 'heat-stroke signs → emergency', 'inputs': {'temp': 40, 'rh': 30, 's_confused': True, 's_hot': False}, 'expect': {'emergency': True}})
write('p_heat', 'NWS heat index algorithm (wpc.ncep.noaa.gov), reference implementation; NWS table: 96 °F 65% ≈ 121 °F', cases)

# ================= Dengue and Ramadan =================
ws = ['w_abdo','w_vomit','w_fluid','w_mucosal','w_lethargy','w_liver','w_hct']
sv = ['s_shock','s_hypo','s_resp','s_bleed','s_organ']
def dg(kg, group=0, sex=0, height=None, *on):
    i = {'weight': kg, 'group': group, 'sex': sex}
    if height is not None: i['height'] = height
    for k in ws + sv: i[k] = k in on
    return i
ibw_m170 = 50 + 0.91*(170-152.4)   # 66.016
write('dengue', 'WHO 2009 / WHO 2012 handbook regimens (verified 9 Nov 2026), by hand', [
  {'name': 'no signs → Group A', 'inputs': dg(60), 'expect': {'headline': 'Dengue without warning signs'}},
  {'name': 'warning sign, 60 kg → 300–420 mL/h', 'inputs': dg(60, 0, 0, None, 'w_vomit'), 'expect': {'headline': 'Dengue with warning signs', 'band': '1 warning sign (WHO Group B)'}},
  {'name': 'warning first step text', 'inputs': dg(60, 0, 0, None, 'w_vomit', 'w_abdo'), 'expect': {'band': '2 warning signs (WHO Group B)', 'detail': '3–5 mL/kg/h = 180–300 mL/h'}},
  {'name': 'obese adult uses IBW 66.0 kg', 'inputs': dg(100, 0, 0, 170, 'w_vomit'), 'expect': {'detail': 'Using ideal body weight 66 kg'}},
  {'name': 'compensated shock adult 60 kg', 'inputs': dg(60, 0, 0, None, 's_shock'), 'expect': {'band': 'Compensated shock', 'detail': 'second bolus 10–20 mL/kg/h for 1 h (10–20 mL/kg/h = 600–1200 mL/h)'}},
  {'name': 'hypotensive shock child 20 kg', 'inputs': dg(20, 1, 0, None, 's_hypo'), 'expect': {'band': 'Hypotensive shock', 'detail': 'colloid 10 mL/kg/h for 1 h (200 mL/h)'}},
  {'name': 'severe bleeding without shock', 'inputs': dg(60, 0, 0, None, 's_bleed'), 'expect': {'band': 'Severe dengue without shock'}},
])
base = {'pregnancy': False, 'type': 0, 'duration': 0, 'hypo': 0, 'hba1c': 0, 'smbg': 0, 'cgm': False, 'dka': 0,
        'macro': 0, 'egfr': 0, 'micro': 0, 'frailty': 0, 'labour': 0, 'education': 0, 'hours': 0}
for t in ['t_mdi_premix','t_od_premix','t_pump','t_aid','t_basal','t_ultralong','t_short','t_glib','t_glic','t_multi']: base[t] = False
def rm(**kw): d = dict(base); d.update(kw); return d
write('ramadan_risk', 'IDF-DAR 2026 Fig. 1 point values (verified 9 Nov 2026), by hand', [
  {'name': 'all zero', 'inputs': rm(), 'expect': {'headline': '0', 'band': 'Low risk'}},
  {'name': 'basal 1 + gliclazide 0.5 + HbA1c 8% 0.5 + 16 h 1 + no education 1 + 10-20 y 0.5 = 4.5', 'inputs': rm(t_basal=True, t_glic=True, hba1c=0.5, hours=1, education=1, duration=0.5),
   'expect': {'headline': '4.5', 'band': 'Moderate risk'}},
  {'name': 'exactly 3 = low', 'inputs': rm(t_mdi_premix=True, education=1), 'expect': {'headline': '3', 'band': 'Low risk'}},
  {'name': '3.5 = moderate', 'inputs': rm(t_mdi_premix=True, education=1, duration=0.5), 'expect': {'headline': '3.5', 'band': 'Moderate risk'}},
  {'name': 'CGM gives 3.25 → moderate (assumption)', 'inputs': rm(t_mdi_premix=True, education=1, t_short=True, cgm=True), 'expect': {'headline': '3.25', 'band': 'Moderate risk'}},
  {'name': 'pregnancy alone 6.5 = high', 'inputs': rm(pregnancy=True), 'expect': {'headline': '6.5', 'band': 'High risk', 'detail': 'may choose not to fast'}},
  {'name': 'exactly 6 = moderate', 'inputs': rm(labour=4, smbg=2), 'expect': {'headline': '6', 'band': 'Moderate risk'}},
])
dd = ['d_belly','d_vomit','d_bleed','d_tired','d_cold','d_breath','d_urine']
def pdg(*on):
    i = {k: k in on for k in dd}; i['fever'] = 'fever' in on; return i
write('p_dengue', 'WHO 2009 warning signs in plain words, by hand', [
  {'name': 'fever, no danger', 'inputs': pdg('fever'), 'expect': {'headline': 'No danger signs now', 'emergency': False}},
  {'name': 'bleeding → emergency', 'inputs': pdg('fever','d_bleed'), 'expect': {'headline': 'Danger signs', 'emergency': True}},
])
hi_ = ['r_preg','r_hypo','r_dka','r_kidney','r_heart','r_frail']; mo = ['r_insulin','r_type1','r_lows','r_work','r_tablets']
def pr(*on): return {k: k in on for k in hi_ + mo}
write('p_ramadan', 'Checklist logic, by hand', [
  {'name': 'nothing ticked', 'inputs': pr(), 'expect': {'headline': 'Lower risk'}},
  {'name': 'insulin', 'inputs': pr('r_insulin'), 'expect': {'headline': 'Talk to your doctor first'}},
  {'name': 'dialysis', 'inputs': pr('r_kidney','r_insulin'), 'expect': {'headline': 'Fasting may be unsafe'}},
])

# ================= WHO growth =================
W = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'assets', 'who_growth.json')))
def lms(key, x):
    rows = W[key]['rows']
    for a, b in zip(rows, rows[1:]):
        if a[0] <= x <= b[0]:
            t = 0 if b[0] == a[0] else (x - a[0]) / (b[0] - a[0])
            return [a[i] + (b[i]-a[i])*t for i in (1, 2, 3)]
    if abs(x - rows[-1][0]) < 1e-9: return rows[-1][1:]
def zplain(X, L, M, S): return ((X/M)**L - 1)/(L*S)
def zr(X, L, M, S):
    z = zplain(X, L, M, S)
    sd = lambda k: M*(1+L*S*k)**(1/L)
    if z > 3: return 3 + (X - sd(3))/(sd(3) - sd(2))
    if z < -3: return -3 + (X - sd(-3))/(sd(-2) - sd(-3))
    return z
def zs(z): return ('+' if z >= 0 else '−') + r(abs(z), 2)
def growth(name, girl, months, kg, cm, standing=None, muac=None, oedema=False, band=None):
    days = months*30.4375; g = 'girls' if girl else 'boys'
    standing = (months >= 24) if standing is None else standing
    l = cm + (0.7 if days < 731 and standing else -0.7 if days >= 731 and not standing else 0)
    waz = zr(kg, *lms('wfa_'+g, round(days)))
    wh = lms(('wfl_' if days < 731 else 'wfh_')+g, round(l*10)/10)
    whz = zr(kg, *wh)
    inp = {'sex': 1 if girl else 0, 'agemode': 1, 'months': months, 'weight': kg, 'length': cm, 'measured': 1 if standing else 0, 'oedema': oedema}
    if muac is not None: inp['muac'] = muac
    e = {'headline': zs(whz), 'detail': 'Weight-for-age: ' + zs(waz)}
    if band: e['band'] = band
    return {'name': f'{name}: WAZ {waz:.3f} WHZ {whz:.3f}', 'inputs': inp, 'expect': e}
write('who_growth', 'Independent LMS implementation on the WHO 2006 expanded tables; sanity: boy at birth 3.3464 kg = median', [
  growth('newborn boy at median', False, 0, 3.3464, 49.9),
  growth('12-month boy 9.6 kg 75.7 cm', False, 12, 9.6, 75.7, band='Within normal range'),
  growth('18-month girl wasted', True, 18, 8.0, 80.0),
  growth('3-year boy SAM by WHZ', False, 36, 10.0, 95.0, band='Severe acute malnutrition (SAM)'),
  growth('2-year girl measured lying', True, 30, 12.0, 90.0, standing=False),
  growth('MUAC 11.0 → SAM', False, 24, 11.5, 85.0, muac=11.0, band='Severe acute malnutrition (SAM)'),
  growth('oedema → SAM', True, 20, 10.0, 80.0, oedema=True, band='Severe acute malnutrition (SAM)'),
  growth('overweight 4-year girl', True, 48, 22.0, 102.0),
])
print('golden files written')
