import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../transactions/models/category.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../models/budget.dart';
import '../repositories/budgets_repository.dart';

part 'budgets_provider.g.dart';

@riverpod
BudgetsRepository budgetsRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) {
    throw StateError('budgetsRepositoryProvider requer um usuário autenticado.');
  }
  return BudgetsRepository(ref.watch(firestoreProvider), uid);
}

@riverpod
Stream<List<Budget>> budgets(Ref ref) {
  return ref.watch(budgetsRepositoryProvider).watchAll();
}

typedef BudgetProgress = ({Budget budget, Category category, double spent});

/// Orçamentos cruzados com o gasto do mês atual em cada categoria.
@riverpod
Future<List<BudgetProgress>> budgetProgress(Ref ref) async {
  final budgets = await ref.watch(budgetsProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final categoryMap = {for (final c in categories) c.id: c};

  final now = DateTime.now();
  final spentByCategory = <int, double>{};
  for (final t in transactions) {
    if (t.type != TransactionType.expense) continue;
    if (t.date.year != now.year || t.date.month != now.month) continue;
    spentByCategory.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
  }

  final progress = budgets
      .where((b) => categoryMap.containsKey(b.categoryId))
      .map((b) => (
            budget: b,
            category: categoryMap[b.categoryId]!,
            spent: spentByCategory[b.categoryId] ?? 0.0,
          ))
      .toList()
    ..sort((a, b) {
      final ratioA = a.budget.monthlyLimit == 0 ? 0 : a.spent / a.budget.monthlyLimit;
      final ratioB = b.budget.monthlyLimit == 0 ? 0 : b.spent / b.budget.monthlyLimit;
      return ratioB.compareTo(ratioA);
    });

  return progress;
}
