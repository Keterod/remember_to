import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'local_notifications_service.dart';
import 'notification_ids.dart';

/// Notificaciones locales con [flutter_local_notifications].
///
/// Limitaciones (Android):
/// - Android 13+ requiere [POST_NOTIFICATIONS].
/// - El fabricante puede retrasar o agrupar avisos en segundo plano.
/// - Tras reiniciar el dispositivo, los avisos no se reponen en este sprint.
///
/// Nota técnica — [AndroidScheduleMode.inexactAllowWhileIdle] (Sprint 3):
/// - Se usa en Sprint 3 para no pedir permisos avanzados (p. ej. alarmas exactas).
/// - Android puede retrasar notificaciones inexactas ~40–60 s o más por ahorro de
///   batería, Doze o políticas del fabricante.
/// - En una versión futura se evaluará [AndroidScheduleMode.exactAllowWhileIdle]
///   con [SCHEDULE_EXACT_ALARM] y fallback a modo inexacto si no hay permiso.
class FlutterLocalNotificationsService implements LocalNotificationsService {
  FlutterLocalNotificationsService();

  static const _channelId = 'recordatorios';
  static const _channelName = 'Recordatorios';
  static const _channelDescription =
      'Avisos de recordatorios de Remember To.App';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    }

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    return false;
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    }

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? false;
    }

    return false;
  }

  @override
  Future<void> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  }) async {
    await initialize();

    final scheduled = tz.TZDateTime.from(scheduledDate, tz.local);
    final notificationId = notificationIdForActividad(actividadId);

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Ver nota técnica en la documentación de esta clase.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelReminderNotification(String actividadId) async {
    await _plugin.cancel(notificationIdForActividad(actividadId));
  }
}
