import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/utils/actividad_temporal.dart';
import 'actividad_repository_provider.dart';

/// Días visibles en la agenda básica (hoy + siguientes).
const agendaDiasVisibles = 7;

final agendaProvider = FutureProvider.autoDispose<List<Actividad>>((ref) async {
  final repository = ref.watch(actividadRepositoryProvider);
  final hoy = DateTime.now();
  final inicio = inicioDelDia(hoy);
  final fin = finDelDia(
    hoy.add(const Duration(days: agendaDiasVisibles - 1)),
  );
  return repository.listarPorRangoFechas(inicio: inicio, fin: fin);
});
