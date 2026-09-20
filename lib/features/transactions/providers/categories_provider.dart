import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_data.dart';
import '../models/category.dart';

part 'categories_provider.g.dart';

@riverpod
List<Category> categories(Ref ref) {
  return MockData.categories;
}

@riverpod
Category categoryById(Ref ref, int id) {
  final categories = ref.watch(categoriesProvider);
  return categories.firstWhere((category) => category.id == id);
}
