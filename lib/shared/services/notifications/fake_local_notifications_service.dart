import '../../../features/activities/domain/enums/tipo_actividad.dart';
import 'local_notifications_service.dart';
import 'notification_payload.dart';
import 'notification_schedule_result.dart';
import 'notification_slot.dart';

/// Registro de una notificación programada en tests.
class ScheduledNotificationRecord {
  ScheduledNotificationRecord({
    required this.payload,
    required this.title,
    this.body,
    required this.scheduledDate,
    required this.precision,
    required this.includeActions,
  });

  final NotificationPayload payload;
  final String title;
  final String? body;
  final DateTime scheduledDate;
  final NotificationSchedulePrecision precision;
  final bool includeActions;
}

/// Implementación en memoria para tests (sin sistema operativo).
class FakeLocalNotificationsService implements LocalNotificationsService {
  bool initialized = false;
  bool permissionsGranted = true;
  bool exactAlarmsGranted = true;
  bool requestExactAlarmsThrows = false;

  final List<ScheduledNotificationRecord> scheduled = [];
  final List<String> cancelCalls = [];
  final List<NotificationSchedulePrecision> schedulePrecisionLog = [];

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<bool> requestPermissions() async => permissionsGranted;

  @override
  Future<bool> areNotificationsEnabled() async => permissionsGranted;

  @override
  Future<bool> canScheduleExactAlarms() async => exactAlarmsGranted;

  @override
  Future<bool> requestExactAlarmsPermission() async {
    if (requestExactAlarmsThrows) {
      return false;
    }
    exactAlarmsGranted = true;
    return true;
  }

  @override
  Future<ScheduleReminderResult> scheduleActivityNotification({
    required NotificationPayload payload,
    required String title,
    String? body,
    required DateTime scheduledDate,
    bool includeActions = true,
  }) async {
    final precision = exactAlarmsGranted
        ? NotificationSchedulePrecision.exact
        : NotificationSchedulePrecision.inexact;
    schedulePrecisionLog.add(precision);
    scheduled.add(
      ScheduledNotificationRecord(
        payload: payload,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        precision: precision,
        includeActions: includeActions,
      ),
    );
    return ScheduleReminderResult(precision);
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

  @override
  Future<void> cancelActivityNotifications({
    required String actividadId,
    String? ocurrenciaId,
  }) async {
    cancelCalls.add('$actividadId|${ocurrenciaId ?? ''}');
    scheduled.removeWhere(
      (item) =>
          item.payload.actividadId == actividadId &&
          (ocurrenciaId == null || item.payload.ocurrenciaId == ocurrenciaId),
    );
  }

  @override
  Future<void> cancelReminderNotification(String actividadId) async {
    await cancelActivityNotifications(actividadId: actividadId);
  }

  List<ScheduledNotificationRecord> findByActividadId(String actividadId) {
    return scheduled
        .where((item) => item.payload.actividadId == actividadId)
        .toList();
  }

  ScheduledNotificationRecord? findPrincipal(String actividadId) {
    try {
      return scheduled.firstWhere(
        (item) =>
            item.payload.actividadId == actividadId &&
            item.payload.slot == NotificationSlot.principal,
      );
    } catch (_) {
      return null;
    }
  }
}
