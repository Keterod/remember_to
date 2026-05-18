import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/tareas_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/tipo_actividad.dart';

/// Formulario básico para crear o editar una tarea (Sprint 2).
class TareaFormScreen extends ConsumerStatefulWidget {
  const TareaFormScreen({super.key, this.tareaId});

  final String? tareaId;

  bool get esEdicion => tareaId != null;

  @override
  ConsumerState<TareaFormScreen> createState() => _TareaFormScreenState();
}

class _TareaFormScreenState extends ConsumerState<TareaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  Actividad? _tareaExistente;
  DateTime? _fechaLimite;
  bool _urgente = false;
  bool _cargando = true;
  bool _guardando = false;

  static final _fechaFormato = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarTarea();
    });
  }

  Future<void> _cargarTarea() async {
    if (!widget.esEdicion) {
      setState(() => _cargando = false);
      return;
    }

    final tarea = await ref
        .read(actividadRepositoryProvider)
        .obtenerPorId(widget.tareaId!);

    if (!mounted) {
      return;
    }

    if (tarea == null || tarea.tipo != TipoActividad.tarea) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea no encontrada.')),
      );
      context.pop();
      return;
    }

    _tareaExistente = tarea;
    _tituloController.text = tarea.titulo;
    _descripcionController.text = tarea.descripcion ?? '';
    _fechaLimite = tarea.fechaLimite;
    _urgente = tarea.urgente;
    setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.esEdicion ? 'Editar tarea' : 'Nueva tarea'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.esEdicion ? 'Editar tarea' : 'Nueva tarea'),
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
              textCapitalization: TextCapitalization.sentences,
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
                labelText: 'Nota o descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha límite (opcional)'),
              subtitle: Text(
                _fechaLimite == null
                    ? 'Sin fecha límite'
                    : _fechaFormato.format(_fechaLimite!),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_fechaLimite != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Quitar fecha',
                      onPressed: () => setState(() => _fechaLimite = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    tooltip: 'Elegir fecha',
                    onPressed: _elegirFecha,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Urgente'),
              value: _urgente,
              onChanged: (value) => setState(() => _urgente = value),
            ),
            if (_fechaLimite != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Con fecha límite se programa un aviso 1 hora antes y otro en la fecha. '
                'Desde la notificación puedes completar o posponer.',
                style: TextStyle(fontSize: 12),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.esEdicion ? 'Guardar cambios' : 'Crear tarea'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaLimite ?? hoy,
      firstDate: DateTime(hoy.year - 5),
      lastDate: DateTime(hoy.year + 10),
    );
    if (fecha != null) {
      setState(() {
        _fechaLimite = DateTime(fecha.year, fecha.month, fecha.day);
      });
    }
  }

  Future<void> _guardar() async {
    if (_guardando) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _guardando = true;
    setState(() {});

    try {
      final notifier = ref.read(tareasProvider.notifier);
      final titulo = _tituloController.text;
      final descripcion = _descripcionController.text;

      if (widget.esEdicion) {
        final existente = _tareaExistente!;
        await notifier.editarTarea(
          Actividad(
            id: existente.id,
            tipo: TipoActividad.tarea,
            titulo: titulo,
            descripcion: descripcion,
            estado: existente.estado,
            urgente: _urgente,
            fechaLimite: _fechaLimite,
            createdAt: existente.createdAt,
            updatedAt: existente.updatedAt,
          ),
        );
      } else {
        await notifier.crearTarea(
          titulo: titulo,
          descripcion: descripcion,
          fechaLimite: _fechaLimite,
          urgente: _urgente,
        );
      }

      if (!mounted) {
        return;
      }
      context.pop(true);
    } on ValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        setState(() => _guardando = false);
      }
    }
  }
}
