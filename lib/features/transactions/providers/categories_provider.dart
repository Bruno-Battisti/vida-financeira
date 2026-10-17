import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/providers.dart';
import '../models/category.dart';
import '../repositories/categories_repository.dart';
import 'transactions_provider.dart';

part 'categories_provider.g.dart';

@riverpod
CategoriesRepository categoriesRepository(Ref ref) {
  return CategoriesRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<Category>> categories(Ref ref) {
  return ref.watch(categoriesRepositoryProvider).watchAll();
}

@riverpod
Future<Category> categoryById(Ref ref, int id) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories.firstWhere((c) => c.id == id);
}

/// Categorias usadas mais recentemente, derivadas da ordem (por data) das
/// transações já carregadas — usado no atalho de lançamento rápido.
@riverpod
Future<List<Category>> recentCategories(Ref ref) async {
  final transactions = await ref.watch(transactionsProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  final categoryMap = {for (final c in categories) c.id: c};

  final seenCategoryIds = <int>{};
  final recent = <Category>[];
  for (final transaction in transactions) {
    if (recent.length >= 6) break;
    if (!seenCategoryIds.add(transaction.categoryId)) continue;
    final category = categoryMap[transaction.categoryId];
    if (category != null) recent.add(category);
  }
  return recent;
}
