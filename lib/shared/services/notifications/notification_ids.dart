import 'notification_slot.dart';

/// Identificador estable para notificaciones locales a partir del id de actividad.
int notificationIdForActividad(String actividadId) {
  return notificationIdForKey(
    actividadId: actividadId,
    slot: NotificationSlot.principal,
  );
}

/// Clave única por actividad, ocurrencia, tipo de aviso e intento de repetición.
int notificationIdForKey({
  required String actividadId,
  String? ocurrenciaId,
  NotificationSlot slot = NotificationSlot.principal,
  int repeatAttempt = 0,
}) {
  final key = '$actividadId|${ocurrenciaId ?? ''}|$slot.name|$repeatAttempt';
  return key.hashCode & 0x7FFFFFFF;
}
