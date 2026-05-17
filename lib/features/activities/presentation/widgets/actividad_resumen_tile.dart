import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/entities/elemento_vista_temporal.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/enums/estado_ocurrencia.dart';
import '../../domain/enums/tipo_actividad.dart';
import '../../domain/utils/actividad_temporal.dart';
import '../../domain/utils/elemento_vista_temporal_utils.dart';
import '../../domain/utils/ocurrencia_vencimiento.dart';

/// Fila reutilizable para vistas temporales (Hoy, Próximas, Vencidas, etc.).
class ActividadResumenTile extends StatelessWidget {
  const ActividadResumenTile({
    super.key,
    required this.elemento,
    this.onTap,
    this.mostrarVencida = true,
  });

  final ElementoVistaTemporal elemento;
  final VoidCallback? onTap;
  final bool mostrarVencida;

  static final _fechaFormato = DateFormat('dd/MM/yyyy');
  static final _fechaHoraFormato = DateFormat('dd/MM/yyyy HH:mm');

  Actividad get actividad => elemento.actividad;

  @override
  Widget build(BuildContext context) {
    final completada = _estaCompletada();
    final vencida =
        mostrarVencida && esElementoVencido(elemento, DateTime.now());

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
          _textoFecha(),
          if (vencida) 'Vencida',
        ].join(' · '),
        style: vencida && !completada
            ? TextStyle(color: Theme.of(context).colorScheme.error)
            : null,
      ),
      isThreeLine: false,
    );
  }

  bool _estaCompletada() {
    final ocurrencia = elemento.ocurrencia;
    if (ocurrencia != null) {
      return ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada;
    }
    return actividad.estado == EstadoActividad.completada;
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

  String _textoFecha() {
    final ocurrencia = elemento.ocurrencia;
    if (ocurrencia != null) {
      return 'Programada: ${_fechaFormato.format(fechaEfectivaOcurrencia(ocurrencia))}';
    }

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
