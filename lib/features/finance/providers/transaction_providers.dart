import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/shared_preferences_provider.dart';
import '../../../core/utils/app_date_utils.dart';
import '../data/finance_repository.dart';
import '../data/transaction_local_data_source.dart';
import '../models/finance_transaction.dart';
import '../models/financial_summary.dart';
import '../models/transaction_type.dart';

enum TransactionFilterPeriod { all, daily, weekly, monthly }

final transactionLocalDataSourceProvider = Provider<TransactionLocalDataSource>(
  (ref) => TransactionLocalDataSource(ref.watch(sharedPreferencesProvider)),
);

final financeRepositoryProvider = Provider<FinanceRepository>(
  (ref) =>
      LocalFinanceRepository(ref.watch(transactionLocalDataSourceProvider)),
);

class TransactionListNotifier extends AsyncNotifier<List<FinanceTransaction>> {
  @override
  Future<List<FinanceTransaction>> build() {
    return ref.watch(financeRepositoryProvider).fetchTransactions();
  }

  Future<void> addTransaction(FinanceTransaction transaction) async {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      [transaction, ...current]..sort((a, b) => b.date.compareTo(a.date)),
    );
    state = await AsyncValue.guard(
      () => ref.watch(financeRepositoryProvider).addTransaction(transaction),
    );
  }

  Future<void> updateTransaction(FinanceTransaction transaction) async {
    final current = state.valueOrNull ?? [];
    final optimistic =
        current
            .map((item) => item.id == transaction.id ? transaction : item)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    state = AsyncValue.data(optimistic);
    state = await AsyncValue.guard(
      () => ref.watch(financeRepositoryProvider).updateTransaction(transaction),
    );
  }

  Future<void> deleteTransaction(String id) async {
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((item) => item.id != id).toList());
    state = await AsyncValue.guard(
      () => ref.watch(financeRepositoryProvider).deleteTransaction(id),
    );
  }

  Future<void> clearAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.watch(financeRepositoryProvider).clearAll();
      return <FinanceTransaction>[];
    });
  }
}

final transactionListProvider =
    AsyncNotifierProvider<TransactionListNotifier, List<FinanceTransaction>>(
      TransactionListNotifier.new,
    );

final transactionFilterProvider = StateProvider<TransactionFilterPeriod>(
  (ref) => TransactionFilterPeriod.all,
);

final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

final transactionsSnapshotProvider = Provider<List<FinanceTransaction>>(
  (ref) => ref.watch(transactionListProvider).valueOrNull ?? const [],
);

final transactionByIdProvider = Provider.family<FinanceTransaction?, String>((
  ref,
  id,
) {
  final items = ref.watch(transactionsSnapshotProvider);
  for (final item in items) {
    if (item.id == id) {
      return item;
    }
  }
  return null;
});

bool _matchesPeriod(
  FinanceTransaction transaction,
  TransactionFilterPeriod filter,
  DateTime now,
) {
  switch (filter) {
    case TransactionFilterPeriod.all:
      return true;
    case TransactionFilterPeriod.daily:
      return AppDateUtils.isSameDay(transaction.date, now);
    case TransactionFilterPeriod.weekly:
      final startOfWeek = AppDateUtils.startOfWeek(now);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      return transaction.date.isAfter(
            startOfWeek.subtract(const Duration(seconds: 1)),
          ) &&
          transaction.date.isBefore(endOfWeek);
    case TransactionFilterPeriod.monthly:
      return transaction.date.year == now.year &&
          transaction.date.month == now.month;
  }
}

final filteredTransactionsProvider = Provider<List<FinanceTransaction>>((ref) {
  final transactions = ref.watch(transactionsSnapshotProvider);
  final filter = ref.watch(transactionFilterProvider);
  final query = ref.watch(transactionSearchQueryProvider).trim().toLowerCase();
  final now = DateTime.now();

  return transactions.where((transaction) {
    final matchesQuery =
        query.isEmpty ||
        transaction.title.toLowerCase().contains(query) ||
        transaction.category.toLowerCase().contains(query) ||
        (transaction.note?.toLowerCase().contains(query) ?? false);

    return matchesQuery && _matchesPeriod(transaction, filter, now);
  }).toList();
});

PeriodTotals _totalsFor(
  Iterable<FinanceTransaction> transactions,
  bool Function(FinanceTransaction transaction) predicate,
) {
  double income = 0;
  double expense = 0;

  for (final transaction in transactions.where(predicate)) {
    if (transaction.type == TransactionType.income) {
      income += transaction.amount;
    } else {
      expense += transaction.amount;
    }
  }

  return PeriodTotals(income: income, expense: expense);
}

final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final transactions = ref.watch(transactionsSnapshotProvider);
  final now = DateTime.now();
  final startOfToday = AppDateUtils.startOfDay(now);
  final startOfWeek = AppDateUtils.startOfWeek(now);
  final startOfMonth = AppDateUtils.startOfMonth(now);

  double totalIncome = 0;
  double totalExpense = 0;
  for (final transaction in transactions) {
    if (transaction.type == TransactionType.income) {
      totalIncome += transaction.amount;
    } else {
      totalExpense += transaction.amount;
    }
  }

  final todayTotals = _totalsFor(
    transactions,
    (transaction) => transaction.date.isAfter(
      startOfToday.subtract(const Duration(seconds: 1)),
    ),
  );
  final weekTotals = _totalsFor(
    transactions,
    (transaction) => transaction.date.isAfter(
      startOfWeek.subtract(const Duration(seconds: 1)),
    ),
  );
  final monthTotals = _totalsFor(
    transactions,
    (transaction) => transaction.date.isAfter(
      startOfMonth.subtract(const Duration(seconds: 1)),
    ),
  );

  final lastSevenDays = List<TrendPoint>.generate(7, (index) {
    final date = startOfToday.subtract(Duration(days: 6 - index));
    final totals = _totalsFor(
      transactions,
      (transaction) => AppDateUtils.isSameDay(transaction.date, date),
    );
    return TrendPoint(
      label: '${date.month}/${date.day}',
      income: totals.income,
      expense: totals.expense,
    );
  });

  return DashboardSummary(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    today: todayTotals,
    week: weekTotals,
    month: monthTotals,
    lastSevenDays: lastSevenDays,
    recentTransactions: transactions.take(5).toList(),
  );
});

final groupedTransactionsProvider =
    Provider<Map<DateTime, List<FinanceTransaction>>>((ref) {
      final filtered = ref.watch(filteredTransactionsProvider);
      final grouped = <DateTime, List<FinanceTransaction>>{};

      for (final transaction in filtered) {
        final key = AppDateUtils.startOfDay(transaction.date);
        grouped.putIfAbsent(key, () => []).add(transaction);
      }

      final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
      return {
        for (final key in sortedKeys)
          key: grouped[key]!..sort((a, b) => b.date.compareTo(a.date)),
      };
    });

final analyticsSummaryProvider = Provider<AnalyticsSummary>((ref) {
  final transactions = ref.watch(transactionsSnapshotProvider);
  final now = DateTime.now();
  final monthStart = AppDateUtils.startOfMonth(now);

  final expenseByCategory = <String, double>{};
  double monthlyIncome = 0;
  double monthlyExpense = 0;

  for (final transaction in transactions) {
    if (transaction.type == TransactionType.expense) {
      expenseByCategory.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    if (transaction.date.isAfter(
      monthStart.subtract(const Duration(seconds: 1)),
    )) {
      if (transaction.type == TransactionType.income) {
        monthlyIncome += transaction.amount;
      } else {
        monthlyExpense += transaction.amount;
      }
    }
  }

  final categoryBreakdown =
      expenseByCategory.entries
          .map(
            (entry) => CategorySpend(category: entry.key, amount: entry.value),
          )
          .toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

  final weeklyTrend = List<TrendPoint>.generate(4, (index) {
    final rangeStart = AppDateUtils.startOfWeek(
      now,
    ).subtract(Duration(days: 7 * (3 - index)));
    final rangeEnd = rangeStart.add(const Duration(days: 7));
    final totals = _totalsFor(
      transactions,
      (transaction) =>
          transaction.date.isAfter(
            rangeStart.subtract(const Duration(seconds: 1)),
          ) &&
          transaction.date.isBefore(rangeEnd),
    );
    return TrendPoint(
      label: 'W${index + 1}',
      income: totals.income,
      expense: totals.expense,
    );
  });

  final monthlyTrend = List<TrendPoint>.generate(6, (index) {
    final date = DateTime(now.year, now.month - (5 - index));
    final nextMonth = DateTime(date.year, date.month + 1);
    final totals = _totalsFor(
      transactions,
      (transaction) =>
          transaction.date.isAfter(date.subtract(const Duration(seconds: 1))) &&
          transaction.date.isBefore(nextMonth),
    );
    return TrendPoint(
      label: '${date.month}/${date.year.toString().substring(2)}',
      income: totals.income,
      expense: totals.expense,
    );
  });

  final topExpenseCategory = categoryBreakdown.isEmpty
      ? null
      : categoryBreakdown.first.category;
  final averageDailyExpense = monthlyExpense / now.day;
  final savingsRate = monthlyIncome == 0
      ? 0
      : ((monthlyIncome - monthlyExpense) / monthlyIncome) * 100;

  return AnalyticsSummary(
    categoryBreakdown: categoryBreakdown,
    weeklyTrend: weeklyTrend,
    monthlyTrend: monthlyTrend,
    topExpenseCategory: topExpenseCategory,
    averageDailyExpense: averageDailyExpense,
    savingsRate: savingsRate.clamp(-999, 999).toDouble(),
  );
});
