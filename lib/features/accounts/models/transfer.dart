import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer.freezed.dart';

@freezed
abstract class Transfer with _$Transfer {
  const factory Transfer({
    required String id,
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required DateTime date,
    String? note,
  }) = _Transfer;
}
