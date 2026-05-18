/// Parámetros internos de notificaciones (Sprint 7).
abstract final class NotificationConstants {
  static const maxRepeticiones = 3;
  static const intervaloRepeticion = Duration(minutes: 10);

  static const anticipadoRecordatorio = Duration(minutes: 15);
  static const anticipadoEvento = Duration(minutes: 30);
  static const anticipadoTarea = Duration(hours: 1);

  static const mensajeLimitaciones =
      'Las notificaciones dependen de Android y pueden no ser exactas. '
      'Puedes completar o posponer desde la app si una acción no responde.';

  static const channelId = 'recordatorios';
}
