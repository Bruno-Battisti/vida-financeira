import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/formatters.dart';
import '../../accounts/providers/accounts_provider.dart';
import '../../budgets/providers/budgets_provider.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../providers/balance_projection_provider.dart';
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
        const _BudgetAlerts(),
        const _AccountBalancesCard(),
        const _BalanceProjectionCard(),
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

class _BudgetAlerts extends ConsumerWidget {
  const _BudgetAlerts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(budgetProgressProvider);
    final progress = switch (progressAsync) {
      AsyncData(:final value) => value,
      _ => const <BudgetProgress>[],
    };
    final overBudget =
        progress.where((p) => p.budget.monthlyLimit > 0 && p.spent > p.budget.monthlyLimit).toList();

    if (overBudget.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Text(
                    'Orçamento estourado',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final p in overBudget)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '${p.category.name}: ${formatCurrency(p.spent)} de ${formatCurrency(p.budget.monthlyLimit)}',
                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountBalancesCard extends ConsumerWidget {
  const _AccountBalancesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    final balances = switch (balancesAsync) {
      AsyncData(:final value) => value,
      _ => const <AccountBalance>[],
    };

    if (balances.length < 2) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saldo por conta', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final item in balances)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.account.name),
                      Text(
                        formatCurrency(item.balance),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item.balance < 0 ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceProjectionCard extends ConsumerWidget {
  const _BalanceProjectionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectionAsync = ref.watch(balanceProjectionProvider);
    final monthFormat = DateFormat('MMM/yy', 'pt_BR');

    return projectionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (projection) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Projeção de saldo', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Considerando contas pendentes, parcelas e recorrências já conhecidas',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: projection.months.map((point) {
                    final isNegative = point.projectedBalance < 0;
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(monthFormat.format(point.month), style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 2),
                          Text(
                            formatCurrency(point.projectedBalance),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isNegative ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
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
