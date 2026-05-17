import '../enums/estado_actividad.dart';
import '../enums/tipo_actividad.dart';

/// Entidad de dominio principal para actividades.
class Actividad {
  const Actividad({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.descripcion,
    required this.estado,
    this.urgente = false,
    this.fechaLimite,
    this.fechaInicio,
    this.fechaFin,
    this.fechaAviso,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final TipoActividad tipo;
  final String titulo;
  final String? descripcion;
  final EstadoActividad estado;
  final bool urgente;
  final DateTime? fechaLimite;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final DateTime? fechaAviso;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Actividad copyWith({
    String? id,
    TipoActividad? tipo,
    String? titulo,
    String? descripcion,
    EstadoActividad? estado,
    bool? urgente,
    DateTime? fechaLimite,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    DateTime? fechaAviso,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Actividad(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      urgente: urgente ?? this.urgente,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      fechaAviso: fechaAviso ?? this.fechaAviso,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
