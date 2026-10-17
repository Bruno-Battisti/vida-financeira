import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { income, expense }

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String description,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required DateTime date,
    String? note,
    /// Data de vencimento de uma conta a pagar/receber ainda pendente.
    DateTime? dueDate,
    /// `false` representa uma conta a pagar/receber que ainda não foi
    /// liquidada — só entra nos totais e saldos quando marcada como paga.
    @Default(true) bool isPaid,
    /// Preenchido quando a transação foi gerada automaticamente a partir de
    /// uma regra de recorrência.
    String? recurringRuleId,
  }) = _Transaction;
}
