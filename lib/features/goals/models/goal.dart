class Goal {
  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
  });

  final int id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;

  double get progress {
    if (targetAmount <= 0) return 0;
    final value = currentAmount / targetAmount;
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }
}
