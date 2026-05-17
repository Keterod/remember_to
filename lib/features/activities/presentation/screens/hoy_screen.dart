import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/hoy_provider.dart';
import '../widgets/actividad_resumen_tile.dart';

/// Actividades del día actual (Sprint 4).
class HoyScreen extends ConsumerWidget {
  const HoyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoyAsync = ref.watch(hoyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoy'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.hoy),
          SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(hoyProvider.notifier).recargar(),
        child: hoyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [Center(child: Text('Error: $error'))],
          ),
          data: (actividades) {
            if (actividades.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text('No hay actividades programadas para hoy.'),
                  ),
                ],
              );
            }
            return ListView.separated(
              itemCount: actividades.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ActividadResumenTile(actividad: actividades[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
