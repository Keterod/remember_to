import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import 'actividad_repository_provider.dart';

final hoyProvider =
    AsyncNotifierProvider<HoyNotifier, List<Actividad>>(HoyNotifier.new);

class HoyNotifier extends AsyncNotifier<List<Actividad>> {
  @override
  Future<List<Actividad>> build() async {
    return _cargar();
  }

  Future<List<Actividad>> _cargar() async {
    final repository = ref.read(actividadRepositoryProvider);
    return repository.listarParaHoy(DateTime.now());
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_cargar);
  }
}
