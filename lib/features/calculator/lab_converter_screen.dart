import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../calc/model.dart';
import '../../calc/units.dart';
import '../../shared/readable_width.dart';

/// D28: conventional (mg/dL, g/dL…) ↔ SI (mmol/L, µmol/L, g/L). Typing in any
/// unit's box updates the others.
class LabConverterScreen extends StatefulWidget {
  const LabConverterScreen({
    super.key,
    this.title = 'Lab unit converter',
    this.quantities = kLabConverterTests,
    this.isLab = true,
  });

  /// P10 public converter: sugar, temperature, height, weight.
  const LabConverterScreen.everyday({super.key})
    : title = 'Unit converter',
      quantities = kPublicConverterQuantities,
      isLab = false;

  final String title;
  final List<Quantity> quantities;
  final bool isLab;

  @override
  State<LabConverterScreen> createState() => _LabConverterScreenState();
}

class _LabConverterScreenState extends State<LabConverterScreen> {
  late Quantity _test = widget.quantities.first;
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

  String? _feetInches;

  void _onChanged(int index, String raw) {
    final v = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (_test == Q.height) {
      setState(() {
        if (v == null) {
          _feetInches = null;
        } else {
          final totalIn = _test.units[index].toBase(v) / 2.54;
          var ft = totalIn ~/ 12;
          var inch = (totalIn - ft * 12).round();
          if (inch == 12) {
            ft++;
            inch = 0;
          }
          _feetInches = '= $ft ft $inch in';
        }
      });
    }
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
      appBar: AppBar(title: Text(widget.title)),
      body: ReadableWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<Quantity>(
              key: const Key('lab_test'),
              initialValue: _test,
              decoration: InputDecoration(
                labelText: widget.isLab ? 'Test' : 'Convert',
              ),
              items: [
                for (final q in widget.quantities)
                  DropdownMenuItem(value: q, child: Text(q.name)),
              ],
              onChanged: (q) => setState(() {
                _test = q!;
                _feetInches = null;
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
                  helperText: !widget.isLab
                      ? null
                      : u.si
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
            if (_test == Q.height && _feetInches != null) ...[
              const SizedBox(height: 4),
              Text(_feetInches!, style: text.titleMedium),
            ],
            if (_test == Q.urea) ...[
              const SizedBox(height: 4),
              Text(
                'Urea (mg/dL) = BUN (mg/dL) × 2.14. Pakistani reports usually give urea, not BUN.',
                style: text.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            if (widget.isLab)
              Text(
                'Factors from standard SI conversion tables. Reviewed 9 Nov 2026 (Homi).',
                style: text.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
