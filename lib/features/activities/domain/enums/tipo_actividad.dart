/// Tipos de actividad soportados en el MVP.
enum TipoActividad {
  tarea,
  recordatorio,
  evento,
  rutina,
  tareaMensual,
}

extension TipoActividadStorage on TipoActividad {
  String get storageValue => name;

  static TipoActividad fromStorage(String value) {
    return TipoActividad.values.firstWhere(
      (tipo) => tipo.name == value,
      orElse: () => throw ArgumentError('Tipo de actividad no válido: $value'),
    );
  }
}

/// Rutas de edición para navegación desde búsqueda y listas (Sprint 6).
extension TipoActividadNavegacion on TipoActividad {
  String? rutaEdicion(String actividadId) {
    switch (this) {
      case TipoActividad.tarea:
        return '/tareas/$actividadId/editar';
      case TipoActividad.recordatorio:
        return '/recordatorios/$actividadId/editar';
      case TipoActividad.evento:
        return '/eventos/$actividadId/editar';
      case TipoActividad.rutina:
        return '/rutinas/$actividadId/editar';
      case TipoActividad.tareaMensual:
        return '/tareas-mensuales/$actividadId/editar';
    }
  }
}
