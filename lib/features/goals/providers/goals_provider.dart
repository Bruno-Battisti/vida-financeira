import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/goal_progress.dart';
import '../models/goal_transaction.dart';
import '../repositories/goals_repository.dart';

part 'goals_provider.g.dart';

@riverpod
GoalsRepository goalsRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) {
    throw StateError('goalsRepositoryProvider requer um usuário autenticado.');
  }
  return GoalsRepository(ref.watch(firestoreProvider), uid);
}

@riverpod
Stream<List<GoalProgress>> goals(Ref ref) {
  return ref.watch(goalsRepositoryProvider).watchAllWithProgress();
}

@riverpod
Future<GoalProgress> goalById(Ref ref, String id) async {
  final goals = await ref.watch(goalsProvider.future);
  return goals.firstWhere((g) => g.goal.id == id);
}

@riverpod
Stream<List<GoalTransaction>> goalEntries(Ref ref, String goalId) {
  return ref.watch(goalsRepositoryProvider).watchEntries(goalId);
}
