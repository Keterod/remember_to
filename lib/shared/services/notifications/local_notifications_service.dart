import '../../../features/activities/domain/enums/tipo_actividad.dart';
import 'notification_payload.dart';
import 'notification_schedule_result.dart';

/// Contrato del servicio de notificaciones locales (Sprint 3–7).
abstract class LocalNotificationsService {
  /// Mensaje para orientar al usuario si no hay alarmas exactas.
  static const String exactAlarmGuidanceMessage =
      'Para recibir recordatorios con mayor precisión, activa el permiso de '
      'Alarmas y recordatorios en la configuración del sistema.';

  static const String actionsGuidanceMessage =
      'Puedes completar o posponer desde la notificación. '
      'Si Android no ejecuta la acción, hazlo desde la app.';

  Future<void> initialize();

  Future<bool> requestPermissions();

  Future<bool> areNotificationsEnabled();

  Future<bool> canScheduleExactAlarms();

  Future<bool> requestExactAlarmsPermission();

  Future<ScheduleReminderResult> scheduleActivityNotification({
    required NotificationPayload payload,
    required String title,
    String? body,
    required DateTime scheduledDate,
    bool includeActions = true,
  });

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

  Future<void> cancelActivityNotifications({
    required String actividadId,
    String? ocurrenciaId,
  });

  Future<void> cancelReminderNotification(String actividadId) {
    return cancelActivityNotifications(actividadId: actividadId);
  }
}
