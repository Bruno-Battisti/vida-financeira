import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { income, expense }

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
  }) = _Transaction;
}
