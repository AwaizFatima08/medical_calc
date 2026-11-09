import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/settings.dart';
import '../../calc/catalog.dart';
import '../../calc/model.dart';
import '../../calc/units.dart';
import '../../shared/readable_width.dart';
import 'result_card.dart';

/// Generic calculator built from a [CalcDefinition] (design §6 S5/S6).
/// No ads on this screen.
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key, required this.tool, required this.def});

  final ToolInfo tool;
  final CalcDefinition def;

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final Map<String, Object?> _values = {};
  final Map<String, Unit> _units = {};
  final Map<String, TextEditingController> _text = {};
  final Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    for (final input in widget.def.inputs) {
      switch (input) {
        case NumberInput(:final quantity):
          _units[input.id] = quantity.defaultUnit(
            preferSi: settings.labUnits == LabUnits.si,
          );
          _text[input.id] = TextEditingController();
        case ChoiceInput(
          :final initial,
          :final choices,
          :final followsBmiSetting,
        ):
          final index = followsBmiSetting
              ? (settings.bmiStandard == BmiStandard.asian ? 0 : 1)
              : initial;
          if (index != null) _values[input.id] = choices[index].value;
        case ToggleInput():
          _values[input.id] = false;
        case DateInput():
          break;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onNumber(NumberInput input, String raw) {
    final unit = _units[input.id]!;
    final parsed = double.tryParse(raw.trim().replaceAll(',', '.'));
    setState(() {
      if (raw.trim().isEmpty) {
        _values.remove(input.id);
        _errors[input.id] = null;
        return;
      }
      if (parsed == null) {
        _values.remove(input.id);
        _errors[input.id] = 'Enter a number';
        return;
      }
      final base = unit.toBase(parsed);
      if (base < input.min - 1e-9 || base > input.max + 1e-9) {
        _values.remove(input.id);
        final lo = unit.fromBase(input.min), hi = unit.fromBase(input.max);
        final a = lo < hi ? lo : hi, b = lo < hi ? hi : lo;
        _errors[input.id] =
            'Enter ${fmt(a, input.decimals + 1)}–${fmt(b, input.decimals + 1)} ${unit.label}';
        return;
      }
      _values[input.id] = base;
      _errors[input.id] = null;
    });
  }

  void _onUnit(NumberInput input, Unit unit) {
    final base = _values[input.id] as double?;
    setState(() {
      _units[input.id] = unit;
      if (base != null) {
        _text[input.id]!.text = fmt(unit.fromBase(base), input.decimals + 1);
      } else if (_text[input.id]!.text.isNotEmpty) {
        _onNumber(input, _text[input.id]!.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final def = widget.def;
    final result = def.compute(Inputs(_values));
    return Scaffold(
      appBar: AppBar(title: Text(widget.tool.name)),
      body: ReadableWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            for (final note in def.notes)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Note(note),
              ),
            for (final input in def.inputs)
              if (input.visible(Inputs(_values))) ...[
                _buildInput(context, input),
                const SizedBox(height: 12),
              ],
            const SizedBox(height: 8),
            ResultCard(tool: widget.tool, def: def, result: result),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, InputSpec input) {
    final text = Theme.of(context).textTheme;
    switch (input) {
      case NumberInput(:final quantity):
        final unit = _units[input.id]!;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: Key('in_${input.id}'),
                controller: _text[input.id],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText:
                      input.optional &&
                          !input.label.toLowerCase().contains('optional')
                      ? '${input.label} (optional)'
                      : input.label,
                  helperText: input.help,
                  errorText: _errors[input.id],
                  suffixText: quantity.units.length == 1 ? unit.label : null,
                ),
                onChanged: (v) => _onNumber(input, v),
              ),
            ),
            if (quantity.units.length > 1) ...[
              const SizedBox(width: 8),
              DropdownButton<Unit>(
                value: unit,
                items: [
                  for (final u in quantity.units)
                    DropdownMenuItem(value: u, child: Text(u.label)),
                ],
                onChanged: (u) => _onUnit(input, u!),
              ),
            ],
          ],
        );
      case ToggleInput(:final points):
        final on = _values[input.id] == true;
        return Card(
          child: CheckboxListTile(
            key: Key('in_${input.id}'),
            value: on,
            title: Text(input.label),
            subtitle: input.help == null ? null : Text(input.help!),
            secondary: Text(
              points >= 0
                  ? '+${fmt(points.toDouble())}'
                  : fmt(points.toDouble()),
              style: text.labelLarge,
            ),
            onChanged: (v) => setState(() => _values[input.id] = v ?? false),
          ),
        );
      case ChoiceInput(:final choices):
        final selected = _values[input.id];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(input.label, style: text.titleSmall),
            if (input.help != null) Text(input.help!, style: text.bodySmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final (i, c) in choices.indexed)
                  ChoiceChip(
                    key: Key('in_${input.id}_$i'),
                    label: Text(c.label),
                    selected: selected == c.value,
                    onSelected: (_) =>
                        setState(() => _values[input.id] = c.value),
                  ),
              ],
            ),
          ],
        );
      case DateInput():
        final date = _values[input.id] as DateTime?;
        return Card(
          child: ListTile(
            key: Key('in_${input.id}'),
            title: Text(input.label),
            subtitle: Text(
              date == null
                  ? 'Tap to choose'
                  : MaterialLocalizations.of(context).formatMediumDate(date),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? now,
                firstDate: DateTime(now.year - 2),
                lastDate: DateTime(now.year + 1),
              );
              if (picked != null) setState(() => _values[input.id] = picked);
            },
          ),
        );
    }
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: scheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
