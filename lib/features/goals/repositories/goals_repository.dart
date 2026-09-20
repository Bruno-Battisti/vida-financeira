import 'package:drift/drift.dart';

import '../../../database/database.dart';
import '../models/goal.dart';
import '../models/goal_progress.dart';
import '../models/goal_transaction.dart';

class GoalsRepository {
  GoalsRepository(this._db);

  final AppDatabase _db;

  Stream<List<GoalProgress>> watchAllWithProgress() {
    final totalContributed = _db.goalEntries.amount.sum();

    final query = _db.selectOnly(_db.goals)
      ..addColumns([
        _db.goals.id,
        _db.goals.name,
        _db.goals.targetAmount,
        _db.goals.deadline,
        totalContributed,
      ])
      ..join([
        leftOuterJoin(_db.goalEntries, _db.goalEntries.goalId.equalsExp(_db.goals.id)),
      ])
      ..groupBy([_db.goals.id]);

    return query.watch().map((rows) {
      final items = rows.map((row) {
        final goal = Goal(
          id: row.read(_db.goals.id)!,
          name: row.read(_db.goals.name)!,
          targetAmount: row.read(_db.goals.targetAmount)!,
          deadline: row.read(_db.goals.deadline),
        );
        final currentAmount = row.read(totalContributed) ?? 0;
        return (
          goal: goal,
          currentAmount: currentAmount,
          progress: computeGoalProgress(currentAmount, goal.targetAmount),
        );
      }).toList();

      items.sort((a, b) => a.goal.id.compareTo(b.goal.id));
      return items;
    });
  }

  Stream<List<GoalTransaction>> watchEntries(int goalId) {
    final query = _db.select(_db.goalEntries)
      ..where((e) => e.goalId.equals(goalId))
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch().map((rows) => rows.map(_entryToDomain).toList());
  }

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    DateTime? deadline,
  }) {
    return _db.into(_db.goals).insert(
          GoalsCompanion.insert(
            name: name,
            targetAmount: targetAmount,
            deadline: Value(deadline),
          ),
        );
  }

  Future<void> updateGoal(Goal goal) {
    return (_db.update(_db.goals)..where((g) => g.id.equals(goal.id))).write(
      GoalsCompanion(
        name: Value(goal.name),
        targetAmount: Value(goal.targetAmount),
        deadline: Value(goal.deadline),
      ),
    );
  }

  Future<void> removeGoal(int id) {
    return _db.transaction(() async {
      await (_db.delete(_db.goalEntries)..where((e) => e.goalId.equals(id))).go();
      await (_db.delete(_db.goals)..where((g) => g.id.equals(id))).go();
    });
  }

  Future<void> addContribution({
    required int goalId,
    required double amount,
    DateTime? date,
  }) {
    return _db.into(_db.goalEntries).insert(
          GoalEntriesCompanion.insert(
            goalId: goalId,
            amount: amount,
            date: date ?? DateTime.now(),
          ),
        );
  }

  GoalTransaction _entryToDomain(GoalEntryRow row) {
    return GoalTransaction(id: row.id, goalId: row.goalId, amount: row.amount, date: row.date);
  }
}
