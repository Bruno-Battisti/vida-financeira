import 'goal.dart';

/// currentAmount é sempre a soma dos GoalTransaction da meta — nunca um
/// valor guardado separadamente, então não há como dessincronizar.
typedef GoalProgress = ({Goal goal, double currentAmount, double progress});

double computeGoalProgress(double currentAmount, double targetAmount) {
  if (targetAmount <= 0) return 0;
  final value = currentAmount / targetAmount;
  if (value < 0) return 0;
  if (value > 1) return 1;
  return value;
}
