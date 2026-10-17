import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import '../models/transaction.dart';
import '../services/transaction_csv_importer.dart' show ParsedTransactionRow;

class TransactionsRepository {
  TransactionsRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('transactions');

  Stream<List<Transaction>> watchAll() {
    return _collection.orderBy('date', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  Future<void> add({
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
    DateTime? dueDate,
    bool isPaid = true,
    String? recurringRuleId,
  }) {
    return _collection.add(_toMap(
      description: description,
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      note: note,
      dueDate: dueDate,
      isPaid: isPaid,
      recurringRuleId: recurringRuleId,
    ));
  }

  Future<void> addBatch(List<ParsedTransactionRow> rows) async {
    final batch = _firestore.batch();
    for (final row in rows) {
      batch.set(
        _collection.doc(),
        _toMap(
          description: row.description,
          amount: row.amount,
          type: row.type,
          categoryId: row.categoryId,
          date: row.date,
          note: row.note,
          dueDate: null,
          isPaid: true,
        ),
      );
    }
    await batch.commit();
  }

  Map<String, dynamic> _toMap({
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
    DateTime? dueDate,
    bool isPaid = true,
    String? recurringRuleId,
  }) {
    return {
      'description': description,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'note': note,
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate),
      'isPaid': isPaid,
      'recurringRuleId': recurringRuleId,
    };
  }

  Future<void> update(Transaction transaction) {
    return _collection.doc(transaction.id).update({
      'description': transaction.description,
      'amount': transaction.amount,
      'type': transaction.type.name,
      'categoryId': transaction.categoryId,
      'date': Timestamp.fromDate(transaction.date),
      'note': transaction.note,
      'dueDate': transaction.dueDate == null ? null : Timestamp.fromDate(transaction.dueDate!),
      'isPaid': transaction.isPaid,
    });
  }

  Future<void> remove(String id) {
    return _collection.doc(id).delete();
  }

  Transaction _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Transaction(
      id: doc.id,
      description: data['description'] as String,
      amount: (data['amount'] as num).toDouble(),
      type: data['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: data['categoryId'] as int,
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'] as String?,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      isPaid: data['isPaid'] as bool? ?? true,
      recurringRuleId: data['recurringRuleId'] as String?,
    );
  }
}
