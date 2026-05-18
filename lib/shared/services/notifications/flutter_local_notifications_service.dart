import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../features/activities/domain/enums/tipo_actividad.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'local_notifications_service.dart';
import 'notification_action_handler.dart';
import 'notification_action_ids.dart';
import 'notification_constants.dart';
import 'notification_ids.dart';
import 'notification_payload.dart';
import 'notification_schedule_result.dart';
import 'notification_slot.dart';

/// Notificaciones locales con [flutter_local_notifications] (Sprint 3–7).
class FlutterLocalNotificationsService implements LocalNotificationsService {
  FlutterLocalNotificationsService();

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

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onForegroundNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    await _androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationConstants.channelId,
        'Recordatorios',
        description: 'Avisos de actividades de Remember To.App',
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

  static tz.TZDateTime _toLocalTzDateTime(DateTime fecha) {
    return tz.TZDateTime(
      tz.local,
      fecha.year,
      fecha.month,
      fecha.day,
      fecha.hour,
      fecha.minute,
      fecha.second,
      fecha.millisecond,
      fecha.microsecond,
    );
  }

  List<AndroidNotificationAction>? _androidActions(
    bool includeActions,
    TipoActividad tipo,
  ) {
    if (!includeActions) {
      return null;
    }
    final completarLabel =
        tipo == TipoActividad.recordatorio ? 'Listo' : 'Completar';

    return [
      AndroidNotificationAction(
        NotificationActionIds.completar,
        completarLabel,
        showsUserInterface: false,
        cancelNotification: true,
      ),
      const AndroidNotificationAction(
        NotificationActionIds.posponer10,
        '+10 min',
        showsUserInterface: false,
        cancelNotification: true,
      ),
      const AndroidNotificationAction(
        NotificationActionIds.posponer30,
        '+30 min',
        showsUserInterface: false,
        cancelNotification: true,
      ),
      const AndroidNotificationAction(
        NotificationActionIds.posponer60,
        '+1 h',
        showsUserInterface: false,
        cancelNotification: true,
      ),
    ];
  }

  @override
  Future<ScheduleReminderResult> scheduleActivityNotification({
    required NotificationPayload payload,
    required String title,
    String? body,
    required DateTime scheduledDate,
    bool includeActions = true,
  }) async {
    await initialize();

    final ahora = DateTime.now();
    if (!scheduledDate.isAfter(ahora)) {
      return const ScheduleReminderResult(
        NotificationSchedulePrecision.inexact,
      );
    }

    final scheduled = _toLocalTzDateTime(scheduledDate);
    final notificationId = notificationIdForKey(
      actividadId: payload.actividadId,
      ocurrenciaId: payload.ocurrenciaId,
      slot: payload.slot,
      repeatAttempt: payload.repeatAttempt,
    );

    if (kDebugMode) {
      debugPrint(
        '[Notif] programar ${payload.actividadId} '
        'slot=${payload.slot.name} fecha=$scheduledDate',
      );
    }

    if (_androidPlugin != null && await canScheduleExactAlarms()) {
      try {
        await _zonedSchedule(
          notificationId: notificationId,
          title: title,
          body: body,
          scheduled: scheduled,
          payload: payload,
          mode: AndroidScheduleMode.exactAllowWhileIdle,
          includeActions: includeActions,
        );
        return const ScheduleReminderResult(
          NotificationSchedulePrecision.exact,
        );
      } catch (error, stackTrace) {
        if (kDebugMode) {
          debugPrint('[Notif] exact falló, fallback: $error');
          debugPrint('$stackTrace');
        }
      }
    }

    await _zonedSchedule(
      notificationId: notificationId,
      title: title,
      body: body,
      scheduled: scheduled,
      payload: payload,
      mode: AndroidScheduleMode.inexactAllowWhileIdle,
      includeActions: includeActions,
    );
    return const ScheduleReminderResult(
      NotificationSchedulePrecision.inexact,
    );
  }

  Future<void> _zonedSchedule({
    required int notificationId,
    required String title,
    required String? body,
    required tz.TZDateTime scheduled,
    required NotificationPayload payload,
    required AndroidScheduleMode mode,
    required bool includeActions,
  }) {
    return _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationConstants.channelId,
          'Recordatorios',
          channelDescription: 'Avisos de actividades de Remember To.App',
          importance: Importance.high,
          priority: Priority.high,
          actions: _androidActions(includeActions, payload.tipo),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload.toJsonString(),
    );
  }

  @override
  Future<void> cancelActivityNotifications({
    required String actividadId,
    String? ocurrenciaId,
  }) async {
    await initialize();
    for (final slot in NotificationSlot.values) {
      for (var i = 0; i <= NotificationConstants.maxRepeticiones; i++) {
        final id = notificationIdForKey(
          actividadId: actividadId,
          ocurrenciaId: ocurrenciaId,
          slot: slot,
          repeatAttempt: i,
        );
        await _plugin.cancel(id);
      }
    }
    await _plugin.cancel(notificationIdForActividad(actividadId));
  }

  @override
  Future<void> cancelReminderNotification(String actividadId) {
    return cancelActivityNotifications(actividadId: actividadId);
  }

  @override
  Future<ScheduleReminderResult> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  }) {
    return scheduleActivityNotification(
      payload: NotificationPayload(
        actividadId: actividadId,
        tipo: TipoActividad.recordatorio,
      ),
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );
  }
}
