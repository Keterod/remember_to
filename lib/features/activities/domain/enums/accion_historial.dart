/// Acciones registradas en [HistorialActividad] (Sprint 6).
enum AccionHistorial {
  creada,
  editada,
  completada,
  marcadaPendiente,
  eliminada,
  reprogramada,
  ocurrenciaCompletada,
  ocurrenciaPendiente,
}

extension AccionHistorialStorage on AccionHistorial {
  String get storageValue {
    switch (this) {
      case AccionHistorial.creada:
        return 'creada';
      case AccionHistorial.editada:
        return 'editada';
      case AccionHistorial.completada:
        return 'completada';
      case AccionHistorial.marcadaPendiente:
        return 'marcadaPendiente';
      case AccionHistorial.eliminada:
        return 'eliminada';
      case AccionHistorial.reprogramada:
        return 'reprogramada';
      case AccionHistorial.ocurrenciaCompletada:
        return 'ocurrenciaCompletada';
      case AccionHistorial.ocurrenciaPendiente:
        return 'ocurrenciaPendiente';
    }
  }

  static AccionHistorial fromStorage(String value) {
    return AccionHistorial.values.firstWhere(
      (a) => a.storageValue == value,
      orElse: () => AccionHistorial.editada,
    );
  }

  String get etiqueta {
    switch (this) {
      case AccionHistorial.creada:
        return 'Creada';
      case AccionHistorial.editada:
        return 'Editada';
      case AccionHistorial.completada:
        return 'Completada';
      case AccionHistorial.marcadaPendiente:
        return 'Marcada pendiente';
      case AccionHistorial.eliminada:
        return 'Eliminada';
      case AccionHistorial.reprogramada:
        return 'Reprogramada';
      case AccionHistorial.ocurrenciaCompletada:
        return 'Ocurrencia completada';
      case AccionHistorial.ocurrenciaPendiente:
        return 'Ocurrencia pendiente';
    }
  }
}
