import '../models/finance_transaction.dart';
import 'transaction_local_data_source.dart';

abstract class FinanceRepository {
  Future<List<FinanceTransaction>> fetchTransactions();

  Future<List<FinanceTransaction>> addTransaction(
    FinanceTransaction transaction,
  );

  Future<List<FinanceTransaction>> updateTransaction(
    FinanceTransaction transaction,
  );

  Future<List<FinanceTransaction>> deleteTransaction(String id);

  Future<void> clearAll();
}

class LocalFinanceRepository implements FinanceRepository {
  LocalFinanceRepository(this._localDataSource);

  final TransactionLocalDataSource _localDataSource;

  @override
  Future<List<FinanceTransaction>> fetchTransactions() {
    return _localDataSource.fetchTransactions();
  }

  @override
  Future<List<FinanceTransaction>> addTransaction(
    FinanceTransaction transaction,
  ) async {
    final current = await fetchTransactions();
    final updated = [transaction, ...current]
      ..sort((a, b) => b.date.compareTo(a.date));
    await _localDataSource.saveTransactions(updated);
    return updated;
  }

  @override
  Future<List<FinanceTransaction>> updateTransaction(
    FinanceTransaction transaction,
  ) async {
    final current = await fetchTransactions();
    final updated =
        current
            .map((item) => item.id == transaction.id ? transaction : item)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    await _localDataSource.saveTransactions(updated);
    return updated;
  }

  @override
  Future<List<FinanceTransaction>> deleteTransaction(String id) async {
    final current = await fetchTransactions();
    final updated = current.where((item) => item.id != id).toList();
    await _localDataSource.saveTransactions(updated);
    return updated;
  }

  @override
  Future<void> clearAll() => _localDataSource.clear();
}
