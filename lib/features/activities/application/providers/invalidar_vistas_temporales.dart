import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'agenda_provider.dart';
import 'busqueda_provider.dart';
import 'calendario_provider.dart';
import 'historial_provider.dart';
import 'hoy_provider.dart';
import 'proximas_provider.dart';
import 'vencidas_provider.dart';

/// Refresca vistas temporales, historial y búsqueda tras cambios en actividades.
void invalidarVistasTemporales(Ref ref) {
  ref.invalidate(hoyProvider);
  ref.invalidate(proximasProvider);
  ref.invalidate(vencidasProvider);
  ref.invalidate(actividadesCalendarioProvider);
  ref.invalidate(agendaProvider);
  ref.invalidate(historialRecienteProvider);
  ref.invalidate(busquedaActividadesProvider);
}
