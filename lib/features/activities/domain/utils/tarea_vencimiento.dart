import '../entities/actividad.dart';
import '../enums/estado_actividad.dart';
import '../enums/tipo_actividad.dart';

/// Condición calculada de vencimiento para tareas (no es estado persistente).
bool esTareaVencida(Actividad actividad, DateTime referencia) {
  if (actividad.tipo != TipoActividad.tarea) {
    return false;
  }
  if (actividad.estado != EstadoActividad.pendiente) {
    return false;
  }
  final fechaLimite = actividad.fechaLimite;
  if (fechaLimite == null) {
    return false;
  }

  final diaReferencia = DateTime(
    referencia.year,
    referencia.month,
    referencia.day,
  );
  final diaLimite = DateTime(
    fechaLimite.year,
    fechaLimite.month,
    fechaLimite.day,
  );
  return diaLimite.isBefore(diaReferencia);
}
