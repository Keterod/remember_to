import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/elemento_vista_temporal.dart';
import 'actividad_repository_provider.dart';

final vencidasProvider =
    AsyncNotifierProvider<VencidasNotifier, List<ElementoVistaTemporal>>(
  VencidasNotifier.new,
);

class VencidasNotifier extends AsyncNotifier<List<ElementoVistaTemporal>> {
  @override
  Future<List<ElementoVistaTemporal>> build() async {
    return _cargar();
  }

  Future<List<ElementoVistaTemporal>> _cargar() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarVencidas();
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_cargar);
  }
}
