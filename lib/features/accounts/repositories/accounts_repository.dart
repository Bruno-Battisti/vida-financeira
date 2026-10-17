import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/account.dart';

class AccountsRepository {
  AccountsRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('accounts');

  Stream<List<Account>> watchAll() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  Future<void> add({
    required String name,
    required AccountType type,
    double initialBalance = 0,
    bool isDefault = false,
  }) {
    return _collection.add({
      'name': name,
      'type': type.name,
      'initialBalance': initialBalance,
      'isDefault': isDefault,
    });
  }

  Future<void> update(Account account) {
    return _collection.doc(account.id).update({
      'name': account.name,
      'type': account.type.name,
      'initialBalance': account.initialBalance,
      'isDefault': account.isDefault,
    });
  }

  Future<void> remove(String id) {
    return _collection.doc(id).delete();
  }

  Account _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Account(
      id: doc.id,
      name: data['name'] as String,
      type: AccountType.values.firstWhere((t) => t.name == data['type'], orElse: () => AccountType.checking),
      initialBalance: (data['initialBalance'] as num?)?.toDouble() ?? 0,
      isDefault: data['isDefault'] as bool? ?? false,
    );
  }
}
