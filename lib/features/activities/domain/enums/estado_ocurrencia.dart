enum EstadoOcurrencia {
  pendiente,
  completada,
  saltada,
  pospuesta,
}

extension EstadoOcurrenciaStorage on EstadoOcurrencia {
  String get storageValue => name;

  static EstadoOcurrencia fromStorage(String value) {
    return EstadoOcurrencia.values.firstWhere(
      (estado) => estado.name == value,
      orElse: () =>
          throw ArgumentError('Estado de ocurrencia no válido: $value'),
    );
  }
}
