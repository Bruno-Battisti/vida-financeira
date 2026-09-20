import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          ],
        );
      },
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
