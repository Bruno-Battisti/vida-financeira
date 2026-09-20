import 'dart:async';

import 'package:vida_financeira/core/constants/category_icons.dart';
import 'package:vida_financeira/features/goals/models/goal.dart';
import 'package:vida_financeira/features/goals/repositories/goals_repository.dart';
import 'package:vida_financeira/features/transactions/models/category.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/repositories/categories_repository.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

/// Repositórios em memória (sem Drift) usados só em testes de widget, para
/// evitar o Timer que o cancelamento de query streams do Drift agenda no
/// dispose — o `flutter_test` falha se esse Timer ainda estiver pendente
/// quando a árvore de widgets é desmontada entre testes.

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

class FakeTransactionsRepository implements TransactionsRepository {
  final List<Transaction> _items = [
    Transaction(id: 1, description: 'Salário de Setembro', amount: 4500, type: TransactionType.income, categoryId: 10, date: DateTime(2026, 9, 5)),
    Transaction(id: 2, description: 'Supermercado', amount: 320.50, type: TransactionType.expense, categoryId: 1, date: DateTime(2026, 9, 7)),
    Transaction(id: 3, description: 'Corrida de aplicativo', amount: 45.90, type: TransactionType.expense, categoryId: 2, date: DateTime(2026, 9, 8)),
    Transaction(id: 4, description: 'Aluguel', amount: 1200, type: TransactionType.expense, categoryId: 3, date: DateTime(2026, 9, 10)),
    Transaction(id: 5, description: 'Cinema', amount: 60, type: TransactionType.expense, categoryId: 4, date: DateTime(2026, 9, 12)),
    Transaction(id: 6, description: 'Projeto freelance', amount: 800, type: TransactionType.income, categoryId: 11, date: DateTime(2026, 9, 14)),
    Transaction(id: 7, description: 'Assinatura streaming', amount: 39.90, type: TransactionType.expense, categoryId: 8, date: DateTime(2026, 9, 15)),
    Transaction(id: 8, description: 'Farmácia', amount: 78.30, type: TransactionType.expense, categoryId: 6, date: DateTime(2026, 9, 16)),
    Transaction(id: 9, description: 'Dividendos', amount: 150, type: TransactionType.income, categoryId: 12, date: DateTime(2026, 9, 17)),
    Transaction(id: 10, description: 'Livro técnico', amount: 89.90, type: TransactionType.expense, categoryId: 7, date: DateTime(2026, 9, 18)),
  ]..sort((a, b) => b.date.compareTo(a.date));

  final _controller = StreamController<List<Transaction>>.broadcast();
  int _nextId = 11;

  @override
  Stream<List<Transaction>> watchAll() async* {
    yield List.unmodifiable(_items);
    yield* _controller.stream;
  }

  void _emit() {
    _items.sort((a, b) => b.date.compareTo(a.date));
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Future<void> add({
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
  }) async {
    _items.add(Transaction(
      id: _nextId++,
      description: description,
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      note: note,
    ));
    _emit();
  }

  @override
  Future<void> update(Transaction transaction) async {
    final index = _items.indexWhere((t) => t.id == transaction.id);
    if (index != -1) _items[index] = transaction;
    _emit();
  }

  @override
  Future<void> remove(int id) async {
    _items.removeWhere((t) => t.id == id);
    _emit();
  }
}

class FakeGoalsRepository implements GoalsRepository {
  final List<Goal> _items = [
    const Goal(id: 1, name: 'Viagem para o Nordeste', targetAmount: 5000, currentAmount: 1800),
    const Goal(id: 2, name: 'Reserva de emergência', targetAmount: 10000, currentAmount: 6200),
    const Goal(id: 3, name: 'Notebook novo', targetAmount: 4500, currentAmount: 4500),
  ];

  final _controller = StreamController<List<Goal>>.broadcast();
  int _nextId = 4;

  @override
  Stream<List<Goal>> watchAll() async* {
    yield List.unmodifiable(_items);
    yield* _controller.stream;
  }

  void _emit() => _controller.add(List.unmodifiable(_items));

  @override
  Future<void> add({
    required String name,
    required double targetAmount,
    required double currentAmount,
    DateTime? deadline,
  }) async {
    _items.add(Goal(id: _nextId++, name: name, targetAmount: targetAmount, currentAmount: currentAmount, deadline: deadline));
    _emit();
  }

  @override
  Future<void> update(Goal goal) async {
    final index = _items.indexWhere((g) => g.id == goal.id);
    if (index != -1) _items[index] = goal;
    _emit();
  }

  @override
  Future<void> remove(int id) async {
    _items.removeWhere((g) => g.id == id);
    _emit();
  }
}
