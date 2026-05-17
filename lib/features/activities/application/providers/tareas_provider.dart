import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import 'actividad_repository_provider.dart';

final tareasProvider =
    AsyncNotifierProvider<TareasNotifier, List<Actividad>>(TareasNotifier.new);

class TareasNotifier extends AsyncNotifier<List<Actividad>> {
  @override
  Future<List<Actividad>> build() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarTareasActivas();
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(actividadRepositoryProvider);
      return repository.listarTareasActivas();
    });
  }

  Future<void> crearTarea({
    required String titulo,
    String? descripcion,
    DateTime? fechaLimite,
    bool urgente = false,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.crearTarea(
      titulo: titulo,
      descripcion: descripcion,
      fechaLimite: fechaLimite,
      urgente: urgente,
    );
    await recargar();
  }

  Future<void> editarTarea(Actividad tarea) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.editarTarea(tarea);
    await recargar();
  }

  Future<void> marcarCompletada(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.marcarCompletada(id);
    await recargar();
  }

  Future<void> marcarPendiente(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.marcarPendiente(id);
    await recargar();
  }

  Future<void> eliminarLogicamente(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.eliminarLogicamente(id);
    await recargar();
  }
}
