import '../entities/ocurrencia_actividad.dart';
import '../enums/estado_ocurrencia.dart';

import 'actividad_temporal.dart';

DateTime fechaEfectivaOcurrencia(OcurrenciaActividad ocurrencia) {
  return ocurrencia.postponedTo ?? ocurrencia.fechaProgramada;
}

bool esOcurrenciaVencida(OcurrenciaActividad ocurrencia, DateTime referencia) {
  if (ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada ||
      ocurrencia.estadoOcurrencia == EstadoOcurrencia.saltada) {
    return false;
  }
  return fechaEfectivaOcurrencia(ocurrencia).isBefore(referencia);
}

/// Rutinas y tareas mensuales: vencida solo después del día programado completo.
bool esOcurrenciaRecurrenteVencida({
  OcurrenciaActividad? ocurrencia,
  required DateTime fechaProgramada,
  required DateTime referencia,
}) {
  if (ocurrencia != null) {
    if (ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada ||
        ocurrencia.estadoOcurrencia == EstadoOcurrencia.saltada) {
      return false;
    }
  }
  final diaSiguienteAlProgramado =
      inicioDelDia(fechaProgramada).add(const Duration(days: 1));
  return !inicioDelDia(referencia).isBefore(diaSiguienteAlProgramado);
}

bool ocurrenciaVisibleEnVistas(OcurrenciaActividad ocurrencia) {
  return ocurrencia.estadoOcurrencia != EstadoOcurrencia.saltada;
}
