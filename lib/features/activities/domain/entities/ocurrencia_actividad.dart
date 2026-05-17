import '../enums/estado_ocurrencia.dart';

class OcurrenciaActividad {
  const OcurrenciaActividad({
    required this.id,
    required this.actividadId,
    required this.fechaProgramada,
    required this.estadoOcurrencia,
    this.completedAt,
    this.skippedAt,
    this.postponedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String actividadId;
  final DateTime fechaProgramada;
  final EstadoOcurrencia estadoOcurrencia;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final DateTime? postponedTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  OcurrenciaActividad copyWith({
    String? id,
    String? actividadId,
    DateTime? fechaProgramada,
    EstadoOcurrencia? estadoOcurrencia,
    DateTime? completedAt,
    DateTime? skippedAt,
    DateTime? postponedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OcurrenciaActividad(
      id: id ?? this.id,
      actividadId: actividadId ?? this.actividadId,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      estadoOcurrencia: estadoOcurrencia ?? this.estadoOcurrencia,
      completedAt: completedAt ?? this.completedAt,
      skippedAt: skippedAt ?? this.skippedAt,
      postponedTo: postponedTo ?? this.postponedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
