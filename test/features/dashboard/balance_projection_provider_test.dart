import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/dashboard/providers/balance_projection_provider.dart';
import 'package:vida_financeira/features/dashboard/providers/dashboard_providers.dart';
import 'package:vida_financeira/features/recurring/models/recurring_rule.dart';
import 'package:vida_financeira/features/recurring/providers/recurring_rules_provider.dart';
import 'package:vida_financeira/features/recurring/repositories/recurring_rules_repository.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

ProviderContainer _buildContainer() {
  final firestore = FakeFirebaseFirestore();
  final transactionsRepository = TransactionsRepository(firestore, 'user-1');
  final recurringRulesRepository = RecurringRulesRepository(firestore, 'user-1');

  final container = ProviderContainer(
    overrides: [
      transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
      recurringRulesRepositoryProvider.overrideWithValue(recurringRulesRepository),
    ],
  );
  container.listen(transactionsProvider, (_, _) {});
  container.listen(recurringRulesProvider, (_, _) {});
  container.listen(dashboardSummaryProvider, (_, _) {});
  container.listen(balanceProjectionProvider, (_, _) {});
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('saldo projetado parte do saldo atual quando não há pendências', () async {
    final container = _buildContainer();
    final repository = container.read(transactionsRepositoryProvider);
    await repository.add(
      description: 'Salário',
      amount: 1000,
      type: TransactionType.income,
      categoryId: 10,
      date: DateTime.now(),
    );

    final projection = await container.read(balanceProjectionProvider.future);

    expect(projection.currentBalance, 1000);
    expect(projection.months, hasLength(3));
    for (final point in projection.months) {
      expect(point.projectedBalance, 1000);
    }
  });

  test('desconta uma conta a pagar pendente no mês do vencimento em diante', () async {
    final container = _buildContainer();
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
      description: 'Conta de luz',
      amount: 200,
      type: TransactionType.expense,
      categoryId: 3,
      date: now,
      isPaid: false,
      dueDate: DateTime(now.year, now.month + 1, 10),
    );

    final projection = await container.read(balanceProjectionProvider.future);

    expect(projection.months[0].projectedBalance, 1000);
    expect(projection.months[1].projectedBalance, 800);
    expect(projection.months[2].projectedBalance, 800);
  });

  test('inclui as próximas ocorrências de uma regra recorrente ativa', () async {
    final container = _buildContainer();
    final transactionsRepository = container.read(transactionsRepositoryProvider);
    final rulesRepository = container.read(recurringRulesRepositoryProvider);
    final now = DateTime.now();

    await transactionsRepository.add(
      description: 'Salário',
      amount: 1000,
      type: TransactionType.income,
      categoryId: 10,
      date: now,
    );
    await rulesRepository.add(
      description: 'Assinatura',
      amount: 50,
      type: TransactionType.expense,
      categoryId: 8,
      frequency: RecurrenceFrequency.monthly,
      nextOccurrence: DateTime(now.year, now.month + 1, 5),
    );

    final projection = await container.read(balanceProjectionProvider.future);

    expect(projection.months[0].projectedBalance, 1000);
    expect(projection.months[1].projectedBalance, 950);
    expect(projection.months[2].projectedBalance, 900);
  });
}
