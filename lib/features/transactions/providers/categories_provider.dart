import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/providers.dart';
import '../models/category.dart';
import '../repositories/categories_repository.dart';

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
