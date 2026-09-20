import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/providers.dart';
import '../models/goal_progress.dart';
import '../models/goal_transaction.dart';
import '../repositories/goals_repository.dart';

part 'goals_provider.g.dart';

@riverpod
GoalsRepository goalsRepository(Ref ref) {
  return GoalsRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<GoalProgress>> goals(Ref ref) {
  return ref.watch(goalsRepositoryProvider).watchAllWithProgress();
}

@riverpod
Future<GoalProgress> goalById(Ref ref, int id) async {
  final goals = await ref.watch(goalsProvider.future);
  return goals.firstWhere((g) => g.goal.id == id);
}

@riverpod
Stream<List<GoalTransaction>> goalEntries(Ref ref, int goalId) {
  return ref.watch(goalsRepositoryProvider).watchEntries(goalId);
}
