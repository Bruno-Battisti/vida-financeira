import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/categories_table.dart';
import 'tables/goal_entries_table.dart';
import 'tables/goals_table.dart';
import 'tables/transaction_entries_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Categories, TransactionEntries, Goals, GoalEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await batch((batch) {
          batch.insertAll(categories, _seedCategories);
          batch.insertAll(transactionEntries, _seedTransactions);
          batch.insertAll(goals, _seedGoals);
          batch.insertAll(goalEntries, _seedGoalEntries);
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Na v1 "goals" guardava currentAmount direto na coluna; na v2 esse
          // valor passa a ser derivado da soma de GoalEntries (nunca dessincroniza).
          // App ainda em desenvolvimento, sem dados reais de usuário a preservar,
          // então a tabela é recriada do zero em vez de migrada coluna a coluna.
          await m.deleteTable('goals');
          await m.createTable(goals);
          await m.createTable(goalEntries);
          await batch((batch) {
            batch.insertAll(goals, _seedGoals);
            batch.insertAll(goalEntries, _seedGoalEntries);
          });
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

// categoryId segue a ordem de inserção acima (1 = Alimentação, ..., 10 = Salário, ...).
final _seedTransactions = [
  TransactionEntriesCompanion.insert(
    description: 'Salário de Setembro',
    amount: 4500,
    type: 'income',
    categoryId: 10,
    date: DateTime(2026, 9, 5),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Supermercado',
    amount: 320.50,
    type: 'expense',
    categoryId: 1,
    date: DateTime(2026, 9, 7),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Corrida de aplicativo',
    amount: 45.90,
    type: 'expense',
    categoryId: 2,
    date: DateTime(2026, 9, 8),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Aluguel',
    amount: 1200,
    type: 'expense',
    categoryId: 3,
    date: DateTime(2026, 9, 10),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Cinema',
    amount: 60,
    type: 'expense',
    categoryId: 4,
    date: DateTime(2026, 9, 12),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Projeto freelance',
    amount: 800,
    type: 'income',
    categoryId: 11,
    date: DateTime(2026, 9, 14),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Assinatura streaming',
    amount: 39.90,
    type: 'expense',
    categoryId: 8,
    date: DateTime(2026, 9, 15),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Farmácia',
    amount: 78.30,
    type: 'expense',
    categoryId: 6,
    date: DateTime(2026, 9, 16),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Dividendos',
    amount: 150,
    type: 'income',
    categoryId: 12,
    date: DateTime(2026, 9, 17),
  ),
  TransactionEntriesCompanion.insert(
    description: 'Livro técnico',
    amount: 89.90,
    type: 'expense',
    categoryId: 7,
    date: DateTime(2026, 9, 18),
  ),
];

final _seedGoals = [
  GoalsCompanion.insert(
    name: 'Viagem para o Nordeste',
    targetAmount: 5000,
    deadline: Value(DateTime(2027, 1, 15)),
  ),
  GoalsCompanion.insert(
    name: 'Reserva de emergência',
    targetAmount: 10000,
  ),
  GoalsCompanion.insert(
    name: 'Notebook novo',
    targetAmount: 4500,
    deadline: Value(DateTime(2026, 10, 1)),
  ),
];

// goalId segue a ordem de inserção acima (1 = Viagem, 2 = Reserva, 3 = Notebook).
final _seedGoalEntries = [
  GoalEntriesCompanion.insert(goalId: 1, amount: 1800, date: DateTime(2026, 8, 1)),
  GoalEntriesCompanion.insert(goalId: 2, amount: 6200, date: DateTime(2026, 8, 1)),
  GoalEntriesCompanion.insert(goalId: 3, amount: 4500, date: DateTime(2026, 8, 1)),
];
