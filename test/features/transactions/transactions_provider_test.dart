import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';

void main() {
  test('build() carrega as transações fictícias ordenadas por data decrescente', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final transactions = container.read(transactionsProvider);

    expect(transactions, isNotEmpty);
    for (var i = 0; i < transactions.length - 1; i++) {
      expect(transactions[i].date.isBefore(transactions[i + 1].date), isFalse);
    }
  });

  test('add() insere uma nova transação e mantém a ordenação por data', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(transactionsProvider.notifier);
    final before = container.read(transactionsProvider).length;

    notifier.add(
      Transaction(
        id: 999,
        description: 'Teste',
        amount: 10,
        type: TransactionType.expense,
        categoryId: 1,
        date: DateTime(2030, 1, 1),
      ),
    );

    final after = container.read(transactionsProvider);
    expect(after.length, before + 1);
    expect(after.first.description, 'Teste');
  });

  test('update() substitui a transação com o mesmo id', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(transactionsProvider.notifier);
    final original = container.read(transactionsProvider).first;

    notifier.update(original.copyWith(description: 'Atualizada'));

    final result = container.read(transactionsProvider).firstWhere((t) => t.id == original.id);
    expect(result.description, 'Atualizada');
  });

  test('remove() retira a transação da lista', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(transactionsProvider.notifier);
    final target = container.read(transactionsProvider).first;

    notifier.remove(target.id);

    final result = container.read(transactionsProvider);
    expect(result.any((t) => t.id == target.id), isFalse);
  });

  test('transactionByIdProvider retorna a transação correta', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final target = container.read(transactionsProvider).first;
    final found = container.read(transactionByIdProvider(target.id));

    expect(found.id, target.id);
    expect(found.description, target.description);
  });
}
