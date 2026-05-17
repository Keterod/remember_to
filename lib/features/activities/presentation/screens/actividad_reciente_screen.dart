import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/historial_provider.dart';
import '../../domain/enums/accion_historial.dart';
/// Actividad reciente según historial (Sprint 6).
class ActividadRecienteScreen extends ConsumerWidget {
  const ActividadRecienteScreen({super.key});

  static final _fechaFormato = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialAsync = ref.watch(historialRecienteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividad reciente'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.actividadReciente),
          SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(historialRecienteProvider.notifier).recargar(),
        child: historialAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [Center(child: Text('Error: $error'))],
          ),
          data: (entradas) {
            if (entradas.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Aún no hay actividad reciente registrada.')),
                ],
              );
            }
            return ListView.separated(
              itemCount: entradas.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entrada = entradas[index];
                return ListTile(
                  title: Text(entrada.detalle ?? 'Actividad'),
                  subtitle: Text(
                    '${entrada.accion.etiqueta} · '
                    '${_fechaFormato.format(entrada.fechaHora)}',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
