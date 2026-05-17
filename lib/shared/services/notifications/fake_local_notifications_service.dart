import 'local_notifications_service.dart';
import 'notification_ids.dart';
import 'notification_schedule_result.dart';

/// Registro de una notificación programada en tests.
class ScheduledNotificationRecord {
  ScheduledNotificationRecord({
    required this.actividadId,
    required this.title,
    this.body,
    required this.scheduledDate,
    required this.precision,
  });

  final String actividadId;
  final String title;
  final String? body;
  final DateTime scheduledDate;
  final NotificationSchedulePrecision precision;
}

/// Implementación en memoria para tests (sin sistema operativo).
class FakeLocalNotificationsService implements LocalNotificationsService {
  bool initialized = false;
  bool permissionsGranted = true;
  bool exactAlarmsGranted = true;
  bool requestExactAlarmsThrows = false;

  final List<ScheduledNotificationRecord> scheduled = [];
  final List<String> cancelCalls = [];
  final Map<String, int> notificationIdsByActividad = {};
  final List<NotificationSchedulePrecision> schedulePrecisionLog = [];

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    return permissionsGranted;
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    return permissionsGranted;
  }

  @override
  Future<bool> canScheduleExactAlarms() async {
    return exactAlarmsGranted;
  }

  @override
  Future<bool> requestExactAlarmsPermission() async {
    if (requestExactAlarmsThrows) {
      return false;
    }
    exactAlarmsGranted = true;
    return true;
  }

  @override
  Future<ScheduleReminderResult> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  }) async {
    await cancelReminderNotification(actividadId);

    final precision = exactAlarmsGranted
        ? NotificationSchedulePrecision.exact
        : NotificationSchedulePrecision.inexact;

    schedulePrecisionLog.add(precision);
    notificationIdsByActividad[actividadId] =
        notificationIdForActividad(actividadId);
    scheduled.add(
      ScheduledNotificationRecord(
        actividadId: actividadId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        precision: precision,
      ),
    );

    return ScheduleReminderResult(precision);
  }

  @override
  Future<void> cancelReminderNotification(String actividadId) async {
    cancelCalls.add(actividadId);
    scheduled.removeWhere((item) => item.actividadId == actividadId);
    notificationIdsByActividad.remove(actividadId);
  }

  ScheduledNotificationRecord? findByActividadId(String actividadId) {
    try {
      return scheduled.firstWhere((item) => item.actividadId == actividadId);
    } catch (_) {
      return null;
    }
  }
}
