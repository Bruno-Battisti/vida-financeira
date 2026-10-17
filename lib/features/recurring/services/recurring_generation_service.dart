import '../../transactions/repositories/transactions_repository.dart';
import '../models/recurring_rule.dart';
import '../repositories/recurring_rules_repository.dart';

/// Materializa, como transações normais, as ocorrências de regras
/// recorrentes que já venceram desde a última vez que o app foi aberto.
class RecurringGenerationService {
  RecurringGenerationService(this._rulesRepository, this._transactionsRepository);

  final RecurringRulesRepository _rulesRepository;
  final TransactionsRepository _transactionsRepository;

  /// Limite de segurança por regra, para não gerar um histórico infinito
  /// caso o app fique muito tempo sem ser aberto.
  static const _maxOccurrencesPerRule = 36;

  Future<void> generateDueTransactions() async {
    final rules = await _rulesRepository.watchAll().first;
    final now = DateTime.now();

    for (final rule in rules) {
      if (!rule.active) continue;

      var occurrence = rule.nextOccurrence;
      var generated = 0;
      while (!occurrence.isAfter(now) && generated < _maxOccurrencesPerRule) {
        await _transactionsRepository.add(
          description: rule.description,
          amount: rule.amount,
          type: rule.type,
          categoryId: rule.categoryId,
          date: occurrence,
          recurringRuleId: rule.id,
        );
        occurrence = nextOccurrenceAfter(occurrence, rule.frequency);
        generated++;
      }

      if (generated > 0) {
        await _rulesRepository.update(rule.copyWith(nextOccurrence: occurrence));
      }
    }
  }

  static DateTime nextOccurrenceAfter(DateTime date, RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.weekly:
        return date.add(const Duration(days: 7));
      case RecurrenceFrequency.monthly:
        return DateTime(date.year, date.month + 1, date.day);
      case RecurrenceFrequency.yearly:
        return DateTime(date.year + 1, date.month, date.day);
    }
  }
}
