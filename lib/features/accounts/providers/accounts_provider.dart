import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../models/account.dart';
import '../models/transfer.dart';
import '../repositories/accounts_repository.dart';
import '../repositories/transfers_repository.dart';

part 'accounts_provider.g.dart';

@riverpod
TransfersRepository transfersRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) {
    throw StateError('transfersRepositoryProvider requer um usuário autenticado.');
  }
  return TransfersRepository(ref.watch(firestoreProvider), uid);
}

@riverpod
Stream<List<Transfer>> transfers(Ref ref) {
  return ref.watch(transfersRepositoryProvider).watchAll();
}

@riverpod
AccountsRepository accountsRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) {
    throw StateError('accountsRepositoryProvider requer um usuário autenticado.');
  }
  return AccountsRepository(ref.watch(firestoreProvider), uid);
}

@riverpod
Stream<List<Account>> accounts(Ref ref) {
  return ref.watch(accountsRepositoryProvider).watchAll();
}

/// Cria a conta "Principal" na primeira vez que o usuário abre o app depois
/// desta feature — garante que sempre exista pelo menos uma conta para
/// absorver as transações antigas (que não têm `accountId`).
@Riverpod(keepAlive: true)
Future<void> ensureDefaultAccount(Ref ref) async {
  final repository = ref.read(accountsRepositoryProvider);
  // Leitura única (não reativa): essa função também escreve na mesma
  // coleção, então um `ref.watch` aqui re-executaria a cada escrita.
  final accounts = await repository.watchAll().first;
  if (accounts.isNotEmpty) return;

  await repository.add(name: 'Principal', type: AccountType.checking, isDefault: true);
}

Account? _defaultAccount(List<Account> accounts) {
  for (final account in accounts) {
    if (account.isDefault) return account;
  }
  return accounts.isEmpty ? null : accounts.first;
}

typedef AccountBalance = ({Account account, double balance});

/// Saldo de cada conta: saldo inicial + soma das transações já pagas
/// atribuídas a ela (transações antigas sem `accountId` contam para a
/// conta padrão) + transferências recebidas/enviadas.
@riverpod
Future<List<AccountBalance>> accountBalances(Ref ref) async {
  final accounts = await ref.watch(accountsProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final transfers = await ref.watch(transfersProvider.future);
  final defaultAccount = _defaultAccount(accounts);

  final totalsByAccount = <String, double>{};
  for (final t in transactions) {
    if (!t.isPaid) continue;
    final accountId = t.accountId ?? defaultAccount?.id;
    if (accountId == null) continue;
    final signed = t.type == TransactionType.income ? t.amount : -t.amount;
    totalsByAccount.update(accountId, (v) => v + signed, ifAbsent: () => signed);
  }
  for (final transfer in transfers) {
    totalsByAccount.update(transfer.fromAccountId, (v) => v - transfer.amount, ifAbsent: () => -transfer.amount);
    totalsByAccount.update(transfer.toAccountId, (v) => v + transfer.amount, ifAbsent: () => transfer.amount);
  }

  return accounts
      .map((a) => (account: a, balance: a.initialBalance + (totalsByAccount[a.id] ?? 0)))
      .toList();
}

typedef CreditCardInvoice = ({
  DateTime periodStart,
  DateTime periodEnd,
  double total,
  List<Transaction> transactions,
});

/// Data de fechamento mais recente que já passou (ou é hoje) — é o fim do
/// ciclo cuja fatura já está fechada e pronta para pagar.
DateTime _mostRecentClosing(int closingDay, DateTime now) {
  final closingThisMonth = DateTime(now.year, now.month, closingDay);
  if (!closingThisMonth.isAfter(now)) return closingThisMonth;
  return DateTime(now.year, now.month - 1, closingDay);
}

/// Fatura fechada mais recente de um cartão de crédito: soma das compras do
/// ciclo (já inclui parcelas, que são transações normais com `accountId`
/// apontando para o cartão).
@riverpod
Future<CreditCardInvoice> creditCardInvoice(Ref ref, String accountId) async {
  final accounts = await ref.watch(accountsProvider.future);
  final account = accounts.firstWhere((a) => a.id == accountId);
  final closingDay = account.closingDay ?? 1;
  final now = DateTime.now();

  final periodEnd = _mostRecentClosing(closingDay, now);
  final periodStart = DateTime(periodEnd.year, periodEnd.month - 1, closingDay + 1);

  final transactions = await ref.watch(transactionsProvider.future);
  final periodTransactions = transactions
      .where((t) =>
          t.accountId == accountId && !t.date.isBefore(periodStart) && !t.date.isAfter(periodEnd))
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  final total = periodTransactions.fold(
    0.0,
    (sum, t) => sum + (t.type == TransactionType.expense ? t.amount : -t.amount),
  );

  return (periodStart: periodStart, periodEnd: periodEnd, total: total, transactions: periodTransactions);
}
