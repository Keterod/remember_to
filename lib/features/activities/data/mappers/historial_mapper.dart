import 'package:drift/drift.dart';

import '../../domain/entities/historial_actividad.dart';
import '../../domain/enums/accion_historial.dart';
import '../local/database.dart';

class HistorialMapper {
  const HistorialMapper._();

  static HistorialActividad toDomain(HistorialActividadLocal row) {
    return HistorialActividad(
      id: row.id,
      actividadId: row.actividadId,
      ocurrenciaId: row.ocurrenciaId,
      accion: AccionHistorialStorage.fromStorage(row.accion),
      detalle: row.detalle,
      fechaHora: row.fechaHora,
    );
  }

  static HistorialActividadesCompanion toCompanion(HistorialActividad historial) {
    return HistorialActividadesCompanion.insert(
      id: historial.id,
      actividadId: Value(historial.actividadId),
      ocurrenciaId: Value(historial.ocurrenciaId),
      accion: historial.accion.storageValue,
      detalle: Value(historial.detalle),
      fechaHora: historial.fechaHora,
    );
  }
}
