import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/utils/finance_formatters.dart';
import '../models/finance_transaction.dart';
import '../providers/transaction_providers.dart';
import '../widgets/async_value_view.dart';
import '../widgets/category_pie_chart_card.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/insight_card.dart';
import '../widgets/trend_chart_card.dart';

class AnalyticsView extends ConsumerWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final transactionsValue = ref.watch(transactionListProvider);

    return SafeArea(
      child: AsyncValueView<List<FinanceTransaction>>(
        value: transactionsValue,
        data: (transactions) {
          final summary = ref.watch(analyticsSummaryProvider);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      l10n.analyticsHeadline,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.analyticsSubhead,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    if (transactions.isEmpty)
                      EmptyStateCard(
                        icon: Icons.insights_rounded,
                        title: l10n.analyticsEmptyTitle,
                        message: l10n.analyticsEmptyMessage,
                      )
                    else ...[
                      CategoryPieChartCard(
                        categories: summary.categoryBreakdown,
                      ),
                      const SizedBox(height: 20),
                      TrendChartCard(
                        title: l10n.weeklyTrend,
                        points: summary.weeklyTrend,
                      ),
                      const SizedBox(height: 20),
                      TrendChartCard(
                        title: l10n.monthlyTrend,
                        points: summary.monthlyTrend,
                        isLineChart: true,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.smartInsights,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: MediaQuery.sizeOf(context).width > 700
                            ? 3
                            : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 0.92,
                        children: [
                          InsightCard(
                            title: l10n.topExpenseCategory,
                            value: summary.topExpenseCategory == null
                                ? l10n.noExpenseData
                                : FinanceFormatters.categoryLabel(
                                    l10n,
                                    summary.topExpenseCategory!,
                                  ),
                            description: l10n.biggestSpendBucket,
                            icon: Icons.local_fire_department_rounded,
                          ),
                          InsightCard(
                            title: l10n.averageDailyExpense,
                            value: FinanceFormatters.currency(
                              context,
                              summary.averageDailyExpense,
                            ),
                            description: l10n.averageDailyExpenseHint,
                            icon: Icons.calendar_month_rounded,
                          ),
                          InsightCard(
                            title: l10n.savingsRate,
                            value: '${summary.savingsRate.toStringAsFixed(1)}%',
                            description: l10n.savingsRateHint,
                            icon: Icons.savings_rounded,
                          ),
                        ],
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
