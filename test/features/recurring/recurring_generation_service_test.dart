import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/features/recurring/models/recurring_rule.dart';
import 'package:vida_financeira/features/recurring/repositories/recurring_rules_repository.dart';
import 'package:vida_financeira/features/recurring/services/recurring_generation_service.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late RecurringRulesRepository rulesRepository;
  late TransactionsRepository transactionsRepository;
  late RecurringGenerationService service;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    rulesRepository = RecurringRulesRepository(firestore, 'user-1');
    transactionsRepository = TransactionsRepository(firestore, 'user-1');
    service = RecurringGenerationService(rulesRepository, transactionsRepository);
  });

  test('gera as ocorrências mensais que já venceram e avança nextOccurrence', () async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 2, 5);

    await rulesRepository.add(
      description: 'Assinatura streaming',
      amount: 39.9,
      type: TransactionType.expense,
      categoryId: 8,
      frequency: RecurrenceFrequency.monthly,
      nextOccurrence: start,
    );

    await service.generateDueTransactions();

    final transactions = await transactionsRepository.watchAll().first;
    expect(transactions, hasLength(3));
    expect(transactions.every((t) => t.recurringRuleId != null), isTrue);

    final rule = (await rulesRepository.watchAll().first).first;
    expect(rule.nextOccurrence.isAfter(now), isTrue);
  });

  test('não gera nada para uma regra inativa', () async {
    await rulesRepository.add(
      description: 'Pausada',
      amount: 10,
      type: TransactionType.expense,
      categoryId: 1,
      frequency: RecurrenceFrequency.monthly,
      nextOccurrence: DateTime(2020, 1, 1),
    );
    final rule = (await rulesRepository.watchAll().first).first;
    await rulesRepository.update(rule.copyWith(active: false));

    await service.generateDueTransactions();

    final transactions = await transactionsRepository.watchAll().first;
    expect(transactions, isEmpty);
  });

  test('nextOccurrenceAfter soma 7 dias, 1 mês ou 1 ano conforme a frequência', () {
    final date = DateTime(2026, 1, 31);
    expect(
      RecurringGenerationService.nextOccurrenceAfter(date, RecurrenceFrequency.weekly),
      DateTime(2026, 2, 7),
    );
    expect(
      RecurringGenerationService.nextOccurrenceAfter(DateTime(2026, 1, 15), RecurrenceFrequency.monthly),
      DateTime(2026, 2, 15),
    );
    expect(
      RecurringGenerationService.nextOccurrenceAfter(DateTime(2026, 1, 15), RecurrenceFrequency.yearly),
      DateTime(2027, 1, 15),
    );
  });
}
