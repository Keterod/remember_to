import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/agenda_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/utils/actividad_temporal.dart';
import '../widgets/actividad_resumen_tile.dart';

/// Agenda básica por día y hora (Sprint 4).
class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  static final _diaFormato = DateFormat('EEEE dd/MM/yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaAsync = ref.watch(agendaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.agenda),
          SizedBox(width: 8),
        ],
      ),
      body: agendaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (actividades) {
          if (actividades.isEmpty) {
            return const Center(
              child: Text('No hay actividades en los próximos días.'),
            );
          }

          final agrupadas = _agruparPorDia(actividades);

          return ListView.builder(
            itemCount: agrupadas.length,
            itemBuilder: (context, index) {
              final entrada = agrupadas[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      _diaFormato.format(entrada.dia),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ...entrada.actividades.map(
                    (a) => ActividadResumenTile(actividad: a),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<_DiaAgenda> _agruparPorDia(List<Actividad> actividades) {
    final mapa = <DateTime, List<Actividad>>{};
    for (final actividad in actividades) {
      final fecha = fechaOrdenacion(actividad);
      if (fecha == null) {
        continue;
      }
      final clave = inicioDelDia(fecha);
      mapa.putIfAbsent(clave, () => []).add(actividad);
    }

    final dias = mapa.keys.toList()..sort();
    return dias
        .map(
          (dia) => _DiaAgenda(
            dia: dia,
            actividades: mapa[dia]!..sort(compararPorFechaOrdenacion),
          ),
        )
        .toList();
  }
}

class _DiaAgenda {
  const _DiaAgenda({required this.dia, required this.actividades});

  final DateTime dia;
  final List<Actividad> actividades;
}
