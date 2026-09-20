import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/goals/repositories/goals_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late GoalsRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = GoalsRepository(firestore, 'user-1');
  });

  test('watchAllWithProgress() começa vazio para um usuário novo', () async {
    final goals = await repository.watchAllWithProgress().first;
    expect(goals, isEmpty);
  });

  test('addGoal() cria uma meta com currentAmount zero', () async {
    await repository.addGoal(name: 'Notebook novo', targetAmount: 4500);

    final goals = await repository.watchAllWithProgress().first;
    final created = goals.firstWhere((g) => g.goal.name == 'Notebook novo');
    expect(created.currentAmount, 0);
    expect(created.progress, 0);
  });

  test('currentAmount é a soma dos aportes/retiradas da meta', () async {
    await repository.addGoal(name: 'Viagem', targetAmount: 5000);
    final goal = (await repository.watchAllWithProgress().first).first;

    await repository.addContribution(goalId: goal.goal.id, amount: 1000);
    await repository.addContribution(goalId: goal.goal.id, amount: 500);
    await repository.addContribution(goalId: goal.goal.id, amount: -200);

    final updated = (await repository.watchAllWithProgress().first).first;
    expect(updated.currentAmount, 1300);
    expect(updated.progress, closeTo(0.26, 0.001));
  });

  test('watchEntries() lista o histórico de uma meta, mais recente primeiro', () async {
    await repository.addGoal(name: 'Meta', targetAmount: 100);
    final goal = (await repository.watchAllWithProgress().first).first;

    await repository.addContribution(goalId: goal.goal.id, amount: 10, date: DateTime(2026, 1, 1));
    await repository.addContribution(goalId: goal.goal.id, amount: 20, date: DateTime(2026, 6, 1));

    final entries = await repository.watchEntries(goal.goal.id).first;
    expect(entries, hasLength(2));
    expect(entries.first.date.isAfter(entries.last.date), isTrue);
  });

  test('updateGoal() altera nome e valor objetivo', () async {
    await repository.addGoal(name: 'Original', targetAmount: 100);
    final original = (await repository.watchAllWithProgress().first).first;

    await repository.updateGoal(original.goal.copyWith(name: 'Renomeada', targetAmount: 999));

    final updated = (await repository.watchAllWithProgress().first).first;
    expect(updated.goal.name, 'Renomeada');
    expect(updated.goal.targetAmount, 999);
  });

  test('removeGoal() apaga a meta e seu histórico de aportes', () async {
    await repository.addGoal(name: 'Para apagar', targetAmount: 100);
    final target = (await repository.watchAllWithProgress().first).first;
    await repository.addContribution(goalId: target.goal.id, amount: 10);

    await repository.removeGoal(target.goal.id);

    final goals = await repository.watchAllWithProgress().first;
    expect(goals, isEmpty);

    final entries = await repository.watchEntries(target.goal.id).first;
    expect(entries, isEmpty);
  });

  test('progress fica limitado entre 0 e 1', () async {
    await repository.addGoal(name: 'Meta cheia', targetAmount: 100);
    await repository.addGoal(name: 'Meta negativa', targetAmount: 100);
    final goals = await repository.watchAllWithProgress().first;

    await repository.addContribution(
      goalId: goals.firstWhere((g) => g.goal.name == 'Meta cheia').goal.id,
      amount: 250,
    );
    await repository.addContribution(
      goalId: goals.firstWhere((g) => g.goal.name == 'Meta negativa').goal.id,
      amount: -10,
    );

    final updated = await repository.watchAllWithProgress().first;
    expect(updated.firstWhere((g) => g.goal.name == 'Meta cheia').progress, 1);
    expect(updated.firstWhere((g) => g.goal.name == 'Meta negativa').progress, 0);
  });
}
