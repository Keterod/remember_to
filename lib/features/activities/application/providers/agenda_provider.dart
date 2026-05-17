import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/elemento_vista_temporal.dart';
import '../../domain/utils/actividad_temporal.dart';
import '../../domain/utils/elemento_vista_temporal_utils.dart';
import 'actividad_repository_provider.dart';

/// Días visibles en la agenda básica (hoy + siguientes).
const agendaDiasVisibles = 7;

final agendaProvider =
    FutureProvider.autoDispose<List<ElementoVistaTemporal>>((ref) async {
  final repository = ref.watch(actividadRepositoryProvider);
  final hoy = DateTime.now();
  final inicio = inicioDelDia(hoy);
  final fin = finDelDia(
    hoy.add(const Duration(days: agendaDiasVisibles - 1)),
  );
  return repository.listarPorRangoFechas(inicio: inicio, fin: fin);
});

/// Agrupa elementos de agenda por día civil.
Map<DateTime, List<ElementoVistaTemporal>> agruparAgendaPorDia(
  List<ElementoVistaTemporal> elementos,
) {
  final mapa = <DateTime, List<ElementoVistaTemporal>>{};
  for (final elemento in elementos) {
    final fecha = fechaOrdenacionElemento(elemento);
    if (fecha == null) {
      continue;
    }
    final clave = inicioDelDia(fecha);
    mapa.putIfAbsent(clave, () => []).add(elemento);
  }
  for (final lista in mapa.values) {
    lista.sort(compararElementosVistaTemporal);
  }
  return mapa;
}
