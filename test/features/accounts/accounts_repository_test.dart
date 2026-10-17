import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/accounts/models/account.dart';
import 'package:vida_financeira/features/accounts/repositories/accounts_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late AccountsRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = AccountsRepository(firestore, 'user-1');
  });

  test('watchAll() começa vazio para um usuário novo', () async {
    final accounts = await repository.watchAll().first;
    expect(accounts, isEmpty);
  });

  test('add() cria uma conta com os valores informados', () async {
    await repository.add(name: 'Carteira', type: AccountType.wallet, initialBalance: 50);

    final accounts = await repository.watchAll().first;
    expect(accounts, hasLength(1));
    expect(accounts.first.name, 'Carteira');
    expect(accounts.first.type, AccountType.wallet);
    expect(accounts.first.initialBalance, 50);
    expect(accounts.first.isDefault, isFalse);
  });

  test('update() altera os campos de uma conta existente', () async {
    await repository.add(name: 'Carteira', type: AccountType.wallet);
    final account = (await repository.watchAll().first).first;

    await repository.update(account.copyWith(name: 'Carteira física', initialBalance: 100));

    final updated = (await repository.watchAll().first).first;
    expect(updated.name, 'Carteira física');
    expect(updated.initialBalance, 100);
  });

  test('remove() apaga a conta', () async {
    await repository.add(name: 'Carteira', type: AccountType.wallet);
    final account = (await repository.watchAll().first).first;

    await repository.remove(account.id);

    final accounts = await repository.watchAll().first;
    expect(accounts, isEmpty);
  });
}
