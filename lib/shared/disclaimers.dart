import 'package:flutter/material.dart';

const String kDoctorDeclaration =
    'I am a registered healthcare professional. I understand these tools '
    'support, and do not replace, clinical judgement, and that I must check '
    'every result against the patient and the cited source.';

const String kPublicDisclaimer =
    'This app helps you understand health numbers. It does not diagnose any '
    'illness and is not a substitute for a doctor. In an emergency call 1122 '
    'or go to the nearest hospital.';

const String kMedicalDeviceNotice =
    'MedCal is not a medical device and does not diagnose, treat, cure, '
    'or prevent any medical condition. Always consult a qualified healthcare '
    'professional.';

/// One-time declaration before Doctor mode. Returns true if confirmed.
Future<bool> showDoctorDeclaration(BuildContext context) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Doctor mode', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text(kDoctorDeclaration),
            const SizedBox(height: 12),
            Text(
              kMedicalDeviceNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('I confirm'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
  return confirmed ?? false;
}

/// Short notice before Public mode. Returns true when acknowledged.
Future<bool> showPublicDisclaimer(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Before you start'),
      content: const Text(kPublicDisclaimer),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Back'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
