import '../entities/elemento_vista_temporal.dart';
import '../enums/estado_actividad.dart';
import 'elemento_vista_temporal_utils.dart';

bool tieneHoraEspecifica(DateTime fecha) {
  return fecha.hour != 0 ||
      fecha.minute != 0 ||
      fecha.second != 0 ||
      fecha.millisecond != 0;
}

bool elementoEstaCompletado(ElementoVistaTemporal elemento) {
  final ocurrencia = elemento.ocurrencia;
  if (ocurrencia != null) {
    return ocurrenciaEstaCompletada(ocurrencia);
  }
  return elemento.actividad.estado == EstadoActividad.completada;
}

/// Orden temporal: pendientes antes que completadas; con hora antes que solo fecha.
int compararElementosVistaTemporal(
  ElementoVistaTemporal a,
  ElementoVistaTemporal b, {
  bool descendente = false,
}) {
  final completadaA = elementoEstaCompletado(a);
  final completadaB = elementoEstaCompletado(b);
  if (completadaA != completadaB) {
    return completadaA ? 1 : -1;
  }

  final fa = fechaOrdenacionElemento(a);
  final fb = fechaOrdenacionElemento(b);
  if (fa == null && fb == null) {
    return a.actividad.titulo.compareTo(b.actividad.titulo);
  }
  if (fa == null) {
    return 1;
  }
  if (fb == null) {
    return -1;
  }

  final horaA = tieneHoraEspecifica(fa);
  final horaB = tieneHoraEspecifica(fb);
  if (horaA != horaB) {
    return horaA ? -1 : 1;
  }

  final cmp = fa.compareTo(fb);
  if (cmp != 0) {
    return descendente ? -cmp : cmp;
  }
  return a.actividad.titulo.compareTo(b.actividad.titulo);
}
