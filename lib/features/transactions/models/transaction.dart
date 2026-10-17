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
    /// Id compartilhado por todas as parcelas de uma mesma compra parcelada.
    String? installmentGroupId,
    /// Posição desta parcela (1-based) dentro do grupo de parcelamento.
    int? installmentIndex,
    /// Número total de parcelas do grupo de parcelamento.
    int? installmentTotal,
    /// Conta/carteira dona da transação. `null` em transações antigas,
    /// criadas antes de contas existirem — contam para a conta padrão.
    String? accountId,
  }) = _Transaction;
}
