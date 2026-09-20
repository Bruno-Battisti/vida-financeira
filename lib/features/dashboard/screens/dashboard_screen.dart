import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';
import '../../transactions/models/transaction.dart';
import '../providers/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saldo = ref.watch(saldoDisponivelProvider);
    final monthIncome = ref.watch(receitasDoMesProvider);
    final monthExpense = ref.watch(despesasDoMesProvider);
    final categoryTotals = ref.watch(gastosPorCategoriaDoMesProvider);
    final recentTransactions = ref.watch(ultimasTransacoesProvider);

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
        if (recentTransactions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Nenhuma transação cadastrada ainda.'),
          )
        else
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
