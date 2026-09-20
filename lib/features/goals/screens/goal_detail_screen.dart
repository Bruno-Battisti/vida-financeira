import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../providers/goals_provider.dart';
import '../widgets/contribution_dialog.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({super.key, required this.goalId});

  final String goalId;

  Future<void> _contribute(BuildContext context, WidgetRef ref, {required bool isWithdrawal}) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => ContributionDialog(isWithdrawal: isWithdrawal),
    );
    if (amount == null) return;

    try {
      await ref.read(goalsRepositoryProvider).addContribution(goalId: goalId, amount: amount);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isWithdrawal ? 'Retirada registrada.' : 'Aporte adicionado.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível registrar: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir meta'),
        content: const Text('Essa ação também apaga o histórico de aportes e retiradas. Não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(goalsRepositoryProvider).removeGoal(goalId);
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível excluir: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalByIdProvider(goalId));
    final entriesAsync = ref.watch(goalEntriesProvider(goalId));

    return Scaffold(
      appBar: AppBar(
        title: Text(goalAsync.value?.goal.name ?? 'Meta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => context.push('/goals/$goalId/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
        data: (item) {
          final goal = item.goal;
          final percentText = '${(item.progress * 100).toStringAsFixed(0)}%';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Hero(
                  tag: 'goal-progress-${goal.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      percentText,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: item.progress, minHeight: 10),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.savings_outlined),
                      title: const Text('Valor atual'),
                      subtitle: Text(formatCurrency(item.currentAmount)),
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
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _contribute(context, ref, isWithdrawal: false),
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar aporte'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _contribute(context, ref, isWithdrawal: true),
                      icon: const Icon(Icons.remove),
                      label: const Text('Retirar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Histórico', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              entriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Erro: $error'),
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Text('Nenhum aporte registrado ainda.');
                  }
                  return Card(
                    child: Column(
                      children: entries.map((entry) {
                        final isWithdrawal = entry.amount < 0;
                        return ListTile(
                          leading: Icon(
                            isWithdrawal ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isWithdrawal ? Colors.red : Colors.green,
                          ),
                          title: Text(isWithdrawal ? 'Retirada' : 'Aporte'),
                          subtitle: Text(formatDate(entry.date)),
                          trailing: Text(
                            formatCurrency(entry.amount.abs()),
                            style: TextStyle(
                              color: isWithdrawal ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
