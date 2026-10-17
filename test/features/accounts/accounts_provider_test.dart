import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/accounts/models/account.dart';
import 'package:vida_financeira/features/accounts/providers/accounts_provider.dart';
import 'package:vida_financeira/features/accounts/repositories/accounts_repository.dart';
import 'package:vida_financeira/features/accounts/repositories/transfers_repository.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

ProviderContainer _buildContainer() {
  final firestore = FakeFirebaseFirestore();
  final accountsRepository = AccountsRepository(firestore, 'user-1');
  final transactionsRepository = TransactionsRepository(firestore, 'user-1');
  final transfersRepository = TransfersRepository(firestore, 'user-1');

  final container = ProviderContainer(
    overrides: [
      accountsRepositoryProvider.overrideWithValue(accountsRepository),
      transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
      transfersRepositoryProvider.overrideWithValue(transfersRepository),
    ],
  );
  container.listen(accountsProvider, (_, _) {});
  container.listen(transactionsProvider, (_, _) {});
  container.listen(transfersProvider, (_, _) {});
  container.listen(accountBalancesProvider, (_, _) {});
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('ensureDefaultAccount cria a conta Principal quando não há nenhuma', () async {
    final container = _buildContainer();

    await container.read(ensureDefaultAccountProvider.future);

    final accounts = await container.read(accountsProvider.future);
    expect(accounts, hasLength(1));
    expect(accounts.first.name, 'Principal');
    expect(accounts.first.isDefault, isTrue);
  });

  test('ensureDefaultAccount não cria nada se já existe uma conta', () async {
    final container = _buildContainer();
    final accountsRepository = container.read(accountsRepositoryProvider);
    await accountsRepository.add(name: 'Minha conta', type: AccountType.checking);

    await container.read(ensureDefaultAccountProvider.future);

    final accounts = await container.read(accountsProvider.future);
    expect(accounts, hasLength(1));
    expect(accounts.first.name, 'Minha conta');
  });

  test('accountBalances soma saldo inicial + transações pagas da conta', () async {
    final container = _buildContainer();
    final accountsRepository = container.read(accountsRepositoryProvider);
    final transactionsRepository = container.read(transactionsRepositoryProvider);

    await accountsRepository.add(name: 'Principal', type: AccountType.checking, isDefault: true, initialBalance: 100);
    final account = (await accountsRepository.watchAll().first).first;

    await transactionsRepository.add(
      description: 'Salário',
      amount: 1000,
      type: TransactionType.income,
      categoryId: 10,
      date: DateTime.now(),
      accountId: account.id,
    );
    await transactionsRepository.add(
      description: 'Mercado',
      amount: 200,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime.now(),
      accountId: account.id,
    );

    final balances = await container.read(accountBalancesProvider.future);
    expect(balances, hasLength(1));
    expect(balances.first.balance, 900); // 100 + 1000 - 200
  });

  test('transações antigas sem accountId contam para a conta padrão', () async {
    final container = _buildContainer();
    final accountsRepository = container.read(accountsRepositoryProvider);
    final transactionsRepository = container.read(transactionsRepositoryProvider);

    await accountsRepository.add(name: 'Principal', type: AccountType.checking, isDefault: true);

    await transactionsRepository.add(
      description: 'Transação antiga',
      amount: 50,
      type: TransactionType.income,
      categoryId: 10,
      date: DateTime.now(),
    );

    final balances = await container.read(accountBalancesProvider.future);
    expect(balances.first.balance, 50);
  });

  test('transferências debitam a conta de origem e creditam a de destino', () async {
    final container = _buildContainer();
    final accountsRepository = container.read(accountsRepositoryProvider);
    final transfersRepository = container.read(transfersRepositoryProvider);

    await accountsRepository.add(
        name: 'Principal', type: AccountType.checking, isDefault: true, initialBalance: 1000);
    await accountsRepository.add(name: 'Carteira', type: AccountType.wallet);
    final accounts = await accountsRepository.watchAll().first;
    final principal = accounts.firstWhere((a) => a.name == 'Principal');
    final carteira = accounts.firstWhere((a) => a.name == 'Carteira');

    await transfersRepository.add(
      fromAccountId: principal.id,
      toAccountId: carteira.id,
      amount: 200,
      date: DateTime.now(),
    );

    final balances = await container.read(accountBalancesProvider.future);
    final principalBalance = balances.firstWhere((b) => b.account.id == principal.id).balance;
    final carteiraBalance = balances.firstWhere((b) => b.account.id == carteira.id).balance;

    expect(principalBalance, 800);
    expect(carteiraBalance, 200);
  });
}
