import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import '../models/transaction.dart';

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
  }) {
    return _collection.add({
      'description': description,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'note': note,
    });
  }

  Future<void> update(Transaction transaction) {
    return _collection.doc(transaction.id).update({
      'description': transaction.description,
      'amount': transaction.amount,
      'type': transaction.type.name,
      'categoryId': transaction.categoryId,
      'date': Timestamp.fromDate(transaction.date),
      'note': transaction.note,
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
    );
  }
}
