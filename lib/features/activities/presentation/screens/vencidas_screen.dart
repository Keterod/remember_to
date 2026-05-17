import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/vencidas_provider.dart';
import '../widgets/actividad_resumen_tile.dart';

/// Actividades vencidas calculadas (Sprint 4).
class VencidasScreen extends ConsumerWidget {
  const VencidasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vencidasAsync = ref.watch(vencidasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vencidas'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.vencidas),
          SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(vencidasProvider.notifier).recargar(),
        child: vencidasAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [Center(child: Text('Error: $error'))],
          ),
          data: (actividades) {
            if (actividades.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('No hay actividades vencidas pendientes.')),
                ],
              );
            }
            return ListView.separated(
              itemCount: actividades.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ActividadResumenTile(elemento: actividades[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
