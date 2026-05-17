import 'package:drift/drift.dart';

import '../../domain/entities/ocurrencia_actividad.dart';
import '../../domain/enums/estado_ocurrencia.dart';
import '../local/database.dart';

class OcurrenciaMapper {
  const OcurrenciaMapper._();

  static OcurrenciaActividad toDomain(OcurrenciaActividadLocal row) {
    return OcurrenciaActividad(
      id: row.id,
      actividadId: row.actividadId,
      fechaProgramada: row.fechaProgramada,
      estadoOcurrencia:
          EstadoOcurrenciaStorage.fromStorage(row.estadoOcurrencia),
      completedAt: row.completedAt,
      skippedAt: row.skippedAt,
      postponedTo: row.postponedTo,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static OcurrenciasActividadesCompanion toCompanion(
    OcurrenciaActividad ocurrencia,
  ) {
    return OcurrenciasActividadesCompanion.insert(
      id: ocurrencia.id,
      actividadId: ocurrencia.actividadId,
      fechaProgramada: ocurrencia.fechaProgramada,
      estadoOcurrencia: ocurrencia.estadoOcurrencia.storageValue,
      completedAt: Value(ocurrencia.completedAt),
      skippedAt: Value(ocurrencia.skippedAt),
      postponedTo: Value(ocurrencia.postponedTo),
      createdAt: ocurrencia.createdAt,
      updatedAt: ocurrencia.updatedAt,
    );
  }
}
