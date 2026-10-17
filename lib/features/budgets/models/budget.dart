import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required int categoryId,
    required double monthlyLimit,
  }) = _Budget;
}
