import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/transaction.dart';
import '../repositories/transactions_repository.dart';

part 'transactions_provider.g.dart';

@riverpod
TransactionsRepository transactionsRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) {
    throw StateError('transactionsRepositoryProvider requer um usuário autenticado.');
  }
  return TransactionsRepository(ref.watch(firestoreProvider), uid);
}

@riverpod
Stream<List<Transaction>> transactions(Ref ref) {
  return ref.watch(transactionsRepositoryProvider).watchAll();
}

@riverpod
Future<Transaction> transactionById(Ref ref, String id) async {
  final transactions = await ref.watch(transactionsProvider.future);
  return transactions.firstWhere((t) => t.id == id);
}
