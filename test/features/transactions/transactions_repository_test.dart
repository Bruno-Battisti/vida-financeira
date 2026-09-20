import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/database/database.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

void main() {
  late AppDatabase db;
  late TransactionsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TransactionsRepository(db);
  });

  tearDown(() => db.close());

  test('watchAll() começa com as transações fictícias, ordenadas por data decrescente', () async {
    final transactions = await repository.watchAll().first;

    expect(transactions, isNotEmpty);
    for (var i = 0; i < transactions.length - 1; i++) {
      expect(transactions[i].date.isBefore(transactions[i + 1].date), isFalse);
    }
  });

  test('add() insere uma transação e watchAll() emite a lista atualizada', () async {
    final before = await repository.watchAll().first;

    await repository.add(
      description: 'Teste',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2030, 1, 1),
    );

    final after = await repository.watchAll().first;
    expect(after.length, before.length + 1);
    expect(after.first.description, 'Teste');
  });

  test('update() altera os campos de uma transação existente', () async {
    final original = (await repository.watchAll().first).first;

    await repository.update(original.copyWith(description: 'Atualizada'));

    final updated = (await repository.watchAll().first).firstWhere((t) => t.id == original.id);
    expect(updated.description, 'Atualizada');
  });

  test('remove() apaga a transação da lista', () async {
    final target = (await repository.watchAll().first).first;

    await repository.remove(target.id);

    final after = await repository.watchAll().first;
    expect(after.any((t) => t.id == target.id), isFalse);
  });
}
