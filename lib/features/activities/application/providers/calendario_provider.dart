import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/elemento_vista_temporal.dart';
import '../../domain/utils/actividad_temporal.dart';
import 'actividad_repository_provider.dart';

final fechaCalendarioSeleccionadaProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

final actividadesCalendarioProvider =
    FutureProvider.autoDispose<List<ElementoVistaTemporal>>((ref) async {
  final fecha = ref.watch(fechaCalendarioSeleccionadaProvider);
  final repository = ref.watch(actividadRepositoryProvider);
  final inicio = inicioDelDia(fecha);
  final fin = finDelDia(fecha);
  return repository.listarPorRangoFechas(inicio: inicio, fin: fin);
});
