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
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('soma só as compras dentro do ciclo fechado mais recente', () async {
    final container = _buildContainer();
    final accountsRepository = container.read(accountsRepositoryProvider);
    final transactionsRepository = container.read(transactionsRepositoryProvider);

    await accountsRepository.add(name: 'Cartão', type: AccountType.creditCard, closingDay: 10);
    final card = (await accountsRepository.watchAll().first).first;

    final now = DateTime.now();
    final closingThisMonth = DateTime(now.year, now.month, 10);
    final periodEnd = closingThisMonth.isAfter(now)
        ? DateTime(now.year, now.month - 1, 10)
        : closingThisMonth;
    final periodStart = DateTime(periodEnd.year, periodEnd.month - 1, 11);

    // Dentro do ciclo fechado.
    await transactionsRepository.add(
      description: 'Compra dentro do ciclo',
      amount: 100,
      type: TransactionType.expense,
      categoryId: 1,
      date: periodEnd,
      accountId: card.id,
    );
    // Fora do ciclo (antes do início).
    await transactionsRepository.add(
      description: 'Compra antiga',
      amount: 999,
      type: TransactionType.expense,
      categoryId: 1,
      date: periodStart.subtract(const Duration(days: 1)),
      accountId: card.id,
    );
    // Outra conta, não deve contar.
    await transactionsRepository.add(
      description: 'Outra conta',
      amount: 50,
      type: TransactionType.expense,
      categoryId: 1,
      date: periodEnd,
      accountId: 'conta-que-nao-existe',
    );

    final invoice = await container.read(creditCardInvoiceProvider(card.id).future);

    expect(invoice.total, 100);
    expect(invoice.transactions, hasLength(1));
    expect(invoice.transactions.first.description, 'Compra dentro do ciclo');
  });
}
