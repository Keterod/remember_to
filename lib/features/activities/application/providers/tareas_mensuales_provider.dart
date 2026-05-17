import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/entities/repeticion.dart';
import 'actividad_repository_provider.dart';
import 'invalidar_vistas_temporales.dart';

class TareaMensualConRepeticion {
  const TareaMensualConRepeticion({
    required this.tareaMensual,
    required this.repeticion,
  });

  final Actividad tareaMensual;
  final Repeticion repeticion;
}

final tareasMensualesProvider = AsyncNotifierProvider<TareasMensualesNotifier,
    List<TareaMensualConRepeticion>>(TareasMensualesNotifier.new);

class TareasMensualesNotifier
    extends AsyncNotifier<List<TareaMensualConRepeticion>> {
  @override
  Future<List<TareaMensualConRepeticion>> build() async {
    return _cargar();
  }

  Future<List<TareaMensualConRepeticion>> _cargar() async {
    final repository = ref.read(actividadRepositoryProvider);
    final tareas = await repository.listarTareasMensualesActivas();
    final resultado = <TareaMensualConRepeticion>[];
    for (final tarea in tareas) {
      final repeticion =
          await repository.obtenerRepeticionPorActividadId(tarea.id);
      if (repeticion != null) {
        resultado.add(
          TareaMensualConRepeticion(tareaMensual: tarea, repeticion: repeticion),
        );
      }
    }
    return resultado;
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_cargar);
  }

  Future<void> crearTareaMensual({
    required String titulo,
    String? descripcion,
    required int diaMes,
    bool urgente = false,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.crearTareaMensual(
      titulo: titulo,
      descripcion: descripcion,
      diaMes: diaMes,
      urgente: urgente,
    );
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> editarTareaMensual({
    required Actividad tareaMensual,
    required int diaMes,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.editarTareaMensual(
      tareaMensual: tareaMensual,
      diaMes: diaMes,
    );
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> eliminarLogicamente(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.eliminarTareaMensualLogicamente(id);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> marcarOcurrenciaMesCompletada(String actividadId) async {
    final repository = ref.read(actividadRepositoryProvider);
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: actividadId,
      dia: DateTime.now(),
    );
    await repository.marcarOcurrenciaCompletada(ocurrencia.id);
    invalidarVistasTemporales(ref);
  }

  Future<void> marcarOcurrenciaMesPendiente(String actividadId) async {
    final repository = ref.read(actividadRepositoryProvider);
    final ocurrencia = await repository.obtenerOcurrenciaParaDia(
      actividadId: actividadId,
      dia: DateTime.now(),
    );
    if (ocurrencia != null) {
      await repository.marcarOcurrenciaPendiente(ocurrencia.id);
    }
    invalidarVistasTemporales(ref);
  }
}
