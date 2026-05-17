import '../entities/actividad.dart';
import '../enums/estado_actividad.dart';
import '../enums/tipo_actividad.dart';

import 'tarea_vencimiento.dart';

/// Condición calculada de vencimiento (no es estado persistente).
bool esActividadVencida(Actividad actividad, DateTime referencia) {
  if (actividad.estado != EstadoActividad.pendiente) {
    return false;
  }

  switch (actividad.tipo) {
    case TipoActividad.tarea:
      return esTareaVencida(actividad, referencia);
    case TipoActividad.recordatorio:
      final fechaAviso = actividad.fechaAviso;
      if (fechaAviso == null) {
        return false;
      }
      return fechaAviso.isBefore(referencia);
    case TipoActividad.evento:
      final fechaFin = actividad.fechaFin;
      if (fechaFin == null) {
        return false;
      }
      return fechaFin.isBefore(referencia);
    case TipoActividad.rutina:
    case TipoActividad.tareaMensual:
      return false;
  }
}
