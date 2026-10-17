import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Lembretes locais de vencimento de contas e prazo de metas.
///
/// Sem suporte a web no plugin `flutter_local_notifications`, então toda
/// chamada pública aqui é um no-op em `kIsWeb` — o app continua funcionando
/// normalmente, só sem lembretes nessa plataforma.
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized || kIsWeb) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
      linux: LinuxInitializationSettings(defaultActionName: 'Abrir'),
    );

    await _plugin.initialize(settings);

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _ensureInitialized();
    await _plugin.cancelAll();
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    if (kIsWeb) return;
    await _ensureInitialized();

    final scheduled = tz.TZDateTime.from(date, tz.local);
    if (scheduled.isBefore(DateTime.now())) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders',
        'Lembretes',
        channelDescription: 'Vencimentos de contas e prazos de metas',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

/// Transforma um id de documento do Firestore num int estável para usar
/// como id de notificação (a API do plugin exige um int de 32 bits).
int notificationIdFor(String documentId) => documentId.hashCode & 0x7fffffff;
