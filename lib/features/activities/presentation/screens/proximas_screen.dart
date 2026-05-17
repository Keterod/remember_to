import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/proximas_provider.dart';
import '../widgets/actividad_resumen_tile.dart';

/// Actividades futuras ordenadas (Sprint 4).
class ProximasScreen extends ConsumerWidget {
  const ProximasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proximasAsync = ref.watch(proximasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximas'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.proximas),
          SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(proximasProvider.notifier).recargar(),
        child: proximasAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [Center(child: Text('Error: $error'))],
          ),
          data: (actividades) {
            if (actividades.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('No hay actividades futuras pendientes.')),
                ],
              );
            }
            return ListView.separated(
              itemCount: actividades.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ActividadResumenTile(
                  elemento: actividades[index],
                  mostrarVencida: false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
