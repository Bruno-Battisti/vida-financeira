import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../transactions/models/category.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../models/recurring_rule.dart';
import '../providers/recurring_rules_provider.dart';

class RecurringRulesScreen extends ConsumerWidget {
  const RecurringRulesScreen({super.key});

  String _frequencyLabel(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.weekly:
        return 'Semanal';
      case RecurrenceFrequency.monthly:
        return 'Mensal';
      case RecurrenceFrequency.yearly:
        return 'Anual';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(recurringRulesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transações recorrentes')),
      body: rulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
        data: (rules) {
          if (rules.isEmpty) {
            return const EmptyState(
              icon: Icons.autorenew,
              title: 'Nenhuma recorrência cadastrada',
              subtitle: 'Toque no botão + para criar uma, como um salário ou assinatura.',
            );
          }

          final categories = switch (categoriesAsync) {
            AsyncData(:final value) => value,
            _ => const <Category>[],
          };
          final categoryMap = {for (final c in categories) c.id: c};

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final rule = rules[index];
              final category = categoryMap[rule.categoryId];
              final isIncome = rule.type == TransactionType.income;

              return Card(
                child: ListTile(
                  leading: Icon(category?.icon ?? Icons.category),
                  title: Text(rule.description),
                  subtitle: Text(
                    '${_frequencyLabel(rule.frequency)} · próxima em ${formatDate(rule.nextOccurrence)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'} ${formatCurrency(rule.amount)}',
                        style: TextStyle(
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: rule.active,
                        onChanged: (value) => ref
                            .read(recurringRulesRepositoryProvider)
                            .update(rule.copyWith(active: value)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Excluir',
                        onPressed: () => ref.read(recurringRulesRepositoryProvider).remove(rule.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/settings/recurring/new'),
        tooltip: 'Nova recorrência',
        child: const Icon(Icons.add),
      ),
    );
  }
}
