import 'package:flutter/material.dart';

import '../../calc/catalog.dart';
import '../../calc/registry.dart';
import '../../shared/readable_width.dart';
import '../calculator/calculator_screen.dart';
import '../calculator/lab_converter_screen.dart';

/// Calculator screen. Release 1 tools arrive batch by batch after source
/// check, golden vectors and clinician sign-off (design §9, §11). No ads here.
class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key, required this.toolId});
  final String toolId;

  @override
  Widget build(BuildContext context) {
    final tool = toolById(toolId);
    if (tool != null) {
      final def = kCalculators[tool.id];
      if (def != null) return CalculatorScreen(tool: tool, def: def);
      if (tool.id == 'lab_units') return const LabConverterScreen();
    }
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(tool?.name ?? 'Tool')),
      body: tool == null
          ? const Center(child: Text('This tool was not found.'))
          : ReadableWidth(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(tool.summary, style: text.titleMedium),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.fact_check_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Coming in an update',
                    style: text.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This calculator is being checked against its published '
                    'source and reviewed by a doctor before it is switched on.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
