import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/household.dart';
import '../repositories/households_repository.dart';

part 'household_provider.g.dart';

@Riverpod(keepAlive: true)
HouseholdsRepository householdsRepository(Ref ref) {
  return HouseholdsRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<Household?> household(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(householdsRepositoryProvider).watchMyHousehold(uid);
}

/// Cria o household solo do usuário na primeira sessão, caso ele ainda não
/// faça parte de nenhum (nem o próprio, nem um compartilhado).
@Riverpod(keepAlive: true)
Future<void> ensureHousehold(Ref ref) async {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return;
  await ref.read(householdsRepositoryProvider).ensureHousehold(uid);
}

/// uid efetivo usado para montar os caminhos `users/{effectiveOwnerUid}/...`
/// de todos os outros repositórios do app: o dono do household do usuário
/// (ele mesmo, por padrão, ou o dono de um household compartilhado em que
/// ele tenha entrado).
@riverpod
String? effectiveOwnerUid(Ref ref) {
  final myUid = ref.watch(authStateProvider).value?.uid;
  if (myUid == null) return null;
  final household = ref.watch(householdProvider).value;
  return household?.ownerUid ?? myUid;
}
