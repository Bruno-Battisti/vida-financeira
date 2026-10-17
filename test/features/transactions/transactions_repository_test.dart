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

  test('add() sem isPaid/dueDate cria uma transação já paga', () async {
    await repository.add(
      description: 'Compra à vista',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 1, 1),
    );

    final transaction = (await repository.watchAll().first).first;
    expect(transaction.isPaid, isTrue);
    expect(transaction.dueDate, isNull);
  });

  test('add() com isPaid: false e dueDate cria uma conta pendente', () async {
    await repository.add(
      description: 'Conta de luz',
      amount: 150,
      type: TransactionType.expense,
      categoryId: 3,
      date: DateTime(2026, 1, 1),
      isPaid: false,
      dueDate: DateTime(2026, 1, 10),
    );

    final transaction = (await repository.watchAll().first).first;
    expect(transaction.isPaid, isFalse);
    expect(transaction.dueDate, DateTime(2026, 1, 10));
  });

  test('update() permite marcar uma conta pendente como paga', () async {
    await repository.add(
      description: 'Conta de luz',
      amount: 150,
      type: TransactionType.expense,
      categoryId: 3,
      date: DateTime(2026, 1, 1),
      isPaid: false,
      dueDate: DateTime(2026, 1, 10),
    );
    final pending = (await repository.watchAll().first).first;

    await repository.update(pending.copyWith(isPaid: true));

    final updated = (await repository.watchAll().first).first;
    expect(updated.isPaid, isTrue);
  });

  test('addInstallments() divide o valor em parcelas mensais ligadas pelo grupo', () async {
    final firstDate = DateTime(2020, 1, 15);

    await repository.addInstallments(
      description: 'Notebook',
      totalAmount: 300,
      type: TransactionType.expense,
      categoryId: 5,
      firstDate: firstDate,
      installmentsCount: 3,
    );

    final transactions = (await repository.watchAll().first)
      ..sort((a, b) => a.date.compareTo(b.date));
    expect(transactions, hasLength(3));

    final groupId = transactions.first.installmentGroupId;
    expect(groupId, isNotNull);
    expect(transactions.every((t) => t.installmentGroupId == groupId), isTrue);
    expect(transactions.map((t) => t.installmentIndex), [1, 2, 3]);
    expect(transactions.map((t) => t.installmentTotal), [3, 3, 3]);
    expect(transactions.map((t) => t.amount).reduce((a, b) => a + b), 300);
    expect(transactions.map((t) => t.date), [
      DateTime(2020, 1, 15),
      DateTime(2020, 2, 15),
      DateTime(2020, 3, 15),
    ]);
    // Parcelas de 2020 já venceram: todas devem ter nascido pagas.
    expect(transactions.every((t) => t.isPaid), isTrue);
  });

  test('addInstallments() marca parcelas futuras como pendentes com vencimento', () async {
    final firstDate = DateTime.now();

    await repository.addInstallments(
      description: 'Celular',
      totalAmount: 1200,
      type: TransactionType.expense,
      categoryId: 5,
      firstDate: firstDate,
      installmentsCount: 3,
    );

    final transactions = (await repository.watchAll().first)
      ..sort((a, b) => a.date.compareTo(b.date));

    expect(transactions.first.isPaid, isTrue);
    expect(transactions[1].isPaid, isFalse);
    expect(transactions[1].dueDate, isNotNull);
    expect(transactions[2].isPaid, isFalse);
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
