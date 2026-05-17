import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'agenda_provider.dart';
import 'calendario_provider.dart';
import 'hoy_provider.dart';
import 'proximas_provider.dart';
import 'vencidas_provider.dart';

/// Refresca Hoy, Próximas, Vencidas, Calendario y Agenda tras cambios en actividades.
void invalidarVistasTemporales(Ref ref) {
  ref.invalidate(hoyProvider);
  ref.invalidate(proximasProvider);
  ref.invalidate(vencidasProvider);
  ref.invalidate(actividadesCalendarioProvider);
  ref.invalidate(agendaProvider);
}
