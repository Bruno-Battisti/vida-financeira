import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required int id,
    required String name,
    required double targetAmount,
    DateTime? deadline,
  }) = _Goal;
}
