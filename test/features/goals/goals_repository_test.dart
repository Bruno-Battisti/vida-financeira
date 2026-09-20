import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/database/database.dart';
import 'package:vida_financeira/features/goals/repositories/goals_repository.dart';

void main() {
  late AppDatabase db;
  late GoalsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = GoalsRepository(db);
  });

  tearDown(() => db.close());

  test('watchAllWithProgress() começa com as metas fictícias', () async {
    final goals = await repository.watchAllWithProgress().first;
    expect(goals, isNotEmpty);
  });

  test('currentAmount é a soma dos aportes/retiradas da meta', () async {
    final goals = await repository.watchAllWithProgress().first;
    final notebook = goals.firstWhere((g) => g.goal.name == 'Notebook novo');

    // seed: um único aporte de 4500, meta de 4500 -> 100% completa
    expect(notebook.currentAmount, 4500);
    expect(notebook.progress, 1);
  });

  test('addContribution() soma ao currentAmount e addContribution negativo retira', () async {
    final before = (await repository.watchAllWithProgress().first).first;

    await repository.addContribution(goalId: before.goal.id, amount: 100);
    final afterAporte = (await repository.watchAllWithProgress().first).firstWhere((g) => g.goal.id == before.goal.id);
    expect(afterAporte.currentAmount, before.currentAmount + 100);

    await repository.addContribution(goalId: before.goal.id, amount: -50);
    final afterRetirada = (await repository.watchAllWithProgress().first).firstWhere((g) => g.goal.id == before.goal.id);
    expect(afterRetirada.currentAmount, before.currentAmount + 50);
  });

  test('watchEntries() lista o histórico de uma meta, mais recente primeiro', () async {
    final goal = (await repository.watchAllWithProgress().first).first;

    await repository.addContribution(goalId: goal.goal.id, amount: 10, date: DateTime(2026, 1, 1));
    await repository.addContribution(goalId: goal.goal.id, amount: 20, date: DateTime(2026, 6, 1));

    final entries = await repository.watchEntries(goal.goal.id).first;
    expect(entries.length, greaterThanOrEqualTo(2));
    expect(entries.first.date.isAfter(entries.last.date), isTrue);
  });

  test('addGoal() cria uma meta nova com currentAmount zero', () async {
    await repository.addGoal(name: 'Meta nova', targetAmount: 1000);

    final goals = await repository.watchAllWithProgress().first;
    final created = goals.firstWhere((g) => g.goal.name == 'Meta nova');
    expect(created.currentAmount, 0);
    expect(created.progress, 0);
  });

  test('updateGoal() altera nome e valor objetivo', () async {
    final original = (await repository.watchAllWithProgress().first).first;

    await repository.updateGoal(original.goal.copyWith(name: 'Renomeada', targetAmount: 999));

    final updated = (await repository.watchAllWithProgress().first).firstWhere((g) => g.goal.id == original.goal.id);
    expect(updated.goal.name, 'Renomeada');
    expect(updated.goal.targetAmount, 999);
  });

  test('removeGoal() apaga a meta e seu histórico de aportes', () async {
    final target = (await repository.watchAllWithProgress().first).first;

    await repository.removeGoal(target.goal.id);

    final goals = await repository.watchAllWithProgress().first;
    expect(goals.any((g) => g.goal.id == target.goal.id), isFalse);

    final entries = await repository.watchEntries(target.goal.id).first;
    expect(entries, isEmpty);
  });
}
