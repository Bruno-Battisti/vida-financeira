import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transfer.dart';

/// Transferências não contam como receita nem despesa — ficam numa
/// coleção à parte, então os totais de receitas/despesas (dashboard e
/// relatórios) nem precisam saber que elas existem.
class TransfersRepository {
  TransfersRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('transfers');

  Stream<List<Transfer>> watchAll() {
    return _collection.orderBy('date', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  Future<void> add({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required DateTime date,
    String? note,
  }) {
    return _collection.add({
      'fromAccountId': fromAccountId,
      'toAccountId': toAccountId,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'note': note,
    });
  }

  Future<void> remove(String id) {
    return _collection.doc(id).delete();
  }

  Transfer _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Transfer(
      id: doc.id,
      fromAccountId: data['fromAccountId'] as String,
      toAccountId: data['toAccountId'] as String,
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'] as String?,
    );
  }
}
