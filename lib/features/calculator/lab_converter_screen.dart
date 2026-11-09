import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calc/model.dart';
import '../../calc/units.dart';
import '../../shared/readable_width.dart';

/// D28: conventional (mg/dL, g/dL…) ↔ SI (mmol/L, µmol/L, g/L). Typing in any
/// unit's box updates the others.
class LabConverterScreen extends StatefulWidget {
  const LabConverterScreen({super.key});

  @override
  State<LabConverterScreen> createState() => _LabConverterScreenState();
}

class _LabConverterScreenState extends State<LabConverterScreen> {
  Quantity _test = kLabConverterTests.first;
  final List<TextEditingController> _fields = [];

  @override
  void initState() {
    super.initState();
    _resetFields();
  }

  void _resetFields() {
    for (final c in _fields) {
      c.dispose();
    }
    _fields
      ..clear()
      ..addAll(_test.units.map((_) => TextEditingController()));
  }

  @override
  void dispose() {
    for (final c in _fields) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String raw) {
    final v = double.tryParse(raw.trim().replaceAll(',', '.'));
    for (var i = 0; i < _fields.length; i++) {
      if (i == index) continue;
      _fields[i].text = v == null
          ? ''
          : fmt(_test.units[i].fromBase(_test.units[index].toBase(v)), 3);
    }
  }

  String _factorLine(Unit u) {
    final base = _test.base;
    if (u == base) return '';
    if (u.offset != 0) {
      return '${base.label} = ${u.label} ÷ ${fmt(1 / u.factor, 3)} + ${fmt(u.offset, 2)}';
    }
    return u.factor >= 1
        ? '${base.label} = ${u.label} × ${fmt(u.factor, 4)}'
        : '${u.label} = ${base.label} × ${fmt(1 / u.factor, 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Lab unit converter')),
      body: ReadableWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<Quantity>(
              key: const Key('lab_test'),
              initialValue: _test,
              decoration: const InputDecoration(labelText: 'Test'),
              items: [
                for (final q in kLabConverterTests)
                  DropdownMenuItem(value: q, child: Text(q.name)),
              ],
              onChanged: (q) => setState(() {
                _test = q!;
                _resetFields();
              }),
            ),
            const SizedBox(height: 16),
            for (final (i, u) in _test.units.indexed) ...[
              TextField(
                key: Key('lab_unit_$i'),
                controller: _fields[i],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: u.label,
                  helperText: u.si
                      ? 'SI unit'
                      : (i == 0 ? 'Conventional unit' : null),
                ),
                onChanged: (v) => _onChanged(i, v),
              ),
              const SizedBox(height: 12),
            ],
            const Divider(),
            Text('Conversion', style: text.titleSmall),
            const SizedBox(height: 4),
            for (final u in _test.units)
              if (_factorLine(u).isNotEmpty)
                Text(_factorLine(u), style: text.bodySmall),
            if (_test == Q.urea) ...[
              const SizedBox(height: 4),
              Text(
                'Urea (mg/dL) = BUN (mg/dL) × 2.14. Pakistani reports usually give urea, not BUN.',
                style: text.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Factors from standard SI conversion tables. Review pending.',
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
