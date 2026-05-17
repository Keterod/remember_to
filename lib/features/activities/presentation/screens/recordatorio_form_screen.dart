import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/recordatorios_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/tipo_actividad.dart';

/// Formulario básico para crear o editar un recordatorio (Sprint 3).
class RecordatorioFormScreen extends ConsumerStatefulWidget {
  const RecordatorioFormScreen({super.key, this.recordatorioId});

  final String? recordatorioId;

  bool get esEdicion => recordatorioId != null;

  @override
  ConsumerState<RecordatorioFormScreen> createState() =>
      _RecordatorioFormScreenState();
}

class _RecordatorioFormScreenState extends ConsumerState<RecordatorioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  Actividad? _recordatorioExistente;
  DateTime? _fechaAviso;
  bool _urgente = false;
  bool _cargando = true;
  bool _guardando = false;

  static final _fechaHoraFormato = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarRecordatorio();
    });
  }

  Future<void> _cargarRecordatorio() async {
    if (!widget.esEdicion) {
      setState(() => _cargando = false);
      return;
    }

    final recordatorio = await ref
        .read(actividadRepositoryProvider)
        .obtenerRecordatorioPorId(widget.recordatorioId!);

    if (!mounted) {
      return;
    }

    if (recordatorio == null) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recordatorio no encontrado.')),
      );
      context.pop();
      return;
    }

    _recordatorioExistente = recordatorio;
    _tituloController.text = recordatorio.titulo;
    _descripcionController.text = recordatorio.descripcion ?? '';
    _fechaAviso = recordatorio.fechaAviso;
    _urgente = recordatorio.urgente;
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
          title: Text(widget.esEdicion ? 'Editar recordatorio' : 'Nuevo recordatorio'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.esEdicion ? 'Editar recordatorio' : 'Nuevo recordatorio',
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha y hora de aviso *'),
              subtitle: Text(
                _fechaAviso == null
                    ? 'Obligatorio'
                    : _fechaHoraFormato.format(_fechaAviso!),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.event),
                tooltip: 'Elegir fecha y hora',
                onPressed: _elegirFechaHora,
              ),
            ),
            if (_fechaAviso == null)
              const Text(
                'Debes indicar cuándo quieres recibir el aviso.',
                style: TextStyle(color: Colors.red),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Urgente'),
              value: _urgente,
              onChanged: (value) => setState(() => _urgente = value),
            ),
            const SizedBox(height: 8),
            const Text(
              'El aviso depende de permisos del sistema y puede no ser exacto '
              'al 100 % en todos los dispositivos Android.',
              style: TextStyle(fontSize: 12),
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
                      widget.esEdicion ? 'Guardar cambios' : 'Crear recordatorio',
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _elegirFechaHora() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaAviso ?? ahora,
      firstDate: DateTime(ahora.year - 1),
      lastDate: DateTime(ahora.year + 10),
    );
    if (fecha == null || !mounted) {
      return;
    }

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fechaAviso ?? ahora),
    );
    if (hora == null) {
      return;
    }

    setState(() {
      _fechaAviso = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      );
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_fechaAviso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha y hora de aviso son obligatorias.'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final notifier = ref.read(recordatoriosProvider.notifier);

      if (!await notifier.permisosNotificacionActivos()) {
        await notifier.solicitarPermisosNotificacion();
      }

      if (widget.esEdicion) {
        final existente = _recordatorioExistente!;
        await notifier.editarRecordatorio(
          Actividad(
            id: existente.id,
            tipo: TipoActividad.recordatorio,
            titulo: _tituloController.text,
            descripcion: _descripcionController.text,
            estado: existente.estado,
            urgente: _urgente,
            fechaAviso: _fechaAviso,
            createdAt: existente.createdAt,
            updatedAt: existente.updatedAt,
          ),
        );
      } else {
        await notifier.crearRecordatorio(
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          fechaAviso: _fechaAviso!,
          urgente: _urgente,
        );
      }

      if (!mounted) {
        return;
      }

      final permisos = await notifier.permisosNotificacionActivos();
      if (!mounted) {
        return;
      }

      if (!permisos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Recordatorio guardado. Sin permisos de notificación '
              'el aviso no está garantizado.',
            ),
          ),
        );
      }
      context.pop();
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
