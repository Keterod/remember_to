import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/rutinas_provider.dart';
import '../../domain/enums/tipo_repeticion.dart';

/// Formulario básico para crear o editar una rutina (Sprint 5).
class RutinaFormScreen extends ConsumerStatefulWidget {
  const RutinaFormScreen({super.key, this.rutinaId});

  final String? rutinaId;

  bool get esEdicion => rutinaId != null;

  @override
  ConsumerState<RutinaFormScreen> createState() => _RutinaFormScreenState();
}

class _RutinaFormScreenState extends ConsumerState<RutinaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  final _diasOpciones = const [
    (DateTime.monday, 'Lun'),
    (DateTime.tuesday, 'Mar'),
    (DateTime.wednesday, 'Mié'),
    (DateTime.thursday, 'Jue'),
    (DateTime.friday, 'Vie'),
    (DateTime.saturday, 'Sáb'),
    (DateTime.sunday, 'Dom'),
  ];

  final Set<int> _diasSeleccionados = {};
  bool _todosLosDias = false;
  bool _urgente = false;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarRutina());
  }

  Future<void> _cargarRutina() async {
    if (!widget.esEdicion) {
      setState(() => _cargando = false);
      return;
    }

    final rutina =
        await ref.read(actividadRepositoryProvider).obtenerRutinaPorId(
              widget.rutinaId!,
            );
    final repeticion = rutina == null
        ? null
        : await ref
            .read(actividadRepositoryProvider)
            .obtenerRepeticionPorActividadId(rutina.id);

    if (!mounted) {
      return;
    }

    if (rutina == null || repeticion == null) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina no encontrada.')),
      );
      context.pop();
      return;
    }

    _tituloController.text = rutina.titulo;
    _descripcionController.text = rutina.descripcion ?? '';
    _urgente = rutina.urgente;
    _todosLosDias = repeticion.tipo == TipoRepeticion.diaria;
    _diasSeleccionados
      ..clear()
      ..addAll(repeticion.diasSemana ?? []);
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
          title: Text(widget.esEdicion ? 'Editar rutina' : 'Nueva rutina'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.esEdicion ? 'Editar rutina' : 'Nueva rutina'),
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
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Todos los días'),
              value: _todosLosDias,
              onChanged: (value) {
                setState(() {
                  _todosLosDias = value;
                  if (value) {
                    _diasSeleccionados.clear();
                  }
                });
              },
            ),
            if (!_todosLosDias) ...[
              const Text('Días de la semana *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _diasOpciones.map((opcion) {
                  final seleccionado = _diasSeleccionados.contains(opcion.$1);
                  return FilterChip(
                    label: Text(opcion.$2),
                    selected: seleccionado,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _diasSeleccionados.add(opcion.$1);
                        } else {
                          _diasSeleccionados.remove(opcion.$1);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
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
                  : Text(widget.esEdicion ? 'Guardar cambios' : 'Crear rutina'),
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
    if (!_todosLosDias && _diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un día o marca todos los días.'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final notifier = ref.read(rutinasProvider.notifier);
      final dias = _diasSeleccionados.toList();

      if (widget.esEdicion) {
        final rutina =
            await ref.read(actividadRepositoryProvider).obtenerRutinaPorId(
                  widget.rutinaId!,
                );
        if (rutina == null) {
          throw const ValidationException('Rutina no encontrada.');
        }
        await notifier.editarRutina(
          rutina: rutina.copyWith(
            titulo: _tituloController.text,
            descripcion: _descripcionController.text,
            urgente: _urgente,
          ),
          diasSemana: dias,
          todosLosDias: _todosLosDias,
        );
      } else {
        await notifier.crearRutina(
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          diasSemana: dias,
          todosLosDias: _todosLosDias,
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
