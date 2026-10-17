import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../goals/providers/goals_provider.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../services/notification_service.dart';

part 'notifications_provider.g.dart';

const _remindersEnabledKey = 'reminders_enabled';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();

@Riverpod(keepAlive: true)
class RemindersEnabledNotifier extends _$RemindersEnabledNotifier {
  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(_remindersEnabledKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(_remindersEnabledKey, value);
    await ref.read(reminderSchedulingProvider.future);
  }
}

/// Reagenda (ou cancela) os lembretes de vencimento de contas e de prazo de
/// metas. Roda uma vez por sessão — como `recurringGenerationProvider` — e
/// de novo sempre que o usuário alterna a preferência em Configurações.
@riverpod
Future<void> reminderScheduling(Ref ref) async {
  final enabled = ref.watch(remindersEnabledProvider);
  final service = ref.watch(notificationServiceProvider);

  await service.cancelAll();
  if (!enabled) return;

  final now = DateTime.now();
  final horizon = now.add(const Duration(days: 7));

  final transactions = await ref.watch(transactionsProvider.future);
  for (final t in transactions) {
    if (t.isPaid || t.dueDate == null) continue;
    if (t.dueDate!.isAfter(horizon)) continue;
    await service.scheduleReminder(
      id: notificationIdFor('txn-${t.id}'),
      title: 'Conta a pagar/receber',
      body: '${t.description} vence em ${_formatShort(t.dueDate!)}',
      date: DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day, 9),
    );
  }

  final goals = await ref.watch(goalsProvider.future);
  for (final g in goals) {
    final deadline = g.goal.deadline;
    if (deadline == null) continue;
    if (deadline.isBefore(now) || deadline.isAfter(horizon)) continue;
    await service.scheduleReminder(
      id: notificationIdFor('goal-${g.goal.id}'),
      title: 'Meta perto do prazo',
      body: '${g.goal.name} termina em ${_formatShort(deadline)}',
      date: DateTime(deadline.year, deadline.month, deadline.day, 9),
    );
  }
}

String _formatShort(DateTime date) => '${date.day}/${date.month}';
