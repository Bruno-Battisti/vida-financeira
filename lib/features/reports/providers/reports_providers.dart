import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../transactions/models/category.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../../transactions/providers/transactions_provider.dart';

part 'reports_providers.g.dart';

typedef CategoryBreakdown = ({Category category, double value});

typedef MonthlyTotals = ({DateTime month, double income, double expense});

typedef ReportsData = ({
  double totalIncome,
  double totalExpense,
  List<CategoryBreakdown> expenseByCategory,
  List<MonthlyTotals> monthlyEvolution,
});

@riverpod
Future<ReportsData> reportsData(Ref ref) async {
  final transactions = await ref.watch(transactionsProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  final categoryMap = {for (final c in categories) c.id: c};

  final totalIncome = transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
  final totalExpense = transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  final categoryTotals = <int, double>{};
  for (final t in transactions) {
    if (t.type != TransactionType.expense) continue;
    categoryTotals.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
  }
  final expenseByCategory = categoryTotals.entries
      .where((entry) => categoryMap.containsKey(entry.key))
      .map((entry) => (category: categoryMap[entry.key]!, value: entry.value))
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final now = DateTime.now();
  final months = List.generate(6, (i) => DateTime(now.year, now.month - (5 - i)));
  final monthlyEvolution = months.map((month) {
    final inMonth = transactions.where((t) => t.date.year == month.year && t.date.month == month.month);
    final income = inMonth
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = inMonth
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return (month: month, income: income, expense: expense);
  }).toList();

  return (
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    expenseByCategory: expenseByCategory,
    monthlyEvolution: monthlyEvolution,
  );
}
