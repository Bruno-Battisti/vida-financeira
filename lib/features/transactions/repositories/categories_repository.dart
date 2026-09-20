import '../../../core/constants/category_icons.dart';
import '../../../database/database.dart';
import '../models/category.dart';

class CategoriesRepository {
  CategoriesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Category>> watchAll() {
    return _db.select(_db.categories).watch().map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  Category _toDomain(CategoryRow row) {
    return Category(
      id: row.id,
      name: row.name,
      icon: iconForKey(row.iconKey),
      type: row.type == 'income' ? CategoryType.income : CategoryType.expense,
    );
  }
}
