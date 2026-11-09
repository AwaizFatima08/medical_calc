import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/ads.dart';
import '../../app/settings.dart';
import '../../calc/catalog.dart';
import '../../shared/readable_width.dart';
import '../../shared/disclaimers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _setMode(
    BuildContext context,
    WidgetRef ref,
    ToolMode mode,
  ) async {
    final settings = ref.read(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    if (mode == settings.mode) return;
    if (mode == ToolMode.doctor) {
      if (settings.doctorDeclared || await showDoctorDeclaration(context)) {
        await notifier.chooseDoctor();
      }
    } else if (await showPublicDisclaimer(context)) {
      await notifier.choosePublic();
    }
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear favourites and recents?'),
        content: const Text('This only removes the lists on this phone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(settingsProvider.notifier).clearHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cleared')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final showAdChoicesTile = ref.watch(privacyOptionsRequiredProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ReadableWidth(
        child: ListView(
          children: [
            const _Header('Who is using the app'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<ToolMode>(
                segments: const [
                  ButtonSegment(value: ToolMode.doctor, label: Text('Doctor')),
                  ButtonSegment(value: ToolMode.public, label: Text('Public')),
                ],
                selected: {?s.mode},
                emptySelectionAllowed: true,
                onSelectionChanged: (v) {
                  if (v.isNotEmpty) _setMode(context, ref, v.first);
                },
              ),
            ),
            const _Header('Lab units (default)'),
            RadioGroup<LabUnits>(
              groupValue: s.labUnits,
              onChanged: (v) => notifier.setLabUnits(v!),
              child: const Column(
                children: [
                  RadioListTile(
                    value: LabUnits.conventional,
                    title: Text('Conventional (mg/dL, g/dL)'),
                    subtitle: Text('Used by most Pakistani labs'),
                  ),
                  RadioListTile(
                    value: LabUnits.si,
                    title: Text('SI (mmol/L, µmol/L, g/L)'),
                  ),
                ],
              ),
            ),
            const _Header('BMI standard'),
            RadioGroup<BmiStandard>(
              groupValue: s.bmiStandard,
              onChanged: (v) => notifier.setBmiStandard(v!),
              child: const Column(
                children: [
                  RadioListTile(
                    value: BmiStandard.asian,
                    title: Text('Asian (South Asian cut-offs)'),
                    subtitle: Text('Recommended for Pakistan'),
                  ),
                  RadioListTile(
                    value: BmiStandard.international,
                    title: Text('International (WHO)'),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear favourites and recents'),
              onTap: () => _clear(context, ref),
            ),
            if (showAdChoicesTile)
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy and ad choices'),
                onTap: showAdChoices,
              ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About and disclaimer'),
              onTap: () => context.go('/about'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BannerSlot(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
