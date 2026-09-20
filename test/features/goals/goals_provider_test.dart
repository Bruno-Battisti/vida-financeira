import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/goals/models/goal.dart';
import 'package:vida_financeira/features/goals/providers/goals_provider.dart';

void main() {
  test('build() carrega as metas fictícias', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(goalsProvider), isNotEmpty);
  });

  test('add() insere uma nova meta', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(goalsProvider.notifier);
    final before = container.read(goalsProvider).length;

    notifier.add(const Goal(id: 999, name: 'Teste', targetAmount: 100, currentAmount: 0));

    expect(container.read(goalsProvider).length, before + 1);
  });

  test('goalByIdProvider retorna a meta correta e reage a updates', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final first = container.read(goalsProvider).first;
    final found = container.read(goalByIdProvider(first.id));
    expect(found.id, first.id);

    container.read(goalsProvider.notifier).update(first.copyWith(name: 'Renomeada'));

    final updated = container.read(goalByIdProvider(first.id));
    expect(updated.name, 'Renomeada');
  });

  test('progress fica limitado entre 0 e 1', () {
    const goal = Goal(id: 1, name: 'Meta', targetAmount: 100, currentAmount: 250);
    expect(goal.progress, 1);

    const negativeGoal = Goal(id: 2, name: 'Meta 2', targetAmount: 100, currentAmount: -10);
    expect(negativeGoal.progress, 0);
  });
}
