import '../enums/accion_historial.dart';

class HistorialActividad {
  const HistorialActividad({
    required this.id,
    this.actividadId,
    this.ocurrenciaId,
    required this.accion,
    this.detalle,
    required this.fechaHora,
  });

  final String id;
  final String? actividadId;
  final String? ocurrenciaId;
  final AccionHistorial accion;
  final String? detalle;
  final DateTime fechaHora;
}
