import 'package:flutter/foundation.dart';

import '../../../features/activities/domain/entities/actividad.dart';
import '../../../features/activities/domain/entities/ocurrencia_actividad.dart';
import '../../../features/activities/domain/enums/estado_actividad.dart';
import '../../../features/activities/domain/enums/estado_ocurrencia.dart';
import '../../../features/activities/domain/enums/tipo_actividad.dart';
import 'local_notifications_service.dart';
import 'notification_constants.dart';
import 'notification_payload.dart';
import 'notification_slot.dart';

/// Programa y cancela avisos según tipo de actividad u ocurrencia (Sprint 7).
class NotificationScheduler {
  NotificationScheduler(this._notifications);

  final LocalNotificationsService _notifications;

  Future<void> cancelarActividad({
    required String actividadId,
    String? ocurrenciaId,
  }) async {
    await _notifications.cancelActivityNotifications(
      actividadId: actividadId,
      ocurrenciaId: ocurrenciaId,
    );
  }

  Future<void> sincronizarActividad(Actividad actividad) async {
    await cancelarActividad(actividadId: actividad.id);
    if (actividad.deletedAt != null) {
      return;
    }
    if (actividad.estado == EstadoActividad.completada) {
      return;
    }

    final ahora = DateTime.now();
    switch (actividad.tipo) {
      case TipoActividad.recordatorio:
        await _programarRecordatorio(actividad, ahora);
      case TipoActividad.evento:
        await _programarEvento(actividad, ahora);
      case TipoActividad.tarea:
        await _programarTarea(actividad, ahora);
      case TipoActividad.rutina:
      case TipoActividad.tareaMensual:
        break;
    }
  }

  Future<void> sincronizarOcurrencia({
    required Actividad actividad,
    required OcurrenciaActividad ocurrencia,
  }) async {
    await cancelarActividad(
      actividadId: actividad.id,
      ocurrenciaId: ocurrencia.id,
    );

    if (actividad.deletedAt != null) {
      return;
    }
    if (ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada ||
        ocurrencia.estadoOcurrencia == EstadoOcurrencia.saltada) {
      return;
    }

    final fecha = ocurrencia.postponedTo ?? ocurrencia.fechaProgramada;
    final ahora = DateTime.now();
    if (!fecha.isAfter(ahora)) {
      return;
    }

    final payload = NotificationPayload(
      actividadId: actividad.id,
      ocurrenciaId: ocurrencia.id,
      tipo: actividad.tipo,
    );

    await _programarEn(
      payload: payload,
      titulo: actividad.titulo,
      cuerpo: actividad.descripcion,
      fecha: fecha,
      ahora: ahora,
      anticipado: null,
    );
  }

  Future<void> _programarRecordatorio(Actividad actividad, DateTime ahora) async {
    final fechaAviso = actividad.fechaAviso;
    if (fechaAviso == null || !fechaAviso.isAfter(ahora)) {
      return;
    }
    final payload = NotificationPayload(
      actividadId: actividad.id,
      tipo: TipoActividad.recordatorio,
    );
    await _programarEn(
      payload: payload,
      titulo: actividad.titulo,
      cuerpo: actividad.descripcion,
      fecha: fechaAviso,
      ahora: ahora,
      anticipado: fechaAviso.subtract(NotificationConstants.anticipadoRecordatorio),
    );
  }

  Future<void> _programarEvento(Actividad actividad, DateTime ahora) async {
    final inicio = actividad.fechaInicio;
    if (inicio == null || !inicio.isAfter(ahora)) {
      return;
    }
    final payload = NotificationPayload(
      actividadId: actividad.id,
      tipo: TipoActividad.evento,
    );
    await _programarEn(
      payload: payload,
      titulo: actividad.titulo,
      cuerpo: 'Inicio del evento',
      fecha: inicio,
      ahora: ahora,
      anticipado: inicio.subtract(NotificationConstants.anticipadoEvento),
    );
  }

  Future<void> _programarTarea(Actividad actividad, DateTime ahora) async {
    final limite = actividad.fechaLimite;
    if (limite == null || !limite.isAfter(ahora)) {
      return;
    }
    final payload = NotificationPayload(
      actividadId: actividad.id,
      tipo: TipoActividad.tarea,
    );
    await _programarEn(
      payload: payload,
      titulo: actividad.titulo,
      cuerpo: 'Fecha límite de la tarea',
      fecha: limite,
      ahora: ahora,
      anticipado: limite.subtract(NotificationConstants.anticipadoTarea),
    );
  }

  Future<void> _programarEn({
    required NotificationPayload payload,
    required String titulo,
    required String? cuerpo,
    required DateTime fecha,
    required DateTime ahora,
    required DateTime? anticipado,
  }) async {
    if (!(await _notifications.areNotificationsEnabled())) {
      if (kDebugMode) {
        debugPrint('[Notif] omitir ${payload.actividadId}: sin permisos');
      }
      return;
    }

    if (anticipado != null && anticipado.isAfter(ahora)) {
      await _notifications.scheduleActivityNotification(
        payload: payload.copyWith(slot: NotificationSlot.anticipada),
        title: 'Próximo: $titulo',
        body: cuerpo,
        scheduledDate: anticipado,
      );
    }

    await _notifications.scheduleActivityNotification(
      payload: payload,
      title: titulo,
      body: cuerpo,
      scheduledDate: fecha,
    );

    for (var i = 1; i <= NotificationConstants.maxRepeticiones; i++) {
      final repeticion = fecha.add(
        NotificationConstants.intervaloRepeticion * i,
      );
      if (!repeticion.isAfter(ahora)) {
        continue;
      }
      await _notifications.scheduleActivityNotification(
        payload: payload.copyWith(
          slot: NotificationSlot.repeticion,
          repeatAttempt: i,
        ),
        title: 'Pendiente: $titulo',
        body: 'Intento $i de ${NotificationConstants.maxRepeticiones}',
        scheduledDate: repeticion,
        includeActions: true,
      );
    }
  }
}
