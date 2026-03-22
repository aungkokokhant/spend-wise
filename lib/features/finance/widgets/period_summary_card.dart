import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/utils/finance_formatters.dart';
import '../models/financial_summary.dart';

class PeriodSummaryCard extends StatelessWidget {
  const PeriodSummaryCard({
    super.key,
    required this.title,
    required this.totals,
  });

  final String title;
  final PeriodTotals totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(
              FinanceFormatters.currency(context, totals.balance),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.income} ${FinanceFormatters.currency(context, totals.income)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.expense} ${FinanceFormatters.currency(context, totals.expense)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
