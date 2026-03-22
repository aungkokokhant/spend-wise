import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/services/app_settings_service.dart';
import '../providers/transaction_providers.dart';
import '../../auth/auth_placeholder.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          Text(
            l10n.settingsHeadline,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsSubhead,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: themeMode == ThemeMode.dark,
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: Text(l10n.darkMode),
                  subtitle: Text(l10n.darkModeHint),
                  onChanged: (value) => ref
                      .read(themeControllerProvider.notifier)
                      .updateTheme(value),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.language),
                  subtitle: Text(l10n.languageHint),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SegmentedButton<Locale>(
                    segments: [
                      ButtonSegment(
                        value: const Locale('en'),
                        label: Text(l10n.english),
                      ),
                      ButtonSegment(
                        value: const Locale('my'),
                        label: Text(l10n.myanmar),
                      ),
                    ],
                    selected: {locale},
                    onSelectionChanged: (selection) {
                      ref
                          .read(localeControllerProvider.notifier)
                          .updateLocale(selection.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_sweep_rounded),
                  title: Text(l10n.clearAllData),
                  subtitle: Text(l10n.clearAllDataHint),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text(l10n.clearAllData),
                          content: Text(l10n.clearAllConfirmation),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: Text(l10n.cancel),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: Text(l10n.confirm),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      await ref
                          .read(transactionListProvider.notifier)
                          .clearAll();
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(l10n.appInfo),
                  subtitle: const Text('SpendWise 1.0.0'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AuthPlaceholderCard(),
        ],
      ),
    );
  }
}
