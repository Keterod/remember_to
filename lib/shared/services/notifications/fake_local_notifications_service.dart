import 'local_notifications_service.dart';

/// Registro de una notificación programada en tests.
class ScheduledNotificationRecord {
  ScheduledNotificationRecord({
    required this.actividadId,
    required this.title,
    this.body,
    required this.scheduledDate,
  });

  final String actividadId;
  final String title;
  final String? body;
  final DateTime scheduledDate;
}

/// Implementación en memoria para tests (sin sistema operativo).
class FakeLocalNotificationsService implements LocalNotificationsService {
  bool initialized = false;
  bool permissionsGranted = true;
  final List<ScheduledNotificationRecord> scheduled = [];

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
  Future<void> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  }) async {
    await cancelReminderNotification(actividadId);
    scheduled.add(
      ScheduledNotificationRecord(
        actividadId: actividadId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
      ),
    );
  }

  @override
  Future<void> cancelReminderNotification(String actividadId) async {
    scheduled.removeWhere((item) => item.actividadId == actividadId);
  }

  ScheduledNotificationRecord? findByActividadId(String actividadId) {
    try {
      return scheduled.firstWhere((item) => item.actividadId == actividadId);
    } catch (_) {
      return null;
    }
  }
}
