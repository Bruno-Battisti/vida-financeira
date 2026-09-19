enum TransactionType { income, expense }

class Transaction {
  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
  });

  final int id;
  final String description;
  final double amount;
  final TransactionType type;
  final int categoryId;
  final DateTime date;
  final String? note;
}
