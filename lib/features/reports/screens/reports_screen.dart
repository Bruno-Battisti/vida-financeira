import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/formatters.dart';
import '../providers/reports_providers.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/monthly_evolution_chart.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsDataProvider);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro: $error')),
      data: (reports) {
        final total = reports.totalIncome + reports.totalExpense;

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
                      value: reports.totalIncome,
                      ratio: total == 0 ? 0 : reports.totalIncome / total,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _ComparisonBar(
                      label: 'Despesas',
                      value: reports.totalExpense,
                      ratio: total == 0 ? 0 : reports.totalExpense / total,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _MonthComparisonCard(comparison: reports.monthComparison),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distribuição de despesas', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ExpensePieChart(expenseByCategory: reports.expenseByCategory),
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
                    Text('Evolução mensal (últimos 6 meses)', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    MonthlyEvolutionChart(months: reports.monthlyEvolution),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _LegendDot(color: Colors.green, label: 'Receitas'),
                        SizedBox(width: 16),
                        _LegendDot(color: Colors.red, label: 'Despesas'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _AnnualSummaryCard(summary: reports.annualSummary),
          ],
        );
      },
    );
  }
}

class _AnnualSummaryCard extends StatelessWidget {
  const _AnnualSummaryCard({required this.summary});

  final AnnualSummary summary;

  @override
  Widget build(BuildContext context) {
    final balance = summary.totalIncome - summary.totalExpense;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo anual (${summary.year})', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AnnualTotal(label: 'Receitas', value: summary.totalIncome, color: Colors.green),
                ),
                Expanded(
                  child: _AnnualTotal(label: 'Despesas', value: summary.totalExpense, color: Colors.red),
                ),
                Expanded(
                  child: _AnnualTotal(
                    label: 'Saldo',
                    value: balance,
                    color: balance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MonthlyEvolutionChart(months: summary.months),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendDot(color: Colors.green, label: 'Receitas'),
                SizedBox(width: 16),
                _LegendDot(color: Colors.red, label: 'Despesas'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnualTotal extends StatelessWidget {
  const _AnnualTotal({required this.label, required this.value, required this.color});

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          formatCurrency(value),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
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

class _MonthComparisonCard extends StatelessWidget {
  const _MonthComparisonCard({required this.comparison});

  final MonthComparison comparison;

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMMM', 'pt_BR');
    final currentLabel = monthFormat.format(comparison.currentMonth);
    final previousLabel = monthFormat.format(comparison.previousMonth);
    final topCategoryChanges = comparison.expenseByCategory.take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparação com $previousLabel', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ChangeIndicator(
                    label: 'Receitas',
                    current: comparison.currentIncome,
                    previous: comparison.previousIncome,
                    higherIsBetter: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ChangeIndicator(
                    label: 'Despesas',
                    current: comparison.currentExpense,
                    previous: comparison.previousExpense,
                    higherIsBetter: false,
                  ),
                ),
              ],
            ),
            if (topCategoryChanges.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Maiores variações por categoria', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              for (final entry in topCategoryChanges)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(entry.category.icon, size: 16),
                          const SizedBox(width: 6),
                          Text(entry.category.name),
                        ],
                      ),
                      Text(
                        '${formatCurrency(entry.previous)} → ${formatCurrency(entry.current)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 4),
            Text(
              'Mês atual: $currentLabel',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeIndicator extends StatelessWidget {
  const _ChangeIndicator({
    required this.label,
    required this.current,
    required this.previous,
    required this.higherIsBetter,
  });

  final String label;
  final double current;
  final double previous;
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final change = percentChange(current, previous);
    final isIncrease = change != null && change > 0;
    final isGood = change == null ? null : (isIncrease == higherIsBetter);
    final color = change == null || change == 0
        ? Colors.grey
        : (isGood! ? Colors.green : Colors.red);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(formatCurrency(current), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Row(
          children: [
            if (change != null)
              Icon(
                change == 0
                    ? Icons.remove
                    : (isIncrease ? Icons.arrow_upward : Icons.arrow_downward),
                size: 14,
                color: color,
              ),
            const SizedBox(width: 2),
            Text(
              change == null ? 'sem mês anterior' : '${change.abs().toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
