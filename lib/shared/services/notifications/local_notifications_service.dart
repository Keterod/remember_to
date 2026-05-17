/// Contrato del servicio de notificaciones locales (Sprint 3).
abstract class LocalNotificationsService {
  Future<void> initialize();

  /// Solicita permiso de notificaciones (Android 13+). Devuelve si quedó concedido.
  Future<bool> requestPermissions();

  Future<bool> areNotificationsEnabled();

  /// Programa un aviso. No garantiza exactitud al 100 % en todos los dispositivos.
  Future<void> scheduleReminderNotification({
    required String actividadId,
    required String title,
    String? body,
    required DateTime scheduledDate,
  });

  Future<void> cancelReminderNotification(String actividadId);
}
