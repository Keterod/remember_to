import 'package:drift/drift.dart';

import '../../domain/entities/repeticion.dart';
import '../../domain/enums/tipo_repeticion.dart';
import '../../domain/utils/repeticion_utils.dart';
import '../local/database.dart';

class RepeticionMapper {
  const RepeticionMapper._();

  static Repeticion toDomain(RepeticionLocal row) {
    return Repeticion(
      id: row.id,
      actividadId: row.actividadId,
      tipo: TipoRepeticionStorage.fromStorage(row.tipo),
      intervalo: row.intervalo,
      diasSemana: diasSemanaFromStorage(row.diasSemana),
      diaMes: row.diaMes,
      fechaInicio: row.fechaInicio,
      fechaFin: row.fechaFin,
      reglaTexto: row.reglaTexto,
    );
  }

  static RepeticionesCompanion toCompanion(Repeticion repeticion) {
    return RepeticionesCompanion.insert(
      id: repeticion.id,
      actividadId: repeticion.actividadId,
      tipo: repeticion.tipo.storageValue,
      intervalo: Value(repeticion.intervalo),
      diasSemana: Value(
        repeticion.diasSemana == null || repeticion.diasSemana!.isEmpty
            ? null
            : diasSemanaToStorage(repeticion.diasSemana!),
      ),
      diaMes: Value(repeticion.diaMes),
      fechaInicio: Value(repeticion.fechaInicio),
      fechaFin: Value(repeticion.fechaFin),
      reglaTexto: Value(repeticion.reglaTexto),
    );
  }
}
