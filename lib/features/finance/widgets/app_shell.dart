import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'transaction-fab',
        onPressed: () => context.push('/transaction/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addTransaction),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.space_dashboard_rounded),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_rounded),
            label: l10n.transactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_graph_rounded),
            label: l10n.analytics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_rounded),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
