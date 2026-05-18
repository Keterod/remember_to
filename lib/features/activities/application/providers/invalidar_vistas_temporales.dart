import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/notifications/notification_action_executor.dart';
import 'agenda_provider.dart';
import 'busqueda_provider.dart';
import 'calendario_provider.dart';
import 'historial_provider.dart';
import 'hoy_provider.dart';
import 'proximas_provider.dart';
import 'recordatorios_provider.dart';
import 'vencidas_provider.dart';
import '../../../../shared/services/notifications/notification_refresh_signal.dart';

/// Refresca vistas temporales, historial y búsqueda tras cambios en actividades.
///
/// [incluirRecordatorios] debe ser false cuando se llama desde
/// [RecordatoriosNotifier] para no invalidar el provider activo.
void invalidarVistasTemporales(
  Ref ref, {
  bool incluirRecordatorios = true,
}) {
  ref.invalidate(hoyProvider);
  ref.invalidate(proximasProvider);
  ref.invalidate(vencidasProvider);
  ref.invalidate(actividadesCalendarioProvider);
  ref.invalidate(agendaProvider);
  ref.invalidate(historialRecienteProvider);
  ref.invalidate(busquedaActividadesProvider);
  if (incluirRecordatorios) {
    ref.invalidate(recordatoriosProvider);
  }
}

/// Invalida vistas temporales y la lista de recordatorios (p. ej. acciones de notificación).
void invalidarRecordatoriosYVistas(Ref ref) {
  invalidarVistasTemporales(ref, incluirRecordatorios: true);
}

/// Invalida providers tras una acción ejecutada desde notificación.
void invalidarVistasDesdeContenedor(ProviderContainer container) {
  container.invalidate(hoyProvider);
  container.invalidate(proximasProvider);
  container.invalidate(vencidasProvider);
  container.invalidate(actividadesCalendarioProvider);
  container.invalidate(agendaProvider);
  container.invalidate(historialRecienteProvider);
  container.invalidate(busquedaActividadesProvider);
  container.invalidate(recordatoriosProvider);
}

void configurarRefrescoTrasNotificacion(ProviderContainer container) {
  void refrescar() {
    invalidarVistasDesdeContenedor(container);
  }

  NotificationActionExecutor.onActionHandled = refrescar;
  registerNotificationRefreshListener(refrescar);
}
