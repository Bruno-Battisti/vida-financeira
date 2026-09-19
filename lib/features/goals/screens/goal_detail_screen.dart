import 'package:flutter/material.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key, required this.goalId});

  final int goalId;

  @override
  Widget build(BuildContext context) {
    final goal = MockData.goals.firstWhere((g) => g.id == goalId);
    final percentText = '${(goal.progress * 100).toStringAsFixed(0)}%';

    return Scaffold(
      appBar: AppBar(title: Text(goal.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Text(
              percentText,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: goal.progress, minHeight: 10),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.savings_outlined),
                  title: const Text('Valor atual'),
                  subtitle: Text(formatCurrency(goal.currentAmount)),
                ),
                ListTile(
                  leading: const Icon(Icons.outlined_flag),
                  title: const Text('Objetivo'),
                  subtitle: Text(formatCurrency(goal.targetAmount)),
                ),
                if (goal.deadline != null)
                  ListTile(
                    leading: const Icon(Icons.event_outlined),
                    title: const Text('Prazo'),
                    subtitle: Text(formatDate(goal.deadline!)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adicionar/retirar dinheiro chega na Fase 8.')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar aporte'),
          ),
        ],
      ),
    );
  }
}
