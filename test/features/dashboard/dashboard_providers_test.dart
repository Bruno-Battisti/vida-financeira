import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/dashboard/providers/dashboard_providers.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

ProviderContainer _containerWithEmptyFirestore() {
  final repository = TransactionsRepository(FakeFirebaseFirestore(), 'user-1');
  final container = ProviderContainer(
    overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
  );
  // Mantém os providers autoDispose vivos durante o teste, como uma tela real faria.
  container.listen(transactionsProvider, (_, _) {});
  container.listen(dashboardSummaryProvider, (_, _) {});
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('dashboardSummaryProvider soma receitas e subtrai despesas do mês atual', () async {
    final container = _containerWithEmptyFirestore();

    final repository = container.read(transactionsRepositoryProvider);
    final now = DateTime.now();
    await repository.add(
      description: 'Salário',
      amount: 1000,
      type: TransactionType.income,
      categoryId: 10,
      date: now,
    );
    await repository.add(
      description: 'Aluguel',
      amount: 400,
      type: TransactionType.expense,
      categoryId: 3,
      date: now,
    );

    final summary = await container.read(dashboardSummaryProvider.future);

    expect(summary.saldo, 600);
    expect(summary.receitasDoMes, 1000);
    expect(summary.despesasDoMes, 400);
  });

  test('dashboardSummaryProvider ignora transações de meses anteriores nos totais do mês', () async {
    final container = _containerWithEmptyFirestore();

    final repository = container.read(transactionsRepositoryProvider);
    final now = DateTime.now();
    final mesPassado = DateTime(now.year, now.month - 1, 10);

    await repository.add(
      description: 'Receita antiga',
      amount: 500,
      type: TransactionType.income,
      categoryId: 10,
      date: mesPassado,
    );
    await repository.add(
      description: 'Receita atual',
      amount: 200,
      type: TransactionType.income,
      categoryId: 10,
      date: now,
    );

    final summary = await container.read(dashboardSummaryProvider.future);

    expect(summary.saldo, 700);
    expect(summary.receitasDoMes, 200);
  });
}
