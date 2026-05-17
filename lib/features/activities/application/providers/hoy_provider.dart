import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/elemento_vista_temporal.dart';
import 'actividad_repository_provider.dart';

final hoyProvider =
    AsyncNotifierProvider<HoyNotifier, List<ElementoVistaTemporal>>(HoyNotifier.new);

class HoyNotifier extends AsyncNotifier<List<ElementoVistaTemporal>> {
  @override
  Future<List<ElementoVistaTemporal>> build() async {
    return _cargar();
  }

  Future<List<ElementoVistaTemporal>> _cargar() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarParaHoy(DateTime.now());
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_cargar);
  }
}
