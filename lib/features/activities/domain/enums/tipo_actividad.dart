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
