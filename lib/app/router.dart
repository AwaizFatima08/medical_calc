import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/about/about_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/tool_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import '../features/settings/settings_screen.dart';
import 'settings.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run redirects whenever the chosen mode changes.
  final refresh = ValueNotifier<int>(0);
  ref.listen(settingsProvider.select((s) => s.mode), (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final hasMode = ref.read(settingsProvider).mode != null;
      final atWelcome = state.matchedLocation == '/welcome';
      if (!hasMode && !atWelcome) return '/welcome';
      if (hasMode && atWelcome) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(
        path: '/',
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'tool/:id',
            builder: (_, state) =>
                ToolScreen(toolId: state.pathParameters['id']!),
          ),
          GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen()),
          GoRoute(path: 'about', builder: (_, _) => const AboutScreen()),
        ],
      ),
    ],
  );
});
