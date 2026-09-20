import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/dashboard/providers/dashboard_providers.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';

class _FakeTransactionsNotifier extends TransactionsNotifier {
  _FakeTransactionsNotifier(this._seed);

  final List<Transaction> _seed;

  @override
  List<Transaction> build() => _seed;
}

void main() {
  test('saldoDisponivelProvider soma receitas e subtrai despesas', () {
    final now = DateTime.now();
    final fixed = [
      Transaction(
        id: 1,
        description: 'Salário',
        amount: 1000,
        type: TransactionType.income,
        categoryId: 10,
        date: now,
      ),
      Transaction(
        id: 2,
        description: 'Aluguel',
        amount: 400,
        type: TransactionType.expense,
        categoryId: 3,
        date: now,
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        transactionsProvider.overrideWith(() => _FakeTransactionsNotifier(fixed)),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(saldoDisponivelProvider), 600);
    expect(container.read(receitasDoMesProvider), 1000);
    expect(container.read(despesasDoMesProvider), 400);
  });

  test('saldoDisponivelProvider reage a mudanças no transactionsProvider', () {
    final now = DateTime.now();
    final container = ProviderContainer(
      overrides: [
        transactionsProvider.overrideWith(() => _FakeTransactionsNotifier([])),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(saldoDisponivelProvider), 0);

    container.read(transactionsProvider.notifier).add(
      Transaction(
        id: 1,
        description: 'Freela',
        amount: 300,
        type: TransactionType.income,
        categoryId: 11,
        date: now,
      ),
    );

    expect(container.read(saldoDisponivelProvider), 300);
  });
}
