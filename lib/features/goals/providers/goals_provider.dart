import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/providers.dart';
import '../models/goal.dart';
import '../repositories/goals_repository.dart';

part 'goals_provider.g.dart';

@riverpod
GoalsRepository goalsRepository(Ref ref) {
  return GoalsRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<Goal>> goals(Ref ref) {
  return ref.watch(goalsRepositoryProvider).watchAll();
}

@riverpod
Future<Goal> goalById(Ref ref, int id) async {
  final goals = await ref.watch(goalsProvider.future);
  return goals.firstWhere((g) => g.id == id);
}
