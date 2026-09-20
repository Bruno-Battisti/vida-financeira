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

  test('watchAll() começa com as metas fictícias', () async {
    final goals = await repository.watchAll().first;
    expect(goals, isNotEmpty);
  });

  test('add() insere uma nova meta', () async {
    final before = await repository.watchAll().first;

    await repository.add(name: 'Teste', targetAmount: 100, currentAmount: 0);

    final after = await repository.watchAll().first;
    expect(after.length, before.length + 1);
  });

  test('update() altera os campos de uma meta existente', () async {
    final original = (await repository.watchAll().first).first;

    await repository.update(original.copyWith(name: 'Renomeada'));

    final updated = (await repository.watchAll().first).firstWhere((g) => g.id == original.id);
    expect(updated.name, 'Renomeada');
  });

  test('remove() apaga a meta da lista', () async {
    final target = (await repository.watchAll().first).first;

    await repository.remove(target.id);

    final after = await repository.watchAll().first;
    expect(after.any((g) => g.id == target.id), isFalse);
  });

  test('progress fica limitado entre 0 e 1', () async {
    await repository.remove((await repository.watchAll().first).first.id);
    await repository.add(name: 'Meta cheia', targetAmount: 100, currentAmount: 250);
    await repository.add(name: 'Meta negativa', targetAmount: 100, currentAmount: -10);

    final goals = await repository.watchAll().first;
    expect(goals.firstWhere((g) => g.name == 'Meta cheia').progress, 1);
    expect(goals.firstWhere((g) => g.name == 'Meta negativa').progress, 0);
  });
}
