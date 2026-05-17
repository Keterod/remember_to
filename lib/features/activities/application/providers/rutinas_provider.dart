import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/entities/repeticion.dart';
import 'actividad_repository_provider.dart';
import 'invalidar_vistas_temporales.dart';

class RutinaConRepeticion {
  const RutinaConRepeticion({
    required this.rutina,
    required this.repeticion,
  });

  final Actividad rutina;
  final Repeticion repeticion;
}

final rutinasProvider =
    AsyncNotifierProvider<RutinasNotifier, List<RutinaConRepeticion>>(
  RutinasNotifier.new,
);

class RutinasNotifier extends AsyncNotifier<List<RutinaConRepeticion>> {
  @override
  Future<List<RutinaConRepeticion>> build() async {
    return _cargar();
  }

  Future<List<RutinaConRepeticion>> _cargar() async {
    final repository = ref.read(actividadRepositoryProvider);
    final rutinas = await repository.listarRutinasActivas();
    final resultado = <RutinaConRepeticion>[];
    for (final rutina in rutinas) {
      final repeticion =
          await repository.obtenerRepeticionPorActividadId(rutina.id);
      if (repeticion != null) {
        resultado.add(RutinaConRepeticion(rutina: rutina, repeticion: repeticion));
      }
    }
    return resultado;
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_cargar);
  }

  Future<void> crearRutina({
    required String titulo,
    String? descripcion,
    required List<int> diasSemana,
    bool todosLosDias = false,
    bool urgente = false,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.crearRutina(
      titulo: titulo,
      descripcion: descripcion,
      diasSemana: diasSemana,
      todosLosDias: todosLosDias,
      urgente: urgente,
    );
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> editarRutina({
    required Actividad rutina,
    required List<int> diasSemana,
    bool todosLosDias = false,
  }) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.editarRutina(
      rutina: rutina,
      diasSemana: diasSemana,
      todosLosDias: todosLosDias,
    );
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> eliminarLogicamente(String id) async {
    final repository = ref.read(actividadRepositoryProvider);
    await repository.eliminarRutinaLogicamente(id);
    await recargar();
    invalidarVistasTemporales(ref);
  }

  Future<void> marcarOcurrenciaHoyCompletada(String actividadId) async {
    final repository = ref.read(actividadRepositoryProvider);
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: actividadId,
      dia: DateTime.now(),
    );
    await repository.marcarOcurrenciaCompletada(ocurrencia.id);
    invalidarVistasTemporales(ref);
  }

  Future<void> marcarOcurrenciaHoyPendiente(String actividadId) async {
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
