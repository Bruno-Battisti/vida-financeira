import 'package:flutter/material.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';
import '../../transactions/models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = MockData.transactions;
    final now = DateTime.now();

    final totalIncome = _sumByType(transactions, TransactionType.income);
    final totalExpense = _sumByType(transactions, TransactionType.expense);
    final saldo = totalIncome - totalExpense;

    final monthTransactions = transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .toList();
    final monthIncome = _sumByType(monthTransactions, TransactionType.income);
    final monthExpense = _sumByType(monthTransactions, TransactionType.expense);

    final categoryTotals = _expenseTotalsByCategory(monthTransactions);
    final recentTransactions = transactions.take(5).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _BalanceCard(saldo: saldo),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Receitas do mês',
                value: monthIncome,
                color: Colors.green,
                icon: Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Despesas do mês',
                value: monthExpense,
                color: Colors.red,
                icon: Icons.arrow_downward,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Gastos por categoria', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (categoryTotals.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Nenhuma despesa neste mês.'),
          )
        else
          Card(
            child: Column(
              children: categoryTotals.entries.map((entry) {
                final category = MockData.categoryById(entry.key);
                return ListTile(
                  leading: Icon(category.icon),
                  title: Text(category.name),
                  trailing: Text(formatCurrency(entry.value)),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 24),
        Text('Últimas transações', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: recentTransactions.map((transaction) {
              final category = MockData.categoryById(transaction.categoryId);
              final isIncome = transaction.type == TransactionType.income;
              return ListTile(
                leading: Icon(category.icon),
                title: Text(transaction.description),
                subtitle: Text('${category.name} · ${formatDate(transaction.date)}'),
                trailing: Text(
                  '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  double _sumByType(List<Transaction> transactions, TransactionType type) {
    return transactions
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount);
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
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(entries);
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.saldo});

  final double saldo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo disponível', style: TextStyle(color: colorScheme.onPrimaryContainer)),
            const SizedBox(height: 8),
            Text(
              formatCurrency(saldo),
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final double value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(label, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency(value),
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
