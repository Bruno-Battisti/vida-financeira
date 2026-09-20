import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/reports_providers.dart';

class MonthlyEvolutionChart extends StatelessWidget {
  const MonthlyEvolutionChart({super.key, required this.months});

  final List<MonthlyTotals> months;

  @override
  Widget build(BuildContext context) {
    final maxValue = months.fold<double>(
      0,
      (max, m) => [max, m.income, m.expense].reduce((a, b) => a > b ? a : b),
    );

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxValue == 0 ? 1 : maxValue * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= months.length) return const SizedBox();
                  final label = DateFormat('MMM', 'pt_BR').format(months[index].month);
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label, style: Theme.of(context).textTheme.bodySmall),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < months.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(toY: months[i].income, color: Colors.green, width: 8),
                  BarChartRodData(toY: months[i].expense, color: Colors.red, width: 8),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
