import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/config.dart';
import '../../shared/disclaimers.dart';
import '../../shared/readable_width.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ReadableWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(kAppName, style: text.headlineSmall),
            Text('Version $kAppVersion ($kAppBuild)', style: text.bodySmall),
            const SizedBox(height: 16),
            Text('Disclaimer', style: text.titleMedium),
            const SizedBox(height: 4),
            const Text(kMedicalDeviceNotice),
            const SizedBox(height: 8),
            const Text(
              'Every calculator uses a published formula or score and shows its '
              'source. Results are reference values, not treatment instructions. '
              'In an emergency call 1122.',
            ),
            const SizedBox(height: 16),
            Text('Your data', style: text.titleMedium),
            const SizedBox(height: 4),
            const Text(
              'Values you enter stay on this phone and are not sent anywhere. '
              'The app has no account. Ads are provided by Google AdMob, which '
              'may collect device information as described in our privacy policy.',
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy policy'),
              onTap: () => _open(context, kPrivacyUrl),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of use'),
              onTap: () => _open(context, kTermsUrl),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.mail_outline),
              title: const Text('Contact'),
              subtitle: const Text(kContactEmail),
              onTap: () => _open(context, 'mailto:$kContactEmail'),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 HomiLabs Solutions SMC Pvt Ltd',
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
