import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../transactions/models/category.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/categories_provider.dart';
import '../../transactions/providers/transactions_provider.dart';

part 'reports_providers.g.dart';

typedef CategoryBreakdown = ({Category category, double value});

typedef MonthlyTotals = ({DateTime month, double income, double expense});

typedef CategoryComparison = ({Category category, double current, double previous});

typedef MonthComparison = ({
  DateTime currentMonth,
  DateTime previousMonth,
  double currentIncome,
  double previousIncome,
  double currentExpense,
  double previousExpense,
  List<CategoryComparison> expenseByCategory,
});

typedef AnnualSummary = ({
  int year,
  double totalIncome,
  double totalExpense,
  List<MonthlyTotals> months,
});

typedef ReportsData = ({
  double totalIncome,
  double totalExpense,
  List<CategoryBreakdown> expenseByCategory,
  List<MonthlyTotals> monthlyEvolution,
  MonthComparison monthComparison,
  AnnualSummary annualSummary,
});

/// Variação percentual de [current] em relação a [previous]. `null` quando
/// não há base de comparação (mês anterior sem valor).
double? percentChange(double current, double previous) {
  if (previous == 0) return current == 0 ? 0 : null;
  return (current - previous) / previous * 100;
}

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
    monthComparison: _monthComparison(transactions, categoryMap, now),
    annualSummary: _annualSummary(transactions, now.year),
  );
}

AnnualSummary _annualSummary(List<Transaction> transactions, int year) {
  final months = List.generate(12, (i) {
    final month = DateTime(year, i + 1);
    final inMonth = transactions.where((t) => t.date.year == month.year && t.date.month == month.month);
    final income = inMonth
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = inMonth
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return (month: month, income: income, expense: expense);
  });

  return (
    year: year,
    totalIncome: months.fold(0.0, (sum, m) => sum + m.income),
    totalExpense: months.fold(0.0, (sum, m) => sum + m.expense),
    months: months,
  );
}

MonthComparison _monthComparison(
  List<Transaction> transactions,
  Map<int, Category> categoryMap,
  DateTime now,
) {
  final currentMonth = DateTime(now.year, now.month);
  final previousMonth = DateTime(now.year, now.month - 1);

  List<Transaction> transactionsInMonth(DateTime month) {
    return transactions.where((t) => t.date.year == month.year && t.date.month == month.month).toList();
  }

  double sumByType(List<Transaction> list, TransactionType type) {
    return list.where((t) => t.type == type).fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<int, double> expenseTotalsByCategory(List<Transaction> list) {
    final totals = <int, double>{};
    for (final t in list) {
      if (t.type != TransactionType.expense) continue;
      totals.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    return totals;
  }

  final currentTransactions = transactionsInMonth(currentMonth);
  final previousTransactions = transactionsInMonth(previousMonth);

  final currentExpenseByCategory = expenseTotalsByCategory(currentTransactions);
  final previousExpenseByCategory = expenseTotalsByCategory(previousTransactions);
  final categoryIds = {...currentExpenseByCategory.keys, ...previousExpenseByCategory.keys};

  final expenseByCategory = categoryIds
      .where((id) => categoryMap.containsKey(id))
      .map((id) => (
            category: categoryMap[id]!,
            current: currentExpenseByCategory[id] ?? 0.0,
            previous: previousExpenseByCategory[id] ?? 0.0,
          ))
      .toList()
    ..sort((a, b) => (b.current - b.previous).abs().compareTo((a.current - a.previous).abs()));

  return (
    currentMonth: currentMonth,
    previousMonth: previousMonth,
    currentIncome: sumByType(currentTransactions, TransactionType.income),
    previousIncome: sumByType(previousTransactions, TransactionType.income),
    currentExpense: sumByType(currentTransactions, TransactionType.expense),
    previousExpense: sumByType(previousTransactions, TransactionType.expense),
    expenseByCategory: expenseByCategory,
  );
}
