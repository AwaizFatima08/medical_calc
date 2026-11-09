import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../calc/catalog.dart';
import '../../calc/model.dart';

/// Band colours. The band label is always shown with the colour.
Color severityColor(Severity s, ColorScheme scheme) => switch (s) {
  Severity.normal => const Color(0xFF2E7D32),
  Severity.info => scheme.primary,
  Severity.caution => const Color(0xFFF9A825),
  Severity.warning => const Color(0xFFEF6C00),
  Severity.danger => const Color(0xFFC62828),
};

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.tool,
    required this.def,
    required this.result,
  });

  final ToolInfo tool;
  final CalcDefinition def;
  final CalcResult? result;

  String _asText(CalcResult r) => [
    '${tool.name}: ${r.headline}${r.unit == null ? '' : ' ${r.unit}'}',
    if (r.band != null) r.band!,
    if (r.interpretation != null) r.interpretation!,
    ...r.details,
    'Source: ${def.version}',
  ].join('\n');

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final r = result;
    return Card(
      key: const Key('result'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Result', style: text.titleSmall),
                const Spacer(),
                if (def.reviewedOn == null)
                  Chip(
                    label: const Text('Review pending'),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: scheme.tertiaryContainer,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (r == null)
              Text(
                'Fill in the fields above to see the result.',
                style: text.bodyMedium,
              )
            else ...[
              if (r.emergency != null) _Emergency(r.emergency!),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 6,
                children: [
                  Text(
                    r.headline,
                    key: const Key('result_value'),
                    style: text.displaySmall,
                  ),
                  if (r.unit != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(r.unit!, style: text.titleMedium),
                    ),
                ],
              ),
              if (r.band != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor(
                      r.severity,
                      scheme,
                    ).withValues(alpha: 0.15),
                    border: Border.all(
                      color: severityColor(r.severity, scheme),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.band!,
                    key: const Key('result_band'),
                    style: text.titleSmall,
                  ),
                ),
              ],
              if (r.interpretation != null) ...[
                const SizedBox(height: 10),
                Text(r.interpretation!),
              ],
              for (final w in r.warnings) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber, size: 18, color: scheme.error),
                    const SizedBox(width: 6),
                    Expanded(child: Text(w)),
                  ],
                ),
              ],
              if (r.details.isNotEmpty) ...[
                const SizedBox(height: 10),
                for (final d in r.details)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('• $d', style: text.bodySmall),
                  ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy result'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _asText(r)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Result copied')),
                    );
                  },
                ),
              ),
            ],
            const Divider(),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Formula and sources'),
              childrenPadding: const EdgeInsets.only(bottom: 8),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(def.formula, style: text.bodySmall),
                const SizedBox(height: 8),
                Text('Version: ${def.version}', style: text.bodySmall),
                const SizedBox(height: 8),
                for (final s in def.sources)
                  InkWell(
                    onTap: s.url == null
                        ? null
                        : () => launchUrl(
                            Uri.parse(s.url!),
                            mode: LaunchMode.externalApplication,
                          ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        s.citation,
                        style: text.bodySmall?.copyWith(
                          color: s.url == null ? null : scheme.primary,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  def.reviewedOn == null
                      ? 'Not yet reviewed by HomiLabs\' clinical reviewer.'
                      : 'Last reviewed: ${def.reviewedOn}',
                  style: text.bodySmall,
                ),
              ],
            ),
            Text(
              'Reference only. Not a diagnosis or treatment instruction.',
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Emergency extends StatelessWidget {
  const _Emergency(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('emergency'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFC62828),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emergency, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Get medical help now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFC62828),
            ),
            icon: const Icon(Icons.call),
            label: const Text('Call 1122'),
            onPressed: () => launchUrl(Uri.parse('tel:1122')),
          ),
        ],
      ),
    );
  }
}
