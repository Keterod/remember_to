import 'package:drift/drift.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/enums/tipo_actividad.dart';
import '../local/database.dart';

class ActividadMapper {
  const ActividadMapper._();

  static Actividad toDomain(ActividadLocal row) {
    return Actividad(
      id: row.id,
      tipo: TipoActividadStorage.fromStorage(row.tipo),
      titulo: row.titulo,
      descripcion: row.descripcion,
      estado: EstadoActividadStorage.fromStorage(row.estado),
      urgente: row.urgente,
      fechaLimite: row.fechaLimite,
      fechaInicio: row.fechaInicio,
      fechaFin: row.fechaFin,
      fechaAviso: row.fechaAviso,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static ActividadesCompanion toCompanion(Actividad actividad) {
    return ActividadesCompanion.insert(
      id: actividad.id,
      tipo: actividad.tipo.storageValue,
      titulo: actividad.titulo,
      descripcion: Value(actividad.descripcion),
      estado: actividad.estado.storageValue,
      urgente: Value(actividad.urgente),
      fechaLimite: Value(actividad.fechaLimite),
      fechaInicio: Value(actividad.fechaInicio),
      fechaFin: Value(actividad.fechaFin),
      fechaAviso: Value(actividad.fechaAviso),
      createdAt: actividad.createdAt,
      updatedAt: actividad.updatedAt,
      deletedAt: Value(actividad.deletedAt),
    );
  }
}
