import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/ads.dart';
import '../../app/config.dart';
import '../../app/settings.dart';
import '../../calc/catalog.dart';
import '../../calc/registry.dart';
import '../../shared/readable_width.dart';

/// Home for the chosen mode: search, favourites, recents, categories (S4).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final mode = settings.mode ?? ToolMode.public;
    final tools = toolsFor(mode);
    final searching = _query.trim().isNotEmpty;
    final results = tools.where((t) => t.matches(_query)).toList();

    ToolInfo? inMode(String id) {
      final t = toolById(id);
      return t != null && t.mode == mode ? t : null;
    }

    final favourites = settings.favourites.map(inMode).nonNulls.toList();
    final recents = settings.recents.map(inMode).nonNulls.toList();

    final byCategory = <ToolCategory, List<ToolInfo>>{};
    for (final t in tools) {
      byCategory.putIfAbsent(t.category, () => []).add(t);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Chip(
              label: Text(mode == ToolMode.doctor ? 'Doctor' : 'Public'),
              visualDensity: VisualDensity.compact,
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: ReadableWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextField(
              key: const Key('search'),
              controller: _search,
              decoration: InputDecoration(
                hintText: mode == ToolMode.doctor
                    ? 'Search, e.g. egfr, cha2, gcs'
                    : 'Search, e.g. sugar, bp, bmi',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searching
                    ? IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 16),
            if (searching) ...[
              if (results.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No tool matches your search.',
                    textAlign: TextAlign.center,
                  ),
                ),
              for (final t in results) _ToolTile(tool: t),
            ] else ...[
              if (favourites.isNotEmpty) ...[
                const _SectionTitle('Favourites'),
                for (final t in favourites) _ToolTile(tool: t),
                const SizedBox(height: 12),
              ],
              if (recents.isNotEmpty) ...[
                const _SectionTitle('Recently used'),
                for (final t in recents) _ToolTile(tool: t),
                const SizedBox(height: 12),
              ],
              for (final entry in byCategory.entries) ...[
                _SectionTitle(entry.key.name),
                for (final t in entry.value) _ToolTile(tool: t),
                const SizedBox(height: 12),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BannerSlot(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class _ToolTile extends ConsumerWidget {
  const _ToolTile({required this.tool});
  final ToolInfo tool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fav = ref.watch(
      settingsProvider.select((s) => s.favourites.contains(tool.id)),
    );
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        title: Text(tool.name),
        subtitle: Text(
          isWorking(tool.id) ? tool.summary : '${tool.summary} · coming soon',
        ),
        trailing: IconButton(
          tooltip: fav ? 'Remove from favourites' : 'Add to favourites',
          icon: Icon(fav ? Icons.star : Icons.star_border),
          onPressed: () =>
              ref.read(settingsProvider.notifier).toggleFavourite(tool.id),
        ),
        onTap: () {
          ref.read(settingsProvider.notifier).recordUse(tool.id);
          context.go('/tool/${tool.id}');
        },
      ),
    );
  }
}
