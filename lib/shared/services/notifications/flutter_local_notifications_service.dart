import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'local_notifications_service.dart';
import 'notification_ids.dart';
import 'notification_schedule_result.dart';

/// Notificaciones locales con [flutter_local_notifications].
///
/// Android (Sprint 3):
/// - Intenta [AndroidScheduleMode.exactAllowWhileIdle] si hay permiso
///   [SCHEDULE_EXACT_ALARM] / [canScheduleExactNotifications].
/// - Si falla o no hay permiso, usa [AndroidScheduleMode.inexactAllowWhileIdle].
/// - Android 13+ requiere [POST_NOTIFICATIONS] por separado.
/// - Tras reiniciar el dispositivo, los avisos no se reponen en este sprint.
class FlutterLocalNotificationsService implements LocalNotificationsService {
  FlutterLocalNotificationsService();

  static const _channelId = 'recordatorios';
  static const _channelName = 'Recordatorios';
  static const _channelDescription =
      'Avisos de recordatorios de Remember To.App';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

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

    await _androidPlugin?.createNotificationChannel(
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

    final androidPlugin = _androidPlugin;
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

    final androidPlugin = _androidPlugin;
    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? false;
    }

    return false;
  }

  @override
  Future<bool> canScheduleExactAlarms() async {
    final androidPlugin = _androidPlugin;
    if (androidPlugin == null) {
      return true;
    }
    return await androidPlugin.canScheduleExactNotifications() ?? false;
  }

  @override
  Future<bool> requestExactAlarmsPermission() async {
    final androidPlugin = _androidPlugin;
    if (androidPlugin == null) {
      return true;
    }
    return await androidPlugin.requestExactAlarmsPermission() ?? false;
  }

  static tz.TZDateTime _toLocalTzDateTime(DateTime fechaAviso) {
    return tz.TZDateTime(
      tz.local,
      fechaAviso.year,
      fechaAviso.month,
      fechaAviso.day,
      fechaAviso.hour,
      fechaAviso.minute,
      fechaAviso.second,
      fechaAviso.millisecond,
      fechaAviso.microsecond,
    );
  }

  @override
  Future<ScheduleReminderResult> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  }) async {
    await initialize();

    final ahora = DateTime.now();
    final scheduled = _toLocalTzDateTime(scheduledDate);
    final notificationId = notificationIdForActividad(actividadId);
    final delta = scheduledDate.difference(ahora);

    if (kDebugMode) {
      debugPrint(
        '[Notif] programar id=$actividadId notifId=$notificationId '
        'fechaAviso=$scheduledDate tz=$scheduled ahora=$ahora '
        'delta=${delta.inSeconds}s (${delta.inMinutes} min) '
        'tzLocal=${tz.local.name} '
        'exactPermitido=${await canScheduleExactAlarms()}',
      );
    }

    if (_androidPlugin != null && await canScheduleExactAlarms()) {
      try {
        await _zonedSchedule(
          notificationId: notificationId,
          title: title,
          body: body,
          scheduled: scheduled,
          mode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        if (kDebugMode) {
          debugPrint('[Notif] modo usado=exactAllowWhileIdle');
        }
        return const ScheduleReminderResult(
          NotificationSchedulePrecision.exact,
        );
      } catch (error, stackTrace) {
        if (kDebugMode) {
          debugPrint(
            '[Notif] exactAllowWhileIdle falló, fallback inexacto: $error',
          );
          debugPrint('$stackTrace');
        }
      }
    }

    await _zonedSchedule(
      notificationId: notificationId,
      title: title,
      body: body,
      scheduled: scheduled,
      mode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    if (kDebugMode) {
      debugPrint('[Notif] modo usado=inexactAllowWhileIdle');
    }
    return const ScheduleReminderResult(
      NotificationSchedulePrecision.inexact,
    );
  }

  Future<void> _zonedSchedule({
    required int notificationId,
    required String title,
    required String? body,
    required tz.TZDateTime scheduled,
    required AndroidScheduleMode mode,
  }) {
    return _plugin.zonedSchedule(
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
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelReminderNotification(String actividadId) async {
    final notificationId = notificationIdForActividad(actividadId);
    if (kDebugMode) {
      debugPrint('[Notif] cancelar id=$actividadId notifId=$notificationId');
    }
    await _plugin.cancel(notificationId);
  }
}
