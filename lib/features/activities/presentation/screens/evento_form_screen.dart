import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../application/providers/actividad_repository_provider.dart';
import '../../application/providers/eventos_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/tipo_actividad.dart';

/// Formulario básico para crear o editar un evento (Sprint 4).
class EventoFormScreen extends ConsumerStatefulWidget {
  const EventoFormScreen({super.key, this.eventoId});

  final String? eventoId;

  bool get esEdicion => eventoId != null;

  @override
  ConsumerState<EventoFormScreen> createState() => _EventoFormScreenState();
}

class _EventoFormScreenState extends ConsumerState<EventoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  Actividad? _eventoExistente;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _urgente = false;
  bool _cargando = true;
  bool _guardando = false;

  static final _fechaHoraFormato = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEvento();
    });
  }

  Future<void> _cargarEvento() async {
    if (!widget.esEdicion) {
      setState(() => _cargando = false);
      return;
    }

    final evento = await ref
        .read(actividadRepositoryProvider)
        .obtenerEventoPorId(widget.eventoId!);

    if (!mounted) {
      return;
    }

    if (evento == null) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento no encontrado.')),
      );
      context.pop();
      return;
    }

    _eventoExistente = evento;
    _tituloController.text = evento.titulo;
    _descripcionController.text = evento.descripcion ?? '';
    _fechaInicio = evento.fechaInicio;
    _fechaFin = evento.fechaFin;
    _urgente = evento.urgente;
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
          title: Text(widget.esEdicion ? 'Editar evento' : 'Nuevo evento'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.esEdicion ? 'Editar evento' : 'Nuevo evento'),
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
              title: const Text('Inicio *'),
              subtitle: Text(
                _fechaInicio == null
                    ? 'Obligatorio'
                    : _fechaHoraFormato.format(_fechaInicio!),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Elegir inicio',
                onPressed: () => _elegirFechaHora(esInicio: true),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fin *'),
              subtitle: Text(
                _fechaFin == null
                    ? 'Obligatorio'
                    : _fechaHoraFormato.format(_fechaFin!),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.stop),
                tooltip: 'Elegir fin',
                onPressed: () => _elegirFechaHora(esInicio: false),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Urgente'),
              value: _urgente,
              onChanged: (value) => setState(() => _urgente = value),
            ),
            const SizedBox(height: 8),
            const Text(
              'Se programa un aviso 30 minutos antes del inicio y otro al inicio. '
              'Desde la notificación puedes completar o posponer.',
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
                  : Text(widget.esEdicion ? 'Guardar cambios' : 'Crear evento'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _elegirFechaHora({required bool esInicio}) async {
    final ahora = DateTime.now();
    final actual = esInicio ? _fechaInicio : _fechaFin;
    final fecha = await showDatePicker(
      context: context,
      initialDate: actual ?? ahora,
      firstDate: DateTime(ahora.year - 1),
      lastDate: DateTime(ahora.year + 10),
    );
    if (fecha == null || !mounted) {
      return;
    }

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(actual ?? ahora),
    );
    if (hora == null) {
      return;
    }

    setState(() {
      final valor = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      );
      if (esInicio) {
        _fechaInicio = valor;
      } else {
        _fechaFin = valor;
      }
    });
  }

  Future<void> _guardar() async {
    if (_guardando) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las fechas de inicio y fin son obligatorias.'),
        ),
      );
      return;
    }

    _guardando = true;
    setState(() {});

    try {
      final notifier = ref.read(eventosProvider.notifier);

      if (widget.esEdicion) {
        final existente = _eventoExistente!;
        await notifier.editarEvento(
          Actividad(
            id: existente.id,
            tipo: TipoActividad.evento,
            titulo: _tituloController.text,
            descripcion: _descripcionController.text,
            estado: existente.estado,
            urgente: _urgente,
            fechaInicio: _fechaInicio,
            fechaFin: _fechaFin,
            createdAt: existente.createdAt,
            updatedAt: existente.updatedAt,
          ),
        );
      } else {
        await notifier.crearEvento(
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          fechaInicio: _fechaInicio!,
          fechaFin: _fechaFin!,
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
