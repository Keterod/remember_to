import '../entities/elemento_vista_temporal.dart';
import '../entities/ocurrencia_actividad.dart';
import '../enums/estado_actividad.dart';
import '../enums/estado_ocurrencia.dart';
import '../enums/tipo_actividad.dart';
import 'actividad_temporal.dart';
import 'actividad_vencimiento.dart';
import 'ocurrencia_vencimiento.dart';

DateTime? fechaOrdenacionElemento(ElementoVistaTemporal elemento) {
  if (elemento.ocurrencia != null) {
    return fechaEfectivaOcurrencia(elemento.ocurrencia!);
  }
  return fechaOrdenacion(elemento.actividad);
}

bool elementoCorrespondeAlDia(ElementoVistaTemporal elemento, DateTime dia) {
  if (elemento.ocurrencia != null) {
    return mismoDiaCivil(fechaEfectivaOcurrencia(elemento.ocurrencia!), dia);
  }
  return correspondeAlDia(elemento.actividad, dia);
}

bool esElementoVencido(ElementoVistaTemporal elemento, DateTime referencia) {
  if (elemento.ocurrencia != null) {
    final tipo = elemento.actividad.tipo;
    if (tipo == TipoActividad.rutina || tipo == TipoActividad.tareaMensual) {
      return esOcurrenciaRecurrenteVencida(
        ocurrencia: elemento.ocurrencia,
        fechaProgramada: fechaEfectivaOcurrencia(elemento.ocurrencia!),
        referencia: referencia,
      );
    }
    return esOcurrenciaVencida(elemento.ocurrencia!, referencia);
  }
  return esActividadVencida(elemento.actividad, referencia);
}

bool esElementoFuturo(ElementoVistaTemporal elemento, DateTime referencia) {
  if (elemento.ocurrencia != null) {
    final oc = elemento.ocurrencia!;
    if (oc.estadoOcurrencia != EstadoOcurrencia.pendiente &&
        oc.estadoOcurrencia != EstadoOcurrencia.pospuesta) {
      return false;
    }
    return fechaEfectivaOcurrencia(oc).isAfter(referencia);
  }
  return elemento.actividad.estado == EstadoActividad.pendiente &&
      esActividadFutura(elemento.actividad, referencia);
}

bool elementoIntersectaRango(
  ElementoVistaTemporal elemento,
  DateTime inicio,
  DateTime fin,
) {
  if (elemento.ocurrencia != null) {
    final fecha = fechaEfectivaOcurrencia(elemento.ocurrencia!);
    return !fecha.isBefore(inicio) && !fecha.isAfter(fin);
  }
  return intersectaRango(elemento.actividad, inicio, fin);
}

bool ocurrenciaEstaCompletada(OcurrenciaActividad ocurrencia) {
  return ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada;
}
