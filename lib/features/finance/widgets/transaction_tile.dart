import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/constants/finance_categories.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/utils/finance_formatters.dart';
import '../models/finance_transaction.dart';
import '../models/transaction_type.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onDelete});

  final FinanceTransaction transaction;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final amountColor = transaction.type == TransactionType.income
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push('/transaction/${transaction.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: amountColor.withValues(alpha: 0.14),
                child: Icon(
                  FinanceCategories.icons[transaction.category] ??
                      Icons.widgets_rounded,
                  color: amountColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${FinanceFormatters.categoryLabel(l10n, transaction.category)} • '
                      '${AppDateUtils.fullDate(transaction.date, Localizations.localeOf(context).languageCode)}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (transaction.note != null &&
                        transaction.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        transaction.note!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.type == TransactionType.income ? '+' : '-'}'
                    '${FinanceFormatters.currency(context, transaction.amount)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      tooltip: l10n.delete,
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
