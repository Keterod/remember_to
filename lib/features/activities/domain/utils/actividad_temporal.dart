import '../entities/actividad.dart';
import '../enums/tipo_actividad.dart';

/// Inicio del día civil para [fecha].
DateTime inicioDelDia(DateTime fecha) {
  return DateTime(fecha.year, fecha.month, fecha.day);
}

/// Fin del día civil para [fecha].
DateTime finDelDia(DateTime fecha) {
  return DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59, 999);
}

bool mismoDiaCivil(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Fecha/hora usada para ordenar en Próximas y Agenda.
DateTime? fechaOrdenacion(Actividad actividad) {
  switch (actividad.tipo) {
    case TipoActividad.tarea:
      return actividad.fechaLimite;
    case TipoActividad.recordatorio:
      return actividad.fechaAviso;
    case TipoActividad.evento:
      return actividad.fechaInicio;
    case TipoActividad.rutina:
    case TipoActividad.tareaMensual:
      return null;
  }
}

int compararPorFechaOrdenacion(Actividad a, Actividad b) {
  final fa = fechaOrdenacion(a);
  final fb = fechaOrdenacion(b);
  if (fa == null && fb == null) {
    return a.titulo.compareTo(b.titulo);
  }
  if (fa == null) {
    return 1;
  }
  if (fb == null) {
    return -1;
  }
  final cmp = fa.compareTo(fb);
  if (cmp != 0) {
    return cmp;
  }
  return a.titulo.compareTo(b.titulo);
}

/// Actividad programada para el día [dia] (tareas, recordatorios, eventos).
bool correspondeAlDia(Actividad actividad, DateTime dia) {
  switch (actividad.tipo) {
    case TipoActividad.tarea:
      final limite = actividad.fechaLimite;
      if (limite == null) {
        return false;
      }
      return mismoDiaCivil(limite, dia);
    case TipoActividad.recordatorio:
      final aviso = actividad.fechaAviso;
      if (aviso == null) {
        return false;
      }
      return mismoDiaCivil(aviso, dia);
    case TipoActividad.evento:
      final inicio = actividad.fechaInicio;
      final fin = actividad.fechaFin;
      if (inicio == null || fin == null) {
        return false;
      }
      final diaInicio = inicioDelDia(dia);
      final diaFin = finDelDia(dia);
      return !inicio.isAfter(diaFin) && !fin.isBefore(diaInicio);
    case TipoActividad.rutina:
    case TipoActividad.tareaMensual:
      return false;
  }
}

/// Actividad futura respecto a [referencia] (solo tipos del Sprint 4).
bool esActividadFutura(Actividad actividad, DateTime referencia) {
  final fecha = fechaOrdenacion(actividad);
  if (fecha == null) {
    return false;
  }
  return fecha.isAfter(referencia);
}

/// Actividad que intersecta el rango [inicio, fin] inclusive.
bool intersectaRango(
  Actividad actividad,
  DateTime inicio,
  DateTime fin,
) {
  switch (actividad.tipo) {
    case TipoActividad.tarea:
      final limite = actividad.fechaLimite;
      if (limite == null) {
        return false;
      }
      return !limite.isBefore(inicio) && !limite.isAfter(fin);
    case TipoActividad.recordatorio:
      final aviso = actividad.fechaAviso;
      if (aviso == null) {
        return false;
      }
      return !aviso.isBefore(inicio) && !aviso.isAfter(fin);
    case TipoActividad.evento:
      final eventoInicio = actividad.fechaInicio;
      final eventoFin = actividad.fechaFin;
      if (eventoInicio == null || eventoFin == null) {
        return false;
      }
      return !eventoInicio.isAfter(fin) && !eventoFin.isBefore(inicio);
    case TipoActividad.rutina:
    case TipoActividad.tareaMensual:
      return false;
  }
}
