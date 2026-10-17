import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

enum AccountType { checking, wallet, creditCard }

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    @Default(0) double initialBalance,
    /// A conta "Principal", criada automaticamente na primeira sessão —
    /// absorve transações antigas que não têm `accountId` e não pode ser
    /// excluída.
    @Default(false) bool isDefault,
    /// Dia do mês em que a fatura fecha (só relevante para cartão de
    /// crédito) — define o ciclo usado para agrupar compras em faturas.
    int? closingDay,
  }) = _Account;
}
