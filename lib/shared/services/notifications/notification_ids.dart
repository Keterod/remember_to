/// Identificador estable para notificaciones locales a partir del id de actividad.
int notificationIdForActividad(String actividadId) {
  return actividadId.hashCode & 0x7FFFFFFF;
}
