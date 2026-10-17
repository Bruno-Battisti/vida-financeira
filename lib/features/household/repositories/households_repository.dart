import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/household.dart';

/// Um household tem o uid do dono como id do documento — assim, "a quem
/// pertencem os dados que devo ler" (`households/{ownerUid}`) é uma
/// consulta direta, sem precisar de uma coleção extra de mapeamento.
class HouseholdsRepository {
  HouseholdsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('households');

  Stream<Household?> watchMyHousehold(String uid) {
    return _collection.where('memberUids', arrayContains: uid).limit(1).snapshots().map(
          (snapshot) => snapshot.docs.isEmpty ? null : _fromDoc(snapshot.docs.first),
        );
  }

  /// Cria o household solo do usuário (ele mesmo como único membro) caso
  /// ele ainda não faça parte de nenhum.
  Future<void> ensureHousehold(String uid) async {
    final existing = await _collection.where('memberUids', arrayContains: uid).limit(1).get();
    if (existing.docs.isNotEmpty) return;

    await _collection.doc(uid).set({'ownerUid': uid, 'memberUids': [uid]});
  }

  /// Entra no household de outra pessoa usando o uid dela como "código de
  /// convite", saindo do próprio household solo (que é apagado se ninguém
  /// mais fizer parte dele).
  Future<void> join({required String myUid, required String inviteCode}) async {
    if (inviteCode == myUid) return;

    final targetRef = _collection.doc(inviteCode);
    final targetSnapshot = await targetRef.get();
    if (!targetSnapshot.exists) {
      throw Exception('Código de convite inválido.');
    }

    await targetRef.update({
      'memberUids': FieldValue.arrayUnion([myUid]),
    });

    final mineRef = _collection.doc(myUid);
    final mineSnapshot = await mineRef.get();
    if (mineSnapshot.exists) {
      final members = List<String>.from(mineSnapshot.data()!['memberUids'] as List);
      if (members.length <= 1) {
        await mineRef.delete();
      } else {
        await mineRef.update({
          'memberUids': FieldValue.arrayRemove([myUid]),
        });
      }
    }
  }

  /// Sai do household compartilhado atual e volta a ter um household solo.
  Future<void> leave(String uid) async {
    final household = await watchMyHousehold(uid).first;
    if (household == null || household.ownerUid == uid) return;

    await _collection.doc(household.ownerUid).update({
      'memberUids': FieldValue.arrayRemove([uid]),
    });
    await ensureHousehold(uid);
  }

  Household _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Household(
      ownerUid: data['ownerUid'] as String,
      memberUids: List<String>.from(data['memberUids'] as List),
    );
  }
}
