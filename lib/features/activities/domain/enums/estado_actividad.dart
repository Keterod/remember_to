/// Estados base persistentes del MVP.
enum EstadoActividad {
  pendiente,
  completada,
}

extension EstadoActividadStorage on EstadoActividad {
  String get storageValue => name;

  static EstadoActividad fromStorage(String value) {
    return EstadoActividad.values.firstWhere(
      (estado) => estado.name == value,
      orElse: () => throw ArgumentError('Estado de actividad no válido: $value'),
    );
  }
}
