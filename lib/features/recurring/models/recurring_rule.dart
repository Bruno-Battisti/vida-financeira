import 'package:freezed_annotation/freezed_annotation.dart';

import '../../transactions/models/transaction.dart';

part 'recurring_rule.freezed.dart';

enum RecurrenceFrequency { weekly, monthly, yearly }

@freezed
abstract class RecurringRule with _$RecurringRule {
  const factory RecurringRule({
    required String id,
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required RecurrenceFrequency frequency,
    required DateTime nextOccurrence,
    @Default(true) bool active,
  }) = _RecurringRule;
}
