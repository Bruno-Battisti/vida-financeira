import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../recurring/providers/recurring_rules_provider.dart';
import '../../recurring/services/recurring_generation_service.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transactions_provider.dart';
import 'dashboard_providers.dart';

part 'balance_projection_provider.g.dart';

const _monthsAhead = 3;

typedef BalanceProjectionPoint = ({DateTime month, double projectedBalance});

typedef BalanceProjection = ({
  double currentBalance,
  List<BalanceProjectionPoint> months,
});

typedef _Movement = ({DateTime date, double amount});

/// Saldo atual + tudo que já se sabe que vai acontecer nos próximos meses:
/// contas a pagar/receber pendentes (inclui parcelas futuras) e as próximas
/// ocorrências de regras recorrentes ainda não materializadas.
@riverpod
Future<BalanceProjection> balanceProjection(Ref ref) async {
  final summary = await ref.watch(dashboardSummaryProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final rules = await ref.watch(recurringRulesProvider.future);

  final now = DateTime.now();
  final monthEnds = List.generate(_monthsAhead, (i) {
    final nextMonthStart = DateTime(now.year, now.month + i + 1, 1);
    return nextMonthStart.subtract(const Duration(days: 1));
  });
  final horizonEnd = monthEnds.last;

  final pendingMovements = transactions.where((t) => !t.isPaid).map((t) {
    final effectiveDate = t.dueDate ?? t.date;
    final signedAmount = t.type == TransactionType.income ? t.amount : -t.amount;
    return (date: effectiveDate, amount: signedAmount);
  });

  final recurringMovements = <_Movement>[];
  for (final rule in rules) {
    if (!rule.active) continue;
    var occurrence = rule.nextOccurrence;
    var safety = 0;
    while (!occurrence.isAfter(horizonEnd) && safety < 60) {
      final signedAmount = rule.type == TransactionType.income ? rule.amount : -rule.amount;
      recurringMovements.add((date: occurrence, amount: signedAmount));
      occurrence = RecurringGenerationService.nextOccurrenceAfter(occurrence, rule.frequency);
      safety++;
    }
  }

  final movements = [...pendingMovements, ...recurringMovements];

  final months = monthEnds.map((end) {
    final total = movements
        .where((m) => !m.date.isAfter(end))
        .fold(0.0, (sum, m) => sum + m.amount);
    return (month: DateTime(end.year, end.month), projectedBalance: summary.saldo + total);
  }).toList();

  return (currentBalance: summary.saldo, months: months);
}
