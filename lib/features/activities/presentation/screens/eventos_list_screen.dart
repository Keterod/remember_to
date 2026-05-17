import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/eventos_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/estado_actividad.dart';

/// Lista básica de eventos (Sprint 4).
class EventosListScreen extends ConsumerWidget {
  const EventosListScreen({super.key});

  static final _fechaHoraFormato = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventosAsync = ref.watch(eventosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.eventos),
          SizedBox(width: 8),
        ],
      ),
      body: eventosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (eventos) {
          if (eventos.isEmpty) {
            return const Center(
              child: Text('No hay eventos. Pulsa + para crear uno.'),
            );
          }
          return ListView.separated(
            itemCount: eventos.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _EventoListTile(evento: eventos[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/eventos/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EventoListTile extends ConsumerWidget {
  const _EventoListTile({required this.evento});

  final Actividad evento;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completada = evento.estado == EstadoActividad.completada;

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              evento.titulo,
              style: completada
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
          ),
          if (evento.urgente)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.priority_high, color: Colors.red, size: 20),
            ),
        ],
      ),
      subtitle: Text(
        [
          completada ? 'Completada' : 'Pendiente',
          if (evento.fechaInicio != null && evento.fechaFin != null)
            '${EventosListScreen._fechaHoraFormato.format(evento.fechaInicio!)} – '
            '${EventosListScreen._fechaHoraFormato.format(evento.fechaFin!)}',
        ].join(' · '),
      ),
      onTap: () => context.push('/eventos/${evento.id}/editar'),
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
      final notifier = ref.read(eventosProvider.notifier);
      if (evento.estado == EstadoActividad.completada) {
        await notifier.marcarPendiente(evento.id);
      } else {
        await notifier.marcarCompletada(evento.id);
      }
    } on ValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  Future<void> _confirmarEliminar(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: Text('¿Eliminar "${evento.titulo}"?'),
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
      await ref.read(eventosProvider.notifier).eliminarLogicamente(evento.id);
    } on ValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}
