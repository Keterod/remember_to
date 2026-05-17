import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/agenda_provider.dart';
import '../widgets/actividad_resumen_tile.dart';

/// Agenda básica por día y hora (Sprint 4–5).
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
        data: (elementos) {
          if (elementos.isEmpty) {
            return const Center(
              child: Text('No hay actividades en los próximos días.'),
            );
          }

          final agrupadas = agruparAgendaPorDia(elementos);
          final dias = agrupadas.keys.toList()..sort();

          return ListView.builder(
            itemCount: dias.length,
            itemBuilder: (context, index) {
              final dia = dias[index];
              final delDia = agrupadas[dia]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      _diaFormato.format(dia),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ...delDia.map(
                    (e) => ActividadResumenTile(elemento: e),
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
}
