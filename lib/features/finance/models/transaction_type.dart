enum TransactionType {
  income,
  expense;

  String get value => name;

  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => TransactionType.expense,
    );
  }
}
