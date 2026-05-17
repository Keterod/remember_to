import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import 'actividad_repository_provider.dart';

final busquedaConsultaProvider = StateProvider<String>((ref) => '');

final busquedaActividadesProvider =
    AsyncNotifierProvider<BusquedaActividadesNotifier, List<Actividad>>(
  BusquedaActividadesNotifier.new,
);

class BusquedaActividadesNotifier extends AsyncNotifier<List<Actividad>> {
  @override
  Future<List<Actividad>> build() async {
    final consulta = ref.watch(busquedaConsultaProvider);
    if (consulta.trim().isEmpty) {
      return [];
    }
    final repository = ref.read(actividadRepositoryProvider);
    return repository.buscarActividadesActivas(consulta);
  }

  /// Actualiza la consulta; [build] vuelve a ejecutar la búsqueda.
  void buscar(String consulta) {
    ref.read(busquedaConsultaProvider.notifier).state = consulta;
  }
}
