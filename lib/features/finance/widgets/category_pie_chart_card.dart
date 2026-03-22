import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/utils/finance_formatters.dart';
import '../models/financial_summary.dart';

class CategoryPieChartCard extends StatelessWidget {
  const CategoryPieChartCard({super.key, required this.categories});

  final List<CategorySpend> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    const palette = [
      Color(0xFF1B9C85),
      Color(0xFFF26B6C),
      Color(0xFFFFB347),
      Color(0xFF4A90E2),
      Color(0xFF7EC8E3),
    ];
    final total = categories.fold<double>(0, (sum, item) => sum + item.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.categoryBreakdown, style: theme.textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: categories.isEmpty
                  ? Center(child: Text(l10n.noExpenseData))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 46,
                        sections: [
                          for (var i = 0; i < categories.take(5).length; i++)
                            PieChartSectionData(
                              color: palette[i % palette.length],
                              value: categories[i].amount,
                              title:
                                  '${((categories[i].amount / total) * 100).round()}%',
                              radius: 54,
                              titleStyle: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < categories.take(5).length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: palette[i % palette.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        FinanceFormatters.categoryLabel(
                          l10n,
                          categories[i].category,
                        ),
                      ),
                    ),
                    Text(
                      FinanceFormatters.currency(context, categories[i].amount),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
