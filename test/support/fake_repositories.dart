import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vida_financeira/app/app.dart';
import 'package:vida_financeira/core/constants/category_icons.dart';
import 'package:vida_financeira/core/providers/firebase_providers.dart';
import 'package:vida_financeira/core/providers/shared_preferences_provider.dart';
import 'package:vida_financeira/features/goals/providers/goals_provider.dart';
import 'package:vida_financeira/features/goals/repositories/goals_repository.dart';
import 'package:vida_financeira/features/transactions/models/category.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/categories_provider.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';
import 'package:vida_financeira/features/transactions/repositories/categories_repository.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

const _testUid = 'test-user';

/// Categorias continuam locais (Drift) na app real — aqui um fake simples
/// em memória evita precisar de um banco de verdade só para o teste de UI.
class FakeCategoriesRepository implements CategoriesRepository {
  final List<Category> _items = [
    Category(id: 1, name: 'Alimentação', icon: iconForKey('restaurant'), type: CategoryType.expense),
    Category(id: 2, name: 'Transporte', icon: iconForKey('directions_car'), type: CategoryType.expense),
    Category(id: 3, name: 'Moradia', icon: iconForKey('home'), type: CategoryType.expense),
    Category(id: 4, name: 'Lazer', icon: iconForKey('sports_esports'), type: CategoryType.expense),
    Category(id: 5, name: 'Compras', icon: iconForKey('shopping_bag'), type: CategoryType.expense),
    Category(id: 6, name: 'Saúde', icon: iconForKey('local_hospital'), type: CategoryType.expense),
    Category(id: 7, name: 'Educação', icon: iconForKey('school'), type: CategoryType.expense),
    Category(id: 8, name: 'Assinaturas', icon: iconForKey('subscriptions'), type: CategoryType.expense),
    Category(id: 9, name: 'Outros', icon: iconForKey('category'), type: CategoryType.expense),
    Category(id: 10, name: 'Salário', icon: iconForKey('payments'), type: CategoryType.income),
    Category(id: 11, name: 'Freelance', icon: iconForKey('laptop_mac'), type: CategoryType.income),
    Category(id: 12, name: 'Investimentos', icon: iconForKey('trending_up'), type: CategoryType.income),
    Category(id: 13, name: 'Outros', icon: iconForKey('category'), type: CategoryType.income),
  ];

  @override
  Stream<List<Category>> watchAll() => Stream.value(List.unmodifiable(_items));
}

Future<void> _seedTransactions(TransactionsRepository repo) async {
  final seed = [
    ('Salário de Setembro', 4500.0, TransactionType.income, 10, DateTime(2026, 9, 5)),
    ('Supermercado', 320.50, TransactionType.expense, 1, DateTime(2026, 9, 7)),
    ('Corrida de aplicativo', 45.90, TransactionType.expense, 2, DateTime(2026, 9, 8)),
    ('Aluguel', 1200.0, TransactionType.expense, 3, DateTime(2026, 9, 10)),
    ('Cinema', 60.0, TransactionType.expense, 4, DateTime(2026, 9, 12)),
    ('Projeto freelance', 800.0, TransactionType.income, 11, DateTime(2026, 9, 14)),
    ('Assinatura streaming', 39.90, TransactionType.expense, 8, DateTime(2026, 9, 15)),
    ('Farmácia', 78.30, TransactionType.expense, 6, DateTime(2026, 9, 16)),
    ('Dividendos', 150.0, TransactionType.income, 12, DateTime(2026, 9, 17)),
    ('Livro técnico', 89.90, TransactionType.expense, 7, DateTime(2026, 9, 18)),
  ];

  for (final (description, amount, type, categoryId, date) in seed) {
    await repo.add(description: description, amount: amount, type: type, categoryId: categoryId, date: date);
  }
}

Future<void> _seedGoals(GoalsRepository repo) async {
  final seed = [
    ('Viagem para o Nordeste', 5000.0, 1800.0),
    ('Reserva de emergência', 10000.0, 6200.0),
    ('Notebook novo', 4500.0, 4500.0),
  ];

  for (final (name, target, current) in seed) {
    await repo.addGoal(name: name, targetAmount: target);
    final created = (await repo.watchAllWithProgress().first).firstWhere((g) => g.goal.name == name);
    await repo.addContribution(goalId: created.goal.id, amount: current, date: DateTime(2026, 8, 1));
  }
}

/// Monta o app com dados de teste (Firestore fake + auth mockado, já
/// logado) prontos para `tester.pumpWidget()` nos testes de widget.
Future<Widget> appWithFakeRepositories() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  final firestore = FakeFirebaseFirestore();
  final transactionsRepository = TransactionsRepository(firestore, _testUid);
  final goalsRepository = GoalsRepository(firestore, _testUid);
  await _seedTransactions(transactionsRepository);
  await _seedGoals(goalsRepository);

  final auth = MockFirebaseAuth(
    mockUser: MockUser(uid: _testUid, email: 'teste@vidafinanceira.app'),
    signedIn: true,
  );

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      firebaseAuthProvider.overrideWithValue(auth),
      transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
      goalsRepositoryProvider.overrideWithValue(goalsRepository),
      categoriesRepositoryProvider.overrideWithValue(FakeCategoriesRepository()),
    ],
    child: const VidaFinanceiraApp(),
  );
}
