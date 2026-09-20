import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../../transactions/providers/transactions_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    if (transactionsAsync.isLoading || categoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (transactionsAsync.hasError) {
      return Center(child: Text('Erro: ${transactionsAsync.error}'));
    }
    if (categoriesAsync.hasError) {
      return Center(child: Text('Erro: ${categoriesAsync.error}'));
    }

    final transactions = transactionsAsync.requireValue;
    final categoryMap = {for (final c in categoriesAsync.requireValue) c.id: c};

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final total = totalIncome + totalExpense;

    final categoryTotals = <int, double>{};
    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      categoryTotals.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCategoryValue = sortedCategories.isEmpty ? 1.0 : sortedCategories.first.value;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Receitas x Despesas', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                _ComparisonBar(
                  label: 'Receitas',
                  value: totalIncome,
                  ratio: total == 0 ? 0 : totalIncome / total,
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                _ComparisonBar(
                  label: 'Despesas',
                  value: totalExpense,
                  ratio: total == 0 ? 0 : totalExpense / total,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Distribuição de despesas', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                if (sortedCategories.isEmpty)
                  const Text('Nenhuma despesa registrada.')
                else
                  ...sortedCategories.map((entry) {
                    final category = categoryMap[entry.key];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ComparisonBar(
                        label: category?.name ?? 'Categoria',
                        value: entry.value,
                        ratio: entry.value / maxCategoryValue,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Gráficos completos (pizza e evolução mensal) chegam na Fase 7, com a biblioteca fl_chart.',
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonBar extends StatelessWidget {
  const _ComparisonBar({
    required this.label,
    required this.value,
    required this.ratio,
    required this.color,
  });

  final String label;
  final double value;
  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(formatCurrency(value)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio.clamp(0, 1),
            minHeight: 10,
            color: color,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }
}
