import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/budgets/repositories/budgets_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late BudgetsRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = BudgetsRepository(firestore, 'user-1');
  });

  test('watchAll() começa vazio para um usuário novo', () async {
    final budgets = await repository.watchAll().first;
    expect(budgets, isEmpty);
  });

  test('setLimit() cria um orçamento para a categoria', () async {
    await repository.setLimit(categoryId: 1, monthlyLimit: 500);

    final budgets = await repository.watchAll().first;
    expect(budgets, hasLength(1));
    expect(budgets.first.categoryId, 1);
    expect(budgets.first.monthlyLimit, 500);
  });

  test('setLimit() chamado de novo para a mesma categoria substitui o limite', () async {
    await repository.setLimit(categoryId: 1, monthlyLimit: 500);
    await repository.setLimit(categoryId: 1, monthlyLimit: 800);

    final budgets = await repository.watchAll().first;
    expect(budgets, hasLength(1));
    expect(budgets.first.monthlyLimit, 800);
  });

  test('removeLimit() apaga o orçamento da categoria', () async {
    await repository.setLimit(categoryId: 1, monthlyLimit: 500);

    await repository.removeLimit(1);

    final budgets = await repository.watchAll().first;
    expect(budgets, isEmpty);
  });

  test('cada usuário só vê os próprios orçamentos', () async {
    final otherUserRepo = BudgetsRepository(firestore, 'user-2');

    await repository.setLimit(categoryId: 1, monthlyLimit: 500);

    final user1Budgets = await repository.watchAll().first;
    final user2Budgets = await otherUserRepo.watchAll().first;

    expect(user1Budgets, hasLength(1));
    expect(user2Budgets, isEmpty);
  });
}
