import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/utils/finance_formatters.dart';
import '../models/financial_summary.dart';

class TrendChartCard extends StatelessWidget {
  const TrendChartCard({
    super.key,
    required this.title,
    required this.points,
    this.isLineChart = false,
  });

  final String title;
  final List<TrendPoint> points;
  final bool isLineChart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final maxValue = points
        .map(
          (point) =>
              point.income > point.expense ? point.income : point.expense,
        )
        .fold<double>(
          0,
          (previous, value) => value > previous ? value : previous,
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: isLineChart
                  ? LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: maxValue == 0 ? 100 : maxValue * 1.2,
                        gridData: const FlGridData(drawVerticalLine: false),
                        titlesData: _titles(context, points),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (var i = 0; i < points.length; i++)
                                FlSpot(i.toDouble(), points[i].income),
                            ],
                            isCurved: true,
                            color: theme.colorScheme.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: [
                              for (var i = 0; i < points.length; i++)
                                FlSpot(i.toDouble(), points[i].expense),
                            ],
                            isCurved: true,
                            color: theme.colorScheme.error,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: maxValue == 0 ? 100 : maxValue * 1.25,
                        gridData: const FlGridData(drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        titlesData: _titles(context, points),
                        barGroups: [
                          for (var i = 0; i < points.length; i++)
                            BarChartGroupData(
                              x: i,
                              barsSpace: 4,
                              barRods: [
                                BarChartRodData(
                                  toY: points[i].income,
                                  color: theme.colorScheme.primary,
                                  width: 10,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                BarChartRodData(
                                  toY: points[i].expense,
                                  color: theme.colorScheme.error,
                                  width: 10,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _LegendChip(
                  color: theme.colorScheme.primary,
                  label: l10n.income,
                ),
                _LegendChip(
                  color: theme.colorScheme.error,
                  label: l10n.expense,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FlTitlesData _titles(BuildContext context, List<TrendPoint> points) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 52,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              FinanceFormatters.currency(context, value).replaceAll('.00', ''),
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= points.length) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                points[index].label,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
