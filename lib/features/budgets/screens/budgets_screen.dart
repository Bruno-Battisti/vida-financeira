import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../dashboard/providers/dashboard_providers.dart';
import '../../transactions/models/category.dart';
import '../../transactions/providers/categories_provider.dart';
import '../models/budget.dart';
import '../providers/budgets_provider.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final budgetsAsync = ref.watch(budgetsProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orçamentos')),
      body: switch ((categoriesAsync, budgetsAsync, summaryAsync)) {
        (AsyncError(:final error), _, _) => Center(child: Text('Erro: $error')),
        (_, AsyncError(:final error), _) => Center(child: Text('Erro: $error')),
        (_, _, AsyncError(:final error)) => Center(child: Text('Erro: $error')),
        (AsyncData(value: final categories), AsyncData(value: final budgets), AsyncData(value: final summary)) =>
          _buildList(context, ref, categories, budgets, summary.gastosPorCategoriaDoMes),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<Category> categories,
    List<Budget> budgets,
    Map<int, double> spentByCategory,
  ) {
    final expenseCategories = categories.where((c) => c.type == CategoryType.expense).toList();
    final budgetByCategory = {for (final b in budgets) b.categoryId: b};

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: expenseCategories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final category = expenseCategories[index];
        final budget = budgetByCategory[category.id];
        final spent = spentByCategory[category.id] ?? 0.0;
        final ratio = budget == null || budget.monthlyLimit == 0 ? 0.0 : spent / budget.monthlyLimit;
        final isOverBudget = ratio > 1;

        return Card(
          child: ListTile(
            leading: Icon(category.icon),
            title: Text(category.name),
            subtitle: budget == null
                ? const Text('Sem limite definido')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: ratio.clamp(0, 1),
                          minHeight: 8,
                          color: isOverBudget ? Colors.red : Colors.green,
                          backgroundColor: (isOverBudget ? Colors.red : Colors.green).withValues(alpha: 0.15),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatCurrency(spent)} de ${formatCurrency(budget.monthlyLimit)}'
                        '${isOverBudget ? ' · acima do limite' : ''}',
                        style: TextStyle(color: isOverBudget ? Colors.red : null),
                      ),
                    ],
                  ),
            isThreeLine: budget != null,
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _editBudget(context, ref, category, budget),
          ),
        );
      },
    );
  }

  Future<void> _editBudget(
    BuildContext context,
    WidgetRef ref,
    Category category,
    Budget? current,
  ) async {
    final controller = TextEditingController(
      text: current == null ? '' : current.monthlyLimit.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<_BudgetDialogResult>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Orçamento · ${category.name}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Limite mensal', prefixText: 'R\$ '),
            validator: (value) {
              final parsed = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
              if (parsed == null || parsed <= 0) {
                return 'Informe um valor maior que zero.';
              }
              return null;
            },
          ),
        ),
        actions: [
          if (current != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(const _BudgetDialogResult.remove()),
              child: const Text('Remover'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final value = double.parse(controller.text.trim().replaceAll(',', '.'));
                Navigator.of(context).pop(_BudgetDialogResult.save(value));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result == null) return;
    final repository = ref.read(budgetsRepositoryProvider);
    if (result.remove) {
      await repository.removeLimit(category.id);
    } else if (result.monthlyLimit != null) {
      await repository.setLimit(categoryId: category.id, monthlyLimit: result.monthlyLimit!);
    }
  }
}

class _BudgetDialogResult {
  const _BudgetDialogResult.save(double value)
      : monthlyLimit = value,
        remove = false;

  const _BudgetDialogResult.remove()
      : monthlyLimit = null,
        remove = true;

  final double? monthlyLimit;
  final bool remove;
}
