import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/categories_table.dart';

part 'database.g.dart';

/// Transações e metas moraram aqui até a Fase 9; na Fase 10 passaram a
/// morar no Firestore (dados por usuário, sincronizados entre dispositivos).
/// Categorias continuam locais: são configuração fixa do app, não dados do
/// usuário, então não fazem sentido "sincronizadas por conta".
@DriftDatabase(tables: [Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await batch((batch) {
          batch.insertAll(categories, _seedCategories);
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          // transaction_entries, goals e goal_entries migraram para o
          // Firestore nesta versão; as tabelas locais correspondentes somem.
          await m.deleteTable('transaction_entries');
          await m.deleteTable('goals');
          await m.deleteTable('goal_entries');
        }
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'vida_financeira');
}

final _seedCategories = [
  CategoriesCompanion.insert(name: 'Alimentação', iconKey: 'restaurant', type: 'expense'),
  CategoriesCompanion.insert(name: 'Transporte', iconKey: 'directions_car', type: 'expense'),
  CategoriesCompanion.insert(name: 'Moradia', iconKey: 'home', type: 'expense'),
  CategoriesCompanion.insert(name: 'Lazer', iconKey: 'sports_esports', type: 'expense'),
  CategoriesCompanion.insert(name: 'Compras', iconKey: 'shopping_bag', type: 'expense'),
  CategoriesCompanion.insert(name: 'Saúde', iconKey: 'local_hospital', type: 'expense'),
  CategoriesCompanion.insert(name: 'Educação', iconKey: 'school', type: 'expense'),
  CategoriesCompanion.insert(name: 'Assinaturas', iconKey: 'subscriptions', type: 'expense'),
  CategoriesCompanion.insert(name: 'Outros', iconKey: 'category', type: 'expense'),
  CategoriesCompanion.insert(name: 'Salário', iconKey: 'payments', type: 'income'),
  CategoriesCompanion.insert(name: 'Freelance', iconKey: 'laptop_mac', type: 'income'),
  CategoriesCompanion.insert(name: 'Investimentos', iconKey: 'trending_up', type: 'income'),
  CategoriesCompanion.insert(name: 'Outros', iconKey: 'category', type: 'income'),
];
