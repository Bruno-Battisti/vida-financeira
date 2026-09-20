import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late TransactionsRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = TransactionsRepository(firestore, 'user-1');
  });

  test('watchAll() começa vazio para um usuário novo', () async {
    final transactions = await repository.watchAll().first;
    expect(transactions, isEmpty);
  });

  test('add() insere uma transação e watchAll() emite a lista atualizada', () async {
    await repository.add(
      description: 'Salário',
      amount: 4500,
      type: TransactionType.income,
      categoryId: 10,
      date: DateTime(2026, 9, 5),
    );

    final transactions = await repository.watchAll().first;
    expect(transactions, hasLength(1));
    expect(transactions.first.description, 'Salário');
  });

  test('watchAll() ordena por data decrescente', () async {
    await repository.add(
      description: 'Mais antiga',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 1, 1),
    );
    await repository.add(
      description: 'Mais recente',
      amount: 20,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 6, 1),
    );

    final transactions = await repository.watchAll().first;
    expect(transactions.first.description, 'Mais recente');
    expect(transactions.last.description, 'Mais antiga');
  });

  test('update() altera os campos de uma transação existente', () async {
    await repository.add(
      description: 'Original',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 1, 1),
    );
    final original = (await repository.watchAll().first).first;

    await repository.update(original.copyWith(description: 'Atualizada'));

    final updated = (await repository.watchAll().first).first;
    expect(updated.description, 'Atualizada');
  });

  test('remove() apaga a transação da lista', () async {
    await repository.add(
      description: 'Para apagar',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 1, 1),
    );
    final target = (await repository.watchAll().first).first;

    await repository.remove(target.id);

    final transactions = await repository.watchAll().first;
    expect(transactions, isEmpty);
  });

  test('cada usuário só vê as próprias transações', () async {
    final otherUserRepo = TransactionsRepository(firestore, 'user-2');

    await repository.add(
      description: 'Do user-1',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 1, 1),
    );

    final user1Transactions = await repository.watchAll().first;
    final user2Transactions = await otherUserRepo.watchAll().first;

    expect(user1Transactions, hasLength(1));
    expect(user2Transactions, isEmpty);
  });
}
