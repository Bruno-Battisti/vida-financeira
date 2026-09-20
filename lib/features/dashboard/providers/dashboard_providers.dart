import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transactions_provider.dart';

part 'dashboard_providers.g.dart';

@riverpod
List<Transaction> transactionsDoMes(Ref ref) {
  final transactions = ref.watch(transactionsProvider);
  final now = DateTime.now();
  return transactions
      .where((t) => t.date.year == now.year && t.date.month == now.month)
      .toList();
}

@riverpod
double saldoDisponivel(Ref ref) {
  final transactions = ref.watch(transactionsProvider);
  return _sumByType(transactions, TransactionType.income) -
      _sumByType(transactions, TransactionType.expense);
}

@riverpod
double receitasDoMes(Ref ref) {
  return _sumByType(ref.watch(transactionsDoMesProvider), TransactionType.income);
}

@riverpod
double despesasDoMes(Ref ref) {
  return _sumByType(ref.watch(transactionsDoMesProvider), TransactionType.expense);
}

@riverpod
Map<int, double> gastosPorCategoriaDoMes(Ref ref) {
  final transactions = ref.watch(transactionsDoMesProvider);
  return _expenseTotalsByCategory(transactions);
}

@riverpod
List<Transaction> ultimasTransacoes(Ref ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.take(5).toList();
}

double _sumByType(List<Transaction> transactions, TransactionType type) {
  return transactions.where((t) => t.type == type).fold(0.0, (sum, t) => sum + t.amount);
}

Map<int, double> _expenseTotalsByCategory(List<Transaction> transactions) {
  final totals = <int, double>{};
  for (final transaction in transactions) {
    if (transaction.type != TransactionType.expense) continue;
    totals.update(
      transaction.categoryId,
      (value) => value + transaction.amount,
      ifAbsent: () => transaction.amount,
    );
  }
  final entries = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  return Map.fromEntries(entries);
}
