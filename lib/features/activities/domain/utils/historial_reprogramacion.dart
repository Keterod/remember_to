import '../entities/actividad.dart';
import '../entities/repeticion.dart';

bool fechasProgramacionCambiaron(Actividad anterior, Actividad actualizada) {
  return anterior.fechaLimite != actualizada.fechaLimite ||
      anterior.fechaAviso != actualizada.fechaAviso ||
      anterior.fechaInicio != actualizada.fechaInicio ||
      anterior.fechaFin != actualizada.fechaFin;
}

bool repeticionCambio(Repeticion anterior, Repeticion actualizada) {
  return anterior.tipo != actualizada.tipo ||
      anterior.intervalo != actualizada.intervalo ||
      anterior.diaMes != actualizada.diaMes ||
      anterior.fechaInicio != actualizada.fechaInicio ||
      anterior.fechaFin != actualizada.fechaFin ||
      !_listasIguales(anterior.diasSemana, actualizada.diasSemana);
}

bool _listasIguales(List<int>? a, List<int>? b) {
  final la = a ?? [];
  final lb = b ?? [];
  if (la.length != lb.length) {
    return false;
  }
  final sa = la.toSet();
  final sb = lb.toSet();
  return sa.length == sb.length && sa.containsAll(sb);
}
