import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import 'actividad_repository_provider.dart';
import 'invalidar_vistas_temporales.dart';

final eventosProvider =
    AsyncNotifierProvider<EventosNotifier, List<Actividad>>(EventosNotifier.new);

class EventosNotifier extends AsyncNotifier<List<Actividad>> {
  @override
  Future<List<Actividad>> build() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarEventosActivos();
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(actividadRepositoryProvider);
      return repository.listarEventosActivos();
    });
  }

  Future<void> crearEvento({
    required String titulo,
    String? descripcion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    bool urgente = false,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.crearEvento(
      titulo: titulo,
      descripcion: descripcion,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      urgente: urgente,
    );
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> editarEvento(Actividad evento) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.editarEvento(evento);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> marcarCompletada(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.marcarEventoCompletada(id);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> marcarPendiente(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.marcarEventoPendiente(id);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> eliminarLogicamente(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.eliminarEventoLogicamente(id);
    await recargar();
    invalidarVistasTemporales(ref);
  }
}
