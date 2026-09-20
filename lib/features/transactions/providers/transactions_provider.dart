import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/providers.dart';
import '../models/transaction.dart';
import '../repositories/transactions_repository.dart';

part 'transactions_provider.g.dart';

@riverpod
TransactionsRepository transactionsRepository(Ref ref) {
  return TransactionsRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<Transaction>> transactions(Ref ref) {
  return ref.watch(transactionsRepositoryProvider).watchAll();
}

@riverpod
Future<Transaction> transactionById(Ref ref, int id) async {
  final transactions = await ref.watch(transactionsProvider.future);
  return transactions.firstWhere((t) => t.id == id);
}
