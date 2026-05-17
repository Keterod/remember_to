import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/enums/tipo_actividad.dart';
import '../../domain/utils/actividad_temporal.dart';
import '../../domain/utils/actividad_vencimiento.dart';

/// Fila reutilizable para vistas temporales (Hoy, Próximas, Vencidas, etc.).
class ActividadResumenTile extends StatelessWidget {
  const ActividadResumenTile({
    super.key,
    required this.actividad,
    this.onTap,
    this.mostrarVencida = true,
  });

  final Actividad actividad;
  final VoidCallback? onTap;
  final bool mostrarVencida;

  static final _fechaFormato = DateFormat('dd/MM/yyyy');
  static final _fechaHoraFormato = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final completada = actividad.estado == EstadoActividad.completada;
    final vencida = mostrarVencida &&
        esActividadVencida(actividad, DateTime.now());

    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              actividad.titulo,
              style: completada
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
          ),
          if (actividad.urgente)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.priority_high, color: Colors.red, size: 20),
            ),
        ],
      ),
      subtitle: Text(
        [
          _etiquetaTipo(actividad.tipo),
          completada ? 'Completada' : 'Pendiente',
          _textoFecha(actividad),
          if (vencida) 'Vencida',
        ].join(' · '),
        style: vencida && !completada
            ? TextStyle(color: Theme.of(context).colorScheme.error)
            : null,
      ),
      isThreeLine: false,
    );
  }

  static String _etiquetaTipo(TipoActividad tipo) {
    switch (tipo) {
      case TipoActividad.tarea:
        return 'Tarea';
      case TipoActividad.recordatorio:
        return 'Recordatorio';
      case TipoActividad.evento:
        return 'Evento';
      case TipoActividad.rutina:
        return 'Rutina';
      case TipoActividad.tareaMensual:
        return 'Tarea mensual';
    }
  }

  String _textoFecha(Actividad actividad) {
    switch (actividad.tipo) {
      case TipoActividad.tarea:
        if (actividad.fechaLimite == null) {
          return 'Sin fecha';
        }
        return 'Límite: ${_fechaFormato.format(actividad.fechaLimite!)}';
      case TipoActividad.recordatorio:
        if (actividad.fechaAviso == null) {
          return 'Sin aviso';
        }
        return 'Aviso: ${_fechaHoraFormato.format(actividad.fechaAviso!)}';
      case TipoActividad.evento:
        if (actividad.fechaInicio == null || actividad.fechaFin == null) {
          return 'Sin intervalo';
        }
        return 'Inicio: ${_fechaHoraFormato.format(actividad.fechaInicio!)} · '
            'Fin: ${_fechaHoraFormato.format(actividad.fechaFin!)}';
      case TipoActividad.rutina:
      case TipoActividad.tareaMensual:
        final orden = fechaOrdenacion(actividad);
        if (orden == null) {
          return 'Sin fecha';
        }
        return _fechaHoraFormato.format(orden);
    }
  }
}
