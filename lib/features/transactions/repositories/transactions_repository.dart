import 'package:drift/drift.dart';

import '../../../database/database.dart';
import '../models/transaction.dart';

class TransactionsRepository {
  TransactionsRepository(this._db);

  final AppDatabase _db;

  Stream<List<Transaction>> watchAll() {
    final query = _db.select(_db.transactionEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> add({
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
  }) {
    return _db.into(_db.transactionEntries).insert(
          TransactionEntriesCompanion.insert(
            description: description,
            amount: amount,
            type: type.name,
            categoryId: categoryId,
            date: date,
            note: Value(note),
          ),
        );
  }

  Future<void> update(Transaction transaction) {
    return (_db.update(_db.transactionEntries)..where((t) => t.id.equals(transaction.id)))
        .write(_toCompanion(transaction));
  }

  Future<void> remove(int id) {
    return (_db.delete(_db.transactionEntries)..where((t) => t.id.equals(id))).go();
  }

  Transaction _toDomain(TransactionRow row) {
    return Transaction(
      id: row.id,
      description: row.description,
      amount: row.amount,
      type: row.type == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: row.categoryId,
      date: row.date,
      note: row.note,
    );
  }

  TransactionEntriesCompanion _toCompanion(Transaction transaction) {
    return TransactionEntriesCompanion(
      description: Value(transaction.description),
      amount: Value(transaction.amount),
      type: Value(transaction.type.name),
      categoryId: Value(transaction.categoryId),
      date: Value(transaction.date),
      note: Value(transaction.note),
    );
  }
}
