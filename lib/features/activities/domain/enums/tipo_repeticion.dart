enum TipoRepeticion {
  diaria,
  semanal,
  mensual,
  anual,
  personalizada,
}

extension TipoRepeticionStorage on TipoRepeticion {
  String get storageValue => name;

  static TipoRepeticion fromStorage(String value) {
    return TipoRepeticion.values.firstWhere(
      (tipo) => tipo.name == value,
      orElse: () =>
          throw ArgumentError('Tipo de repetición no válido: $value'),
    );
  }
}
