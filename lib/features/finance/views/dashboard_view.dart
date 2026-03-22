import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/utils/finance_formatters.dart';
import '../models/finance_transaction.dart';
import '../providers/transaction_providers.dart';
import '../widgets/async_value_view.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/period_summary_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/trend_chart_card.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsValue = ref.watch(transactionListProvider);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: AsyncValueView<List<FinanceTransaction>>(
        value: transactionsValue,
        data: (transactions) {
          final summary = ref.watch(dashboardSummaryProvider);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      l10n.dashboardWelcome,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.dashboardHeadline,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    BalanceSummaryCard(
                      balance: summary.balance,
                      income: summary.totalIncome,
                      expense: summary.totalExpense,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: PeriodSummaryCard(
                            title: l10n.today,
                            totals: summary.today,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PeriodSummaryCard(
                            title: l10n.thisWeek,
                            totals: summary.week,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PeriodSummaryCard(
                      title: l10n.thisMonth,
                      totals: summary.month,
                    ),
                    const SizedBox(height: 20),
                    TrendChartCard(
                      title: l10n.cashFlow,
                      points: summary.lastSevenDays,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.recentTransactions,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${transactions.length} ${l10n.totalEntries}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (transactions.isEmpty)
                      EmptyStateCard(
                        icon: Icons.wallet_rounded,
                        title: l10n.emptyTransactionsTitle,
                        message: l10n.emptyTransactionsMessage,
                      )
                    else
                      ...summary.recentTransactions.map(
                        (transaction) =>
                            TransactionTile(transaction: transaction),
                      ),
                    if (transactions.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        '${l10n.monthlyRunRate}: '
                        '${FinanceFormatters.currency(context, summary.month.balance)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
