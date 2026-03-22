import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../models/finance_transaction.dart';

class TransactionLocalDataSource {
  TransactionLocalDataSource(this._preferences);

  final SharedPreferences _preferences;

  Future<List<FinanceTransaction>> fetchTransactions() async {
    final raw = _preferences.getString(StorageKeys.transactions);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final transactions = FinanceTransaction.decodeList(raw);
    transactions.sort((left, right) => right.date.compareTo(left.date));
    return transactions;
  }

  Future<void> saveTransactions(List<FinanceTransaction> transactions) async {
    await _preferences.setString(
      StorageKeys.transactions,
      FinanceTransaction.encodeList(transactions),
    );
  }

  Future<void> clear() async {
    await _preferences.remove(StorageKeys.transactions);
  }
}
