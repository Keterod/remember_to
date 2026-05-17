import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/rutinas_provider.dart';
import '../../domain/entities/repeticion.dart';
import '../../domain/enums/estado_ocurrencia.dart';
import '../../domain/enums/tipo_repeticion.dart';
import '../../domain/utils/repeticion_utils.dart';

/// Lista básica de rutinas (Sprint 5).
class RutinasListScreen extends ConsumerWidget {
  const RutinasListScreen({super.key});

  static const _diasEtiquetas = {
    DateTime.monday: 'Lun',
    DateTime.tuesday: 'Mar',
    DateTime.wednesday: 'Mié',
    DateTime.thursday: 'Jue',
    DateTime.friday: 'Vie',
    DateTime.saturday: 'Sáb',
    DateTime.sunday: 'Dom',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rutinasAsync = ref.watch(rutinasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinas'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.rutinas),
          SizedBox(width: 8),
        ],
      ),
      body: rutinasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (rutinas) {
          if (rutinas.isEmpty) {
            return const Center(
              child: Text('No hay rutinas. Pulsa + para crear una.'),
            );
          }
          return ListView.separated(
            itemCount: rutinas.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _RutinaListTile(item: rutinas[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/rutinas/nueva'),
        child: const Icon(Icons.add),
      ),
    );
  }

  static String textoDias(Repeticion repeticion) {
    if (repeticion.tipo == TipoRepeticion.diaria) {
      return 'Todos los días';
    }
    final dias = repeticion.diasSemana ?? [];
    if (dias.isEmpty) {
      return 'Sin días';
    }
    return dias.map((d) => _diasEtiquetas[d] ?? '$d').join(', ');
  }
}

class _RutinaListTile extends ConsumerStatefulWidget {
  const _RutinaListTile({required this.item});

  final RutinaConRepeticion item;

  @override
  ConsumerState<_RutinaListTile> createState() => _RutinaListTileState();
}

class _RutinaListTileState extends ConsumerState<_RutinaListTile> {
  bool? _hoyAplica;
  bool? _hoyCompletada;
  bool _cargandoOcurrencia = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarOcurrenciaHoy());
  }

  Future<void> _cargarOcurrenciaHoy() async {
    final hoy = DateTime.now();
    final aplica = repeticionAplicaEnDia(widget.item.repeticion, hoy);
    var completada = false;
    if (aplica) {
      final ocurrencia = await ref
          .read(actividadRepositoryProvider)
          .obtenerOcurrenciaParaDia(
            actividadId: widget.item.rutina.id,
            dia: hoy,
          );
      completada =
          ocurrencia?.estadoOcurrencia == EstadoOcurrencia.completada;
    }
    if (mounted) {
      setState(() {
        _hoyAplica = aplica;
        _hoyCompletada = completada;
        _cargandoOcurrencia = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rutina = widget.item.rutina;
    final subtitulo = [
      RutinasListScreen.textoDias(widget.item.repeticion),
      if (_cargandoOcurrencia)
        'Cargando hoy...'
      else if (_hoyAplica == true)
        _hoyCompletada == true ? 'Hoy: completada' : 'Hoy: pendiente'
      else
        'Hoy: no aplica',
    ].join(' · ');

    return ListTile(
      title: Text(rutina.titulo),
      subtitle: Text(subtitulo),
      onTap: () => context.push('/rutinas/${rutina.id}/editar'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hoyAplica == true)
            IconButton(
              icon: Icon(
                _hoyCompletada == true
                    ? Icons.undo
                    : Icons.check_circle_outline,
              ),
              tooltip: _hoyCompletada == true
                  ? 'Marcar hoy pendiente'
                  : 'Marcar hoy completada',
              onPressed: _cambiarOcurrenciaHoy,
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

  Future<void> _cambiarOcurrenciaHoy() async {
    try {
      final notifier = ref.read(rutinasProvider.notifier);
      if (_hoyCompletada == true) {
        await notifier.marcarOcurrenciaHoyPendiente(widget.item.rutina.id);
      } else {
        await notifier.marcarOcurrenciaHoyCompletada(widget.item.rutina.id);
      }
      await _cargarOcurrenciaHoy();
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
        title: const Text('Eliminar rutina'),
        content: Text('¿Eliminar "${widget.item.rutina.titulo}"?'),
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
          .read(rutinasProvider.notifier)
          .eliminarLogicamente(widget.item.rutina.id);
    } on ValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}
