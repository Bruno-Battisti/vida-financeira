import 'package:cloud_firestore/cloud_firestore.dart';

import '../../transactions/models/transaction.dart';
import '../models/recurring_rule.dart';

class RecurringRulesRepository {
  RecurringRulesRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('recurring_rules');

  Stream<List<RecurringRule>> watchAll() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  Future<void> add({
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required RecurrenceFrequency frequency,
    required DateTime nextOccurrence,
  }) {
    return _collection.add({
      'description': description,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'frequency': frequency.name,
      'nextOccurrence': Timestamp.fromDate(nextOccurrence),
      'active': true,
    });
  }

  Future<void> update(RecurringRule rule) {
    return _collection.doc(rule.id).update({
      'description': rule.description,
      'amount': rule.amount,
      'type': rule.type.name,
      'categoryId': rule.categoryId,
      'frequency': rule.frequency.name,
      'nextOccurrence': Timestamp.fromDate(rule.nextOccurrence),
      'active': rule.active,
    });
  }

  Future<void> remove(String id) {
    return _collection.doc(id).delete();
  }

  RecurringRule _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return RecurringRule(
      id: doc.id,
      description: data['description'] as String,
      amount: (data['amount'] as num).toDouble(),
      type: data['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: data['categoryId'] as int,
      frequency: RecurrenceFrequency.values.firstWhere((f) => f.name == data['frequency']),
      nextOccurrence: (data['nextOccurrence'] as Timestamp).toDate(),
      active: data['active'] as bool? ?? true,
    );
  }
}
