import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vida_financeira/core/providers/shared_preferences_provider.dart';
import 'package:vida_financeira/features/goals/providers/goals_provider.dart';
import 'package:vida_financeira/features/goals/repositories/goals_repository.dart';
import 'package:vida_financeira/features/notifications/providers/notifications_provider.dart';
import 'package:vida_financeira/features/notifications/services/notification_service.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';
import 'package:vida_financeira/features/transactions/repositories/transactions_repository.dart';

class _RecordedReminder {
  _RecordedReminder(this.title, this.date);
  final String title;
  final DateTime date;
}

/// Substitui o plugin de verdade por um registro em memória, já que
/// `flutter_local_notifications` fala com platform channels indisponíveis
/// em testes unitários.
class _FakeNotificationService extends NotificationService {
  final scheduled = <_RecordedReminder>[];
  int cancelCount = 0;

  @override
  Future<void> cancelAll() async {
    cancelCount++;
  }

  @override
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    scheduled.add(_RecordedReminder(title, date));
  }
}

void main() {
  late TransactionsRepository transactionsRepository;
  late GoalsRepository goalsRepository;
  late _FakeNotificationService notificationService;

  Future<ProviderContainer> buildContainer({required bool remindersEnabled}) async {
    SharedPreferences.setMockInitialValues({'reminders_enabled': remindersEnabled});
    final prefs = await SharedPreferences.getInstance();

    final firestore = FakeFirebaseFirestore();
    transactionsRepository = TransactionsRepository(firestore, 'user-1');
    goalsRepository = GoalsRepository(firestore, 'user-1');
    notificationService = _FakeNotificationService();

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
        goalsRepositoryProvider.overrideWithValue(goalsRepository),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('com lembretes desativados, só cancela notificações existentes', () async {
    final container = await buildContainer(remindersEnabled: false);

    await container.read(reminderSchedulingProvider.future);

    expect(notificationService.cancelCount, 1);
    expect(notificationService.scheduled, isEmpty);
  });

  test('agenda lembrete para conta pendente vencendo nos próximos 7 dias', () async {
    final container = await buildContainer(remindersEnabled: true);

    await transactionsRepository.add(
      description: 'Conta de luz',
      amount: 150,
      type: TransactionType.expense,
      categoryId: 3,
      date: DateTime.now(),
      isPaid: false,
      dueDate: DateTime.now().add(const Duration(days: 2)),
    );

    await container.read(reminderSchedulingProvider.future);

    expect(notificationService.scheduled, hasLength(1));
    expect(notificationService.scheduled.first.title, 'Conta a pagar/receber');
  });

  test('não agenda lembrete para conta pendente vencendo além de 7 dias', () async {
    final container = await buildContainer(remindersEnabled: true);

    await transactionsRepository.add(
      description: 'Conta distante',
      amount: 150,
      type: TransactionType.expense,
      categoryId: 3,
      date: DateTime.now(),
      isPaid: false,
      dueDate: DateTime.now().add(const Duration(days: 30)),
    );

    await container.read(reminderSchedulingProvider.future);

    expect(notificationService.scheduled, isEmpty);
  });

  test('não agenda lembrete para conta já paga', () async {
    final container = await buildContainer(remindersEnabled: true);

    await transactionsRepository.add(
      description: 'Conta paga',
      amount: 150,
      type: TransactionType.expense,
      categoryId: 3,
      date: DateTime.now(),
    );

    await container.read(reminderSchedulingProvider.future);

    expect(notificationService.scheduled, isEmpty);
  });

  test('agenda lembrete para meta com prazo nos próximos 7 dias', () async {
    final container = await buildContainer(remindersEnabled: true);

    await goalsRepository.addGoal(
      name: 'Viagem',
      targetAmount: 1000,
      deadline: DateTime.now().add(const Duration(days: 3)),
    );

    await container.read(reminderSchedulingProvider.future);

    expect(notificationService.scheduled, hasLength(1));
    expect(notificationService.scheduled.first.title, 'Meta perto do prazo');
  });
}
