import 'package:flutter/material.dart';

import '../../features/goals/models/goal.dart';
import '../../features/transactions/models/category.dart';
import '../../features/transactions/models/transaction.dart';

class MockData {
  MockData._();

  static const List<Category> categories = [
    Category(id: 1, name: 'Alimentação', icon: Icons.restaurant, type: CategoryType.expense),
    Category(id: 2, name: 'Transporte', icon: Icons.directions_car, type: CategoryType.expense),
    Category(id: 3, name: 'Moradia', icon: Icons.home, type: CategoryType.expense),
    Category(id: 4, name: 'Lazer', icon: Icons.sports_esports, type: CategoryType.expense),
    Category(id: 5, name: 'Compras', icon: Icons.shopping_bag, type: CategoryType.expense),
    Category(id: 6, name: 'Saúde', icon: Icons.local_hospital, type: CategoryType.expense),
    Category(id: 7, name: 'Educação', icon: Icons.school, type: CategoryType.expense),
    Category(id: 8, name: 'Assinaturas', icon: Icons.subscriptions, type: CategoryType.expense),
    Category(id: 9, name: 'Outros', icon: Icons.category, type: CategoryType.expense),
    Category(id: 10, name: 'Salário', icon: Icons.payments, type: CategoryType.income),
    Category(id: 11, name: 'Freelance', icon: Icons.laptop_mac, type: CategoryType.income),
    Category(id: 12, name: 'Investimentos', icon: Icons.trending_up, type: CategoryType.income),
    Category(id: 13, name: 'Outros', icon: Icons.category, type: CategoryType.income),
  ];

  static Category categoryById(int id) {
    return categories.firstWhere((category) => category.id == id);
  }

  static final List<Transaction> transactions = [
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

  static final List<Goal> goals = [
    Goal(id: 1, name: 'Viagem para o Nordeste', targetAmount: 5000, currentAmount: 1800, deadline: DateTime(2027, 1, 15)),
    Goal(id: 2, name: 'Reserva de emergência', targetAmount: 10000, currentAmount: 6200),
    Goal(id: 3, name: 'Notebook novo', targetAmount: 4500, currentAmount: 4500, deadline: DateTime(2026, 10, 1)),
  ];
}
