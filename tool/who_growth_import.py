#!/usr/bin/env python3
"""Turn WHO Child Growth Standards expanded z-score tables (xlsx, who.int)
into assets/who_growth.json with only the L, M, S columns.

Usage: python3 -I tool/who_growth_import.py <folder with the 8 xlsx files>
"""
import json, os, sys
import re, zipfile
import xml.etree.ElementTree as ET

NS = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}

def read_xlsx(path):
    """Minimal stdlib reader: first worksheet as a list of row tuples."""
    z = zipfile.ZipFile(path)
    shared = []
    if 'xl/sharedStrings.xml' in z.namelist():
        for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('m:si', NS):
            shared.append(''.join(t.text or '' for t in si.iter('{%s}t' % NS['m'])))
    sheet = sorted(n for n in z.namelist() if n.startswith('xl/worksheets/sheet'))[0]
    rows = []
    for row in ET.fromstring(z.read(sheet)).iter('{%s}row' % NS['m']):
        vals = {}
        for c in row.findall('m:c', NS):
            col = re.match(r'[A-Z]+', c.get('r')).group()
            idx = 0
            for ch in col: idx = idx * 26 + ord(ch) - 64
            v = c.find('m:v', NS)
            if v is None:
                t = c.find('.//m:t', NS); val = t.text if t is not None else None
            elif c.get('t') == 's': val = shared[int(v.text)]
            elif c.get('t') in ('str', 'inlineStr'): val = v.text
            else: val = float(v.text)
            vals[idx - 1] = val
        if vals: rows.append(tuple(vals.get(i) for i in range(max(vals) + 1)))
    return rows

src = sys.argv[1]
files = {
    'wfa_boys': 'wfa-boys-zscore-expanded-tables.xlsx', 'wfa_girls': 'wfa-girls-zscore-expanded-tables.xlsx',
    'lhfa_boys': 'lhfa-boys-zscore-expanded-tables.xlsx', 'lhfa_girls': 'lhfa-girls-zscore-expanded-tables.xlsx',
    'wfl_boys': 'wfl-boys-zscore-expanded-table.xlsx', 'wfl_girls': 'wfl-girls-zscore-expanded-table.xlsx',
    'wfh_boys': 'wfh-boys-zscore-expanded-tables.xlsx', 'wfh_girls': 'wfh-girls-zscore-expanded-tables.xlsx',
}
out = {'source': 'WHO Child Growth Standards 2006, expanded z-score tables (who.int, downloaded 9 Nov 2026)'}
for key, name in files.items():
    rows = read_xlsx(os.path.join(src, name))
    head = [str(h).strip() if h is not None else '' for h in rows[0]]
    if len(sys.argv) > 2: print(key, head[:6], rows[1][:6])
    ix, il, im, is_ = 0, head.index('L'), head.index('M'), head.index('S')
    table = []
    for r in rows[1:]:
        if r[ix] is None: continue
        table.append([float(r[ix]), round(float(r[il]), 5), round(float(r[im]), 5), round(float(r[is_]), 6)])
    out[key] = {'x': head[0], 'rows': table}
    print(key, head[0], len(table), table[0], table[-1])
dst = os.path.join(os.path.dirname(__file__), '..', 'assets', 'who_growth.json')
os.makedirs(os.path.dirname(dst), exist_ok=True)
with open(dst, 'w') as f: json.dump(out, f, separators=(',', ':'))
print('wrote', dst, os.path.getsize(dst))
