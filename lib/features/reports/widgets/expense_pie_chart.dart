import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/chart_colors.dart';
import '../../../core/utils/formatters.dart';
import '../providers/reports_providers.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key, required this.expenseByCategory});

  final List<CategoryBreakdown> expenseByCategory;

  @override
  Widget build(BuildContext context) {
    if (expenseByCategory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Nenhuma despesa registrada.'),
      );
    }

    final total = expenseByCategory.fold(0.0, (sum, item) => sum + item.value);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                for (var i = 0; i < expenseByCategory.length; i++)
                  PieChartSectionData(
                    value: expenseByCategory[i].value,
                    color: chartColorAt(i),
                    radius: 56,
                    title: total == 0
                        ? ''
                        : '${(expenseByCategory[i].value / total * 100).toStringAsFixed(0)}%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            for (var i = 0; i < expenseByCategory.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: chartColorAt(i), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(expenseByCategory[i].category.name)),
                    Text(formatCurrency(expenseByCategory[i].value)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
