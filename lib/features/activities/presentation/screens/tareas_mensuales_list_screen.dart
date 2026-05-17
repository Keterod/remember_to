import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/tareas_mensuales_provider.dart';
import '../../domain/enums/estado_ocurrencia.dart';
import '../../domain/utils/repeticion_utils.dart';

/// Lista básica de tareas mensuales (Sprint 5).
class TareasMensualesListScreen extends ConsumerWidget {
  const TareasMensualesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tareasAsync = ref.watch(tareasMensualesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas mensuales'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.tareasMensuales),
          SizedBox(width: 8),
        ],
      ),
      body: tareasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (tareas) {
          if (tareas.isEmpty) {
            return const Center(
              child: Text('No hay tareas mensuales. Pulsa + para crear una.'),
            );
          }
          return ListView.separated(
            itemCount: tareas.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _TareaMensualListTile(item: tareas[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tareas-mensuales/nueva'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TareaMensualListTile extends ConsumerStatefulWidget {
  const _TareaMensualListTile({required this.item});

  final TareaMensualConRepeticion item;

  @override
  ConsumerState<_TareaMensualListTile> createState() =>
      _TareaMensualListTileState();
}

class _TareaMensualListTileState extends ConsumerState<_TareaMensualListTile> {
  bool? _mesCompletada;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarMes());
  }

  Future<void> _cargarMes() async {
    final hoy = DateTime.now();
    final ocurrencia = await ref
        .read(actividadRepositoryProvider)
        .obtenerOcurrenciaParaDia(
          actividadId: widget.item.tareaMensual.id,
          dia: hoy,
        );
    if (mounted) {
      setState(() {
        _mesCompletada =
            ocurrencia?.estadoOcurrencia == EstadoOcurrencia.completada;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tarea = widget.item.tareaMensual;
    final diaMes = widget.item.repeticion.diaMes ?? 0;
    final fechaMes = fechaMensualProgramada(
      DateTime.now().year,
      DateTime.now().month,
      diaMes,
    );

    return ListTile(
      title: Text(tarea.titulo),
      subtitle: Text(
        [
          'Día del mes: $diaMes (este mes: ${fechaMes.day})',
          if (_cargando)
            'Cargando mes...'
          else
            _mesCompletada == true ? 'Mes actual: completada' : 'Mes actual: pendiente',
        ].join(' · '),
      ),
      onTap: () => context.push('/tareas-mensuales/${tarea.id}/editar'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _mesCompletada == true
                  ? Icons.undo
                  : Icons.check_circle_outline,
            ),
            tooltip: _mesCompletada == true
                ? 'Marcar mes pendiente'
                : 'Marcar mes completada',
            onPressed: _cambiarMes,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: _confirmarEliminar,
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarMes() async {
    try {
      final notifier = ref.read(tareasMensualesProvider.notifier);
      if (_mesCompletada == true) {
        await notifier.marcarOcurrenciaMesPendiente(widget.item.tareaMensual.id);
      } else {
        await notifier.marcarOcurrenciaMesCompletada(widget.item.tareaMensual.id);
      }
      await _cargarMes();
    } on ValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  Future<void> _confirmarEliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea mensual'),
        content: Text('¿Eliminar "${widget.item.tareaMensual.titulo}"?'),
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

    if (confirmar != true || !mounted) {
      return;
    }

    try {
      await ref
          .read(tareasMensualesProvider.notifier)
          .eliminarLogicamente(widget.item.tareaMensual.id);
    } on ValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}
