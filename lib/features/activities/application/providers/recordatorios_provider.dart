import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/notifications/local_notifications_provider.dart';
import '../../../../shared/services/notifications/local_notifications_service.dart';
import '../../domain/entities/actividad.dart';
import 'actividad_repository_provider.dart';
import 'invalidar_vistas_temporales.dart';

final recordatoriosProvider = AsyncNotifierProvider<RecordatoriosNotifier,
    List<Actividad>>(RecordatoriosNotifier.new);

class RecordatoriosNotifier extends AsyncNotifier<List<Actividad>> {
  @override
  Future<List<Actividad>> build() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarRecordatoriosActivos();
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(actividadRepositoryProvider);
      return repository.listarRecordatoriosActivos();
    });
  }

  Future<bool> solicitarPermisosNotificacion() async {
    final service = ref.read(localNotificationsServiceProvider);
    final notificaciones = await service.requestPermissions();
    await service.requestExactAlarmsPermission();
    return notificaciones;
  }

  Future<bool> permisosNotificacionActivos() async {
    final service = ref.read(localNotificationsServiceProvider);
    return service.areNotificationsEnabled();
  }

  Future<bool> alarmasExactasDisponibles() async {
    final service = ref.read(localNotificationsServiceProvider);
    return service.canScheduleExactAlarms();
  }

  Future<bool> solicitarAlarmaExacta() async {
    final service = ref.read(localNotificationsServiceProvider);
    return service.requestExactAlarmsPermission();
  }

  Future<void> crearRecordatorio({
    required String titulo,
    String? descripcion,
    required DateTime fechaAviso,
    bool urgente = false,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.crearRecordatorio(
      titulo: titulo,
      descripcion: descripcion,
      fechaAviso: fechaAviso,
      urgente: urgente,
    );
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> editarRecordatorio(Actividad recordatorio) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.editarRecordatorio(recordatorio);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> eliminarRecordatorio(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.eliminarRecordatorioLogicamente(id);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  /// True si conviene mostrar [LocalNotificationsService.exactAlarmGuidanceMessage].
  Future<bool> debeMostrarGuiaAlarmaExacta() async {
    return !(await alarmasExactasDisponibles());
  }
}
