import 'package:drift/drift.dart';

import '../../../database/database.dart';
import '../models/goal.dart';

class GoalsRepository {
  GoalsRepository(this._db);

  final AppDatabase _db;

  Stream<List<Goal>> watchAll() {
    return _db.select(_db.goals).watch().map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  Future<void> add({
    required String name,
    required double targetAmount,
    required double currentAmount,
    DateTime? deadline,
  }) {
    return _db.into(_db.goals).insert(
          GoalsCompanion.insert(
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: Value(deadline),
          ),
        );
  }

  Future<void> update(Goal goal) {
    return (_db.update(_db.goals)..where((g) => g.id.equals(goal.id))).write(_toCompanion(goal));
  }

  Future<void> remove(int id) {
    return (_db.delete(_db.goals)..where((g) => g.id.equals(id))).go();
  }

  Goal _toDomain(GoalRow row) {
    return Goal(
      id: row.id,
      name: row.name,
      targetAmount: row.targetAmount,
      currentAmount: row.currentAmount,
      deadline: row.deadline,
    );
  }

  GoalsCompanion _toCompanion(Goal goal) {
    return GoalsCompanion(
      name: Value(goal.name),
      targetAmount: Value(goal.targetAmount),
      currentAmount: Value(goal.currentAmount),
      deadline: Value(goal.deadline),
    );
  }
}
