import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/calendario_provider.dart';
import '../widgets/actividad_resumen_tile.dart';

/// Calendario mensual básico con actividades del día seleccionado (Sprint 4).
class CalendarioScreen extends ConsumerWidget {
  const CalendarioScreen({super.key});

  static final _mesAnioFormato = DateFormat('MMMM yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fechaSeleccionada = ref.watch(fechaCalendarioSeleccionadaProvider);
    final actividadesAsync = ref.watch(actividadesCalendarioProvider);
    final mesVisible = DateTime(fechaSeleccionada.year, fechaSeleccionada.month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.calendario),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _CalendarioMes(
            mes: mesVisible,
            fechaSeleccionada: fechaSeleccionada,
            onMesAnterior: () {
              ref.read(fechaCalendarioSeleccionadaProvider.notifier).state =
                  DateTime(mesVisible.year, mesVisible.month - 1, 1);
            },
            onMesSiguiente: () {
              ref.read(fechaCalendarioSeleccionadaProvider.notifier).state =
                  DateTime(mesVisible.year, mesVisible.month + 1, 1);
            },
            onDiaSeleccionado: (dia) {
              ref.read(fechaCalendarioSeleccionadaProvider.notifier).state =
                  dia;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Actividades del ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: actividadesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (actividades) {
                if (actividades.isEmpty) {
                  return const Center(
                    child: Text('No hay actividades para esta fecha.'),
                  );
                }
                return ListView.separated(
                  itemCount: actividades.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ActividadResumenTile(actividad: actividades[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarioMes extends StatelessWidget {
  const _CalendarioMes({
    required this.mes,
    required this.fechaSeleccionada,
    required this.onMesAnterior,
    required this.onMesSiguiente,
    required this.onDiaSeleccionado,
  });

  final DateTime mes;
  final DateTime fechaSeleccionada;
  final VoidCallback onMesAnterior;
  final VoidCallback onMesSiguiente;
  final ValueChanged<DateTime> onDiaSeleccionado;

  @override
  Widget build(BuildContext context) {
    final primerDia = DateTime(mes.year, mes.month, 1);
    final diasEnMes = DateUtils.getDaysInMonth(mes.year, mes.month);
    final offset = primerDia.weekday - DateTime.monday;
    final celdas = offset + diasEnMes;
    final filas = (celdas / 7).ceil();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onMesAnterior,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                CalendarioScreen._mesAnioFormato.format(mes),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: onMesSiguiente,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              _DiaSemanaLabel('L'),
              _DiaSemanaLabel('M'),
              _DiaSemanaLabel('X'),
              _DiaSemanaLabel('J'),
              _DiaSemanaLabel('V'),
              _DiaSemanaLabel('S'),
              _DiaSemanaLabel('D'),
            ],
          ),
          for (var fila = 0; fila < filas; fila++)
            Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _celdaDia(
                      context,
                      indice: fila * 7 + col,
                      offset: offset,
                      diasEnMes: diasEnMes,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _celdaDia(
    BuildContext context, {
    required int indice,
    required int offset,
    required int diasEnMes,
  }) {
    final diaNumero = indice - offset + 1;
    if (diaNumero < 1 || diaNumero > diasEnMes) {
      return const SizedBox(height: 40);
    }

    final dia = DateTime(mes.year, mes.month, diaNumero);
    final seleccionado = dia.year == fechaSeleccionada.year &&
        dia.month == fechaSeleccionada.month &&
        dia.day == fechaSeleccionada.day;
    final esHoy = DateUtils.isSameDay(dia, DateTime.now());

    return InkWell(
      onTap: () => onDiaSeleccionado(dia),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: seleccionado
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          border: esHoy
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('$diaNumero'),
      ),
    );
  }
}

class _DiaSemanaLabel extends StatelessWidget {
  const _DiaSemanaLabel(this.etiqueta);

  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          etiqueta,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
