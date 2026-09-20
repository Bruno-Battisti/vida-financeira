import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';

@freezed
abstract class Goal with _$Goal {
  const Goal._();

  const factory Goal({
    required int id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    DateTime? deadline,
  }) = _Goal;

  double get progress {
    if (targetAmount <= 0) return 0;
    final value = currentAmount / targetAmount;
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }
}
