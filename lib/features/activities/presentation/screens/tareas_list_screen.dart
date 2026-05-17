import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/tareas_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/utils/tarea_vencimiento.dart';

/// Lista básica de tareas (Sprint 2).
class TareasListScreen extends ConsumerWidget {
  const TareasListScreen({super.key});

  static final _fechaFormato = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tareasAsync = ref.watch(tareasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
      ),
      body: tareasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (tareas) {
          if (tareas.isEmpty) {
            return const Center(
              child: Text('No hay tareas. Pulsa + para crear una.'),
            );
          }
          return ListView.separated(
            itemCount: tareas.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tarea = tareas[index];
              return _TareaListTile(tarea: tarea);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tareas/nueva'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TareaListTile extends ConsumerWidget {
  const _TareaListTile({required this.tarea});

  final Actividad tarea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vencida = esTareaVencida(tarea, DateTime.now());
    final completada = tarea.estado == EstadoActividad.completada;

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              tarea.titulo,
              style: completada
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    )
                  : null,
            ),
          ),
          if (tarea.urgente)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.priority_high, color: Colors.red, size: 20),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tarea.descripcion != null && tarea.descripcion!.isNotEmpty)
            Text(tarea.descripcion!),
          Text(
            [
              completada ? 'Completada' : 'Pendiente',
              if (tarea.fechaLimite != null)
                'Límite: ${TareasListScreen._fechaFormato.format(tarea.fechaLimite!)}',
              if (vencida) 'Vencida',
            ].join(' · '),
            style: vencida && !completada
                ? TextStyle(color: Theme.of(context).colorScheme.error)
                : null,
          ),
        ],
      ),
      isThreeLine: tarea.descripcion != null && tarea.descripcion!.isNotEmpty,
      onTap: () => context.push('/tareas/${tarea.id}/editar'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(completada ? Icons.undo : Icons.check_circle_outline),
            tooltip: completada ? 'Marcar pendiente' : 'Marcar completada',
            onPressed: () => _cambiarEstado(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: () => _confirmarEliminar(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarEstado(BuildContext context, WidgetRef ref) async {
    try {
      if (tarea.estado == EstadoActividad.completada) {
        await ref.read(tareasProvider.notifier).marcarPendiente(tarea.id);
      } else {
        await ref.read(tareasProvider.notifier).marcarCompletada(tarea.id);
      }
    } on ValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _confirmarEliminar(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(tareasProvider.notifier).eliminarLogicamente(tarea.id);
    } on ValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}
