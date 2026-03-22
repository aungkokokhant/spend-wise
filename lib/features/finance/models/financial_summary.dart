import 'finance_transaction.dart';

class PeriodTotals {
  const PeriodTotals({required this.income, required this.expense});

  final double income;
  final double expense;

  double get balance => income - expense;
}

class TrendPoint {
  const TrendPoint({
    required this.label,
    required this.income,
    required this.expense,
  });

  final String label;
  final double income;
  final double expense;

  double get net => income - expense;
}

class CategorySpend {
  const CategorySpend({required this.category, required this.amount});

  final String category;
  final double amount;
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.today,
    required this.week,
    required this.month,
    required this.lastSevenDays,
    required this.recentTransactions,
  });

  final double totalIncome;
  final double totalExpense;
  final PeriodTotals today;
  final PeriodTotals week;
  final PeriodTotals month;
  final List<TrendPoint> lastSevenDays;
  final List<FinanceTransaction> recentTransactions;

  double get balance => totalIncome - totalExpense;
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.categoryBreakdown,
    required this.weeklyTrend,
    required this.monthlyTrend,
    required this.topExpenseCategory,
    required this.averageDailyExpense,
    required this.savingsRate,
  });

  final List<CategorySpend> categoryBreakdown;
  final List<TrendPoint> weeklyTrend;
  final List<TrendPoint> monthlyTrend;
  final String? topExpenseCategory;
  final double averageDailyExpense;
  final double savingsRate;
}
