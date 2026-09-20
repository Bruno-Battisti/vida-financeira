import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_data.dart';
import '../models/goal.dart';

part 'goals_provider.g.dart';

@riverpod
class GoalsNotifier extends _$GoalsNotifier {
  @override
  List<Goal> build() {
    return [...MockData.goals];
  }

  void add(Goal goal) {
    state = [...state, goal];
  }

  void update(Goal goal) {
    state = [
      for (final g in state)
        if (g.id == goal.id) goal else g,
    ];
  }

  void remove(int id) {
    state = state.where((g) => g.id != id).toList();
  }
}

@riverpod
Goal goalById(Ref ref, int id) {
  final goals = ref.watch(goalsProvider);
  return goals.firstWhere((g) => g.id == id);
}
