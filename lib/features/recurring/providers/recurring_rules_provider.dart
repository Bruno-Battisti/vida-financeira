import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../models/recurring_rule.dart';
import '../repositories/recurring_rules_repository.dart';
import '../services/recurring_generation_service.dart';

part 'recurring_rules_provider.g.dart';

@riverpod
RecurringRulesRepository recurringRulesRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) {
    throw StateError('recurringRulesRepositoryProvider requer um usuário autenticado.');
  }
  return RecurringRulesRepository(ref.watch(firestoreProvider), uid);
}

@riverpod
Stream<List<RecurringRule>> recurringRules(Ref ref) {
  return ref.watch(recurringRulesRepositoryProvider).watchAll();
}

/// Roda uma única vez por sessão (provider `keepAlive`) assim que o usuário
/// entra no app, materializando as ocorrências de recorrências já vencidas.
@Riverpod(keepAlive: true)
Future<void> recurringGeneration(Ref ref) async {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return;

  final service = RecurringGenerationService(
    ref.watch(recurringRulesRepositoryProvider),
    ref.watch(transactionsRepositoryProvider),
  );
  await service.generateDueTransactions();
}
