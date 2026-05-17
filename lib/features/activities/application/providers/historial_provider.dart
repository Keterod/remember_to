import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/historial_actividad.dart';
import 'actividad_repository_provider.dart';

final historialRecienteProvider =
    AsyncNotifierProvider<HistorialRecienteNotifier, List<HistorialActividad>>(
  HistorialRecienteNotifier.new,
);

class HistorialRecienteNotifier extends AsyncNotifier<List<HistorialActividad>> {
  @override
  Future<List<HistorialActividad>> build() async {
    return _cargar();
  }

  Future<List<HistorialActividad>> _cargar() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarHistorialReciente();
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_cargar);
  }
}
