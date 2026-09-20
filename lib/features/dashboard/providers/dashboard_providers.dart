import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transactions_provider.dart';

part 'dashboard_providers.g.dart';

typedef DashboardSummary = ({
  double saldo,
  double receitasDoMes,
  double despesasDoMes,
  Map<int, double> gastosPorCategoriaDoMes,
  List<Transaction> ultimasTransacoes,
});

@riverpod
Future<DashboardSummary> dashboardSummary(Ref ref) async {
  final transactions = await ref.watch(transactionsProvider.future);
  final now = DateTime.now();

  final monthTransactions = transactions
      .where((t) => t.date.year == now.year && t.date.month == now.month)
      .toList();

  return (
    saldo: _sumByType(transactions, TransactionType.income) -
        _sumByType(transactions, TransactionType.expense),
    receitasDoMes: _sumByType(monthTransactions, TransactionType.income),
    despesasDoMes: _sumByType(monthTransactions, TransactionType.expense),
    gastosPorCategoriaDoMes: _expenseTotalsByCategory(monthTransactions),
    ultimasTransacoes: transactions.take(5).toList(),
  );
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
