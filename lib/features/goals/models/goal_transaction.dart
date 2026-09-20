import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_transaction.freezed.dart';

/// Um aporte (valor positivo) ou retirada (valor negativo) numa meta.
@freezed
abstract class GoalTransaction with _$GoalTransaction {
  const factory GoalTransaction({
    required int id,
    required int goalId,
    required double amount,
    required DateTime date,
  }) = _GoalTransaction;
}
