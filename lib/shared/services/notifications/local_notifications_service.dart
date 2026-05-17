import 'notification_schedule_result.dart';

/// Contrato del servicio de notificaciones locales (Sprint 3).
abstract class LocalNotificationsService {
  /// Mensaje para orientar al usuario si no hay alarmas exactas.
  static const String exactAlarmGuidanceMessage =
      'Para recibir recordatorios con mayor precisión, activa el permiso de '
      'Alarmas y recordatorios en la configuración del sistema.';

  Future<void> initialize();

  /// Solicita permiso de notificaciones (Android 13+). Devuelve si quedó concedido.
  Future<bool> requestPermissions();

  Future<bool> areNotificationsEnabled();

  /// Indica si el dispositivo Android puede programar alarmas exactas.
  ///
  /// En plataformas no Android devuelve true (sin restricción equivalente).
  Future<bool> canScheduleExactAlarms();

  /// Abre ajustes de alarmas exactas en Android cuando el plugin lo soporta.
  Future<bool> requestExactAlarmsPermission();

  /// Programa un aviso. Intenta modo exacto y hace fallback a inexacto si falla.
  Future<ScheduleReminderResult> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  });

  Future<void> cancelReminderNotification(String actividadId);
}
