import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config.dart';
import '../../app/settings.dart';
import '../../shared/disclaimers.dart';

/// First launch: "Who is using this app?" (design §5, S2).
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _doctor(BuildContext context, WidgetRef ref) async {
    if (await showDoctorDeclaration(context)) {
      await ref.read(settingsProvider.notifier).chooseDoctor();
    }
  }

  Future<void> _public(BuildContext context, WidgetRef ref) async {
    if (await showPublicDisclaimer(context)) {
      await ref.read(settingsProvider.notifier).choosePublic();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Icon(
                  Icons.calculate_outlined,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  kAppName,
                  style: text.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Health calculators for Pakistan',
                  style: text.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text('Who is using this app?', style: text.titleMedium),
                const SizedBox(height: 12),
                _ModeCard(
                  key: const Key('mode_doctor'),
                  icon: Icons.medical_services_outlined,
                  title: 'Doctor / healthcare professional',
                  subtitle:
                      'Clinical scores and formulas: kidney, heart, '
                      'acute care, lab, mother & child, liver, dengue.',
                  onTap: () => _doctor(context, ref),
                ),
                const SizedBox(height: 12),
                _ModeCard(
                  key: const Key('mode_public'),
                  icon: Icons.favorite_outline,
                  title: 'General public',
                  subtitle:
                      'Simple checks: weight, blood pressure, sugar, '
                      'heart risk, pregnancy, dengue, Ramadan, heat.',
                  onTap: () => _public(context, ref),
                ),
                const SizedBox(height: 16),
                Text(
                  'You can change this later in Settings.',
                  style: text.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primaryContainer,
                child: Icon(icon, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
