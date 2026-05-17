import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/tareas_mensuales_provider.dart';

/// Formulario básico para crear o editar una tarea mensual (Sprint 5).
class TareaMensualFormScreen extends ConsumerStatefulWidget {
  const TareaMensualFormScreen({super.key, this.tareaMensualId});

  final String? tareaMensualId;

  bool get esEdicion => tareaMensualId != null;

  @override
  ConsumerState<TareaMensualFormScreen> createState() =>
      _TareaMensualFormScreenState();
}

class _TareaMensualFormScreenState extends ConsumerState<TareaMensualFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _diaMesController = TextEditingController();

  bool _urgente = false;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  Future<void> _cargar() async {
    if (!widget.esEdicion) {
      setState(() => _cargando = false);
      return;
    }

    final tarea = await ref
        .read(actividadRepositoryProvider)
        .obtenerTareaMensualPorId(widget.tareaMensualId!);
    final repeticion = tarea == null
        ? null
        : await ref
            .read(actividadRepositoryProvider)
            .obtenerRepeticionPorActividadId(tarea.id);

    if (!mounted) {
      return;
    }

    if (tarea == null || repeticion == null) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea mensual no encontrada.')),
      );
      context.pop();
      return;
    }

    _tituloController.text = tarea.titulo;
    _descripcionController.text = tarea.descripcion ?? '';
    _diaMesController.text = '${repeticion.diaMes}';
    _urgente = tarea.urgente;
    setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _diaMesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.esEdicion ? 'Editar tarea mensual' : 'Nueva tarea mensual',
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.esEdicion ? 'Editar tarea mensual' : 'Nueva tarea mensual',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _diaMesController,
              decoration: const InputDecoration(
                labelText: 'Día del mes (1–31) *',
                border: OutlineInputBorder(),
                helperText:
                    'Si el mes no tiene ese día, se usará el último disponible.',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                final dia = int.tryParse(value ?? '');
                if (dia == null || dia < 1 || dia > 31) {
                  return 'Indica un día entre 1 y 31';
                }
                return null;
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Urgente'),
              value: _urgente,
              onChanged: (value) => setState(() => _urgente = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.esEdicion
                          ? 'Guardar cambios'
                          : 'Crear tarea mensual',
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final diaMes = int.parse(_diaMesController.text.trim());
    setState(() => _guardando = true);

    try {
      final notifier = ref.read(tareasMensualesProvider.notifier);

      if (widget.esEdicion) {
        final tarea = await ref
            .read(actividadRepositoryProvider)
            .obtenerTareaMensualPorId(widget.tareaMensualId!);
        if (tarea == null) {
          throw const ValidationException('Tarea mensual no encontrada.');
        }
        await notifier.editarTareaMensual(
          tareaMensual: tarea.copyWith(
            titulo: _tituloController.text,
            descripcion: _descripcionController.text,
            urgente: _urgente,
          ),
          diaMes: diaMes,
        );
      } else {
        await notifier.crearTareaMensual(
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          diaMes: diaMes,
          urgente: _urgente,
        );
      }

      if (mounted) {
        context.pop();
      }
    } on ValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }
}
