import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/budget.dart';

/// Um orçamento por categoria — guardado com o id da categoria como id do
/// documento, já que só faz sentido existir um limite mensal por categoria.
class BudgetsRepository {
  BudgetsRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('budgets');

  Stream<List<Budget>> watchAll() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  Future<void> setLimit({required int categoryId, required double monthlyLimit}) {
    return _collection.doc(categoryId.toString()).set({
      'categoryId': categoryId,
      'monthlyLimit': monthlyLimit,
    });
  }

  Future<void> removeLimit(int categoryId) {
    return _collection.doc(categoryId.toString()).delete();
  }

  Budget _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Budget(
      id: doc.id,
      categoryId: data['categoryId'] as int,
      monthlyLimit: (data['monthlyLimit'] as num).toDouble(),
    );
  }
}
