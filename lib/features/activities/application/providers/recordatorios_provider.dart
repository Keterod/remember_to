import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/notifications/local_notifications_provider.dart';
import '../../domain/entities/actividad.dart';
import 'actividad_repository_provider.dart';

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
    return service.requestPermissions();
  }

  Future<bool> permisosNotificacionActivos() async {
    final service = ref.read(localNotificationsServiceProvider);
    return service.areNotificationsEnabled();
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
  }

  Future<void> editarRecordatorio(Actividad recordatorio) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.editarRecordatorio(recordatorio);
    await recargar();
  }

  Future<void> eliminarRecordatorio(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.eliminarRecordatorioLogicamente(id);
    await recargar();
  }
}
