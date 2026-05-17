import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/recordatorios_provider.dart';
import '../../domain/entities/actividad.dart';

/// Lista básica de recordatorios (Sprint 3).
class RecordatoriosListScreen extends ConsumerStatefulWidget {
  const RecordatoriosListScreen({super.key});

  @override
  ConsumerState<RecordatoriosListScreen> createState() =>
      _RecordatoriosListScreenState();
}

class _RecordatoriosListScreenState extends ConsumerState<RecordatoriosListScreen> {
  static final _fechaHoraFormato = DateFormat('dd/MM/yyyy HH:mm');

  bool? _permisosActivos;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revisarPermisos();
    });
  }

  Future<void> _revisarPermisos() async {
    final activos =
        await ref.read(recordatoriosProvider.notifier).permisosNotificacionActivos();
    if (mounted) {
      setState(() => _permisosActivos = activos);
    }
  }

  Future<void> _solicitarPermisos() async {
    final concedido = await ref
        .read(recordatoriosProvider.notifier)
        .solicitarPermisosNotificacion();
    if (mounted) {
      setState(() => _permisosActivos = concedido);
      if (!concedido) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sin permiso de notificaciones el recordatorio se guarda, '
              'pero el aviso no está garantizado en este dispositivo.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordatoriosAsync = ref.watch(recordatoriosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.recordatorios),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (_permisosActivos == false)
            MaterialBanner(
              content: const Text(
                'Activa las notificaciones para recibir avisos. '
                'En Android 13+ se requiere permiso explícito. '
                'Las alarmas exactas pueden variar según el fabricante.',
              ),
              actions: [
                TextButton(
                  onPressed: _solicitarPermisos,
                  child: const Text('Activar'),
                ),
              ],
            ),
          Expanded(
            child: recordatoriosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (recordatorios) {
                if (recordatorios.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay recordatorios. Pulsa + para crear uno.',
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: recordatorios.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return _RecordatorioListTile(
                      recordatorio: recordatorios[index],
                      fechaHoraFormato: _fechaHoraFormato,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/recordatorios/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RecordatorioListTile extends ConsumerWidget {
  const _RecordatorioListTile({
    required this.recordatorio,
    required this.fechaHoraFormato,
  });

  final Actividad recordatorio;
  final DateFormat fechaHoraFormato;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fechaAviso = recordatorio.fechaAviso;

    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(recordatorio.titulo)),
          if (recordatorio.urgente)
            const Icon(Icons.priority_high, color: Colors.red, size: 20),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recordatorio.descripcion != null &&
              recordatorio.descripcion!.isNotEmpty)
            Text(recordatorio.descripcion!),
          Text(
            fechaAviso == null
                ? 'Sin aviso'
                : 'Aviso: ${fechaHoraFormato.format(fechaAviso)}',
          ),
        ],
      ),
      isThreeLine: recordatorio.descripcion != null &&
          recordatorio.descripcion!.isNotEmpty,
      onTap: () => context.push('/recordatorios/${recordatorio.id}/editar'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Eliminar',
        onPressed: () => _confirmarEliminar(context, ref),
      ),
    );
  }

  Future<void> _confirmarEliminar(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar recordatorio'),
        content: Text('¿Eliminar "${recordatorio.titulo}"?'),
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
      await ref
          .read(recordatoriosProvider.notifier)
          .eliminarRecordatorio(recordatorio.id);
    } on ValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}
