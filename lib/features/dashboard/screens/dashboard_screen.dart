import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/exchange_rate_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    if (summaryAsync.isLoading || categoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (summaryAsync.hasError) {
      return Center(child: Text('Erro ao carregar o dashboard: ${summaryAsync.error}'));
    }
    if (categoriesAsync.hasError) {
      return Center(child: Text('Erro ao carregar categorias: ${categoriesAsync.error}'));
    }

    final summary = summaryAsync.requireValue;
    final categoryMap = {for (final c in categoriesAsync.requireValue) c.id: c};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _BalanceCard(saldo: summary.saldo),
        const SizedBox(height: 16),
        const ExchangeRateCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Receitas do mês',
                value: summary.receitasDoMes,
                color: Colors.green,
                icon: Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Despesas do mês',
                value: summary.despesasDoMes,
                color: Colors.red,
                icon: Icons.arrow_downward,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Gastos por categoria', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (summary.gastosPorCategoriaDoMes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Nenhuma despesa neste mês.'),
          )
        else
          Card(
            child: Column(
              children: summary.gastosPorCategoriaDoMes.entries.map((entry) {
                final category = categoryMap[entry.key];
                return ListTile(
                  leading: Icon(category?.icon ?? Icons.category),
                  title: Text(category?.name ?? 'Categoria'),
                  trailing: Text(formatCurrency(entry.value)),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 24),
        Text('Últimas transações', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (summary.ultimasTransacoes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Nenhuma transação cadastrada ainda.'),
          )
        else
          Card(
            child: Column(
              children: summary.ultimasTransacoes.map((transaction) {
                final category = categoryMap[transaction.categoryId];
                final isIncome = transaction.type == TransactionType.income;
                return ListTile(
                  leading: Icon(category?.icon ?? Icons.category),
                  title: Text(transaction.description),
                  subtitle: Text('${category?.name ?? 'Categoria'} · ${formatDate(transaction.date)}'),
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
