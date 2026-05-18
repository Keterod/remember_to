import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../features/activities/data/local/database.dart';
import '../../../features/activities/data/repositories/actividad_repository_impl.dart';
import '../../../features/activities/domain/enums/estado_actividad.dart';
import '../../../features/activities/domain/enums/estado_ocurrencia.dart';
import '../../../features/activities/domain/enums/tipo_actividad.dart';
import '../../../features/activities/domain/repositories/actividad_repository.dart';
import 'flutter_local_notifications_service.dart';
import 'notification_action_ids.dart';
import 'notification_payload.dart';
import 'notification_refresh_signal.dart';
import 'notification_scheduler.dart';

/// Ejecuta acciones de notificación sin depender de [BuildContext] ni Riverpod.
class NotificationActionExecutor {
  NotificationActionExecutor._();

  static final NotificationActionExecutor instance =
      NotificationActionExecutor._();

  static void Function()? onActionHandled;

  Future<void> handle(NotificationResponse response) async {
    AppDatabase? database;
    try {
      database = AppDatabase();
      final notifications = FlutterLocalNotificationsService();
      await notifications.initialize();
      final repository = ActividadRepositoryImpl(database, notifications);
      final scheduler = NotificationScheduler(notifications);

      await runWith(
        repository: repository,
        scheduler: scheduler,
        response: response,
      );

      onActionHandled?.call();
      notifyNotificationDataChanged();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[NotifAction] executor error: $error');
        debugPrint('$stackTrace');
      }
      rethrow;
    } finally {
      await database?.close();
    }
  }

  Future<void> runWith({
    required ActividadRepository repository,
    required NotificationScheduler scheduler,
    required NotificationResponse response,
  }) async {
    final payload = NotificationPayload.fromJsonString(response.payload);
    if (payload == null) {
      return;
    }

    final actionId = response.actionId;
    if (actionId == null || actionId.isEmpty) {
      return;
    }

    switch (actionId) {
      case NotificationActionIds.completar:
        await _completar(repository, scheduler, payload);
      case NotificationActionIds.posponer10:
        await _posponer(repository, scheduler, payload, 10);
      case NotificationActionIds.posponer30:
        await _posponer(repository, scheduler, payload, 30);
      case NotificationActionIds.posponer60:
        await _posponer(repository, scheduler, payload, 60);
      default:
        break;
    }
  }

  Future<void> _completar(
    ActividadRepository repository,
    NotificationScheduler scheduler,
    NotificationPayload payload,
  ) async {
    if (payload.esOcurrencia) {
      final ocurrencia =
          await repository.obtenerOcurrenciaPorId(payload.ocurrenciaId!);
      if (ocurrencia == null ||
          ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada) {
        return;
      }
      await repository.marcarOcurrenciaCompletada(ocurrencia.id);
      await scheduler.cancelarActividad(
        actividadId: payload.actividadId,
        ocurrenciaId: payload.ocurrenciaId,
      );
      return;
    }

    final actividad = await repository.obtenerPorId(payload.actividadId);
    if (actividad == null || actividad.deletedAt != null) {
      return;
    }
    if (actividad.estado == EstadoActividad.completada) {
      return;
    }

    switch (actividad.tipo) {
      case TipoActividad.tarea:
        await repository.marcarCompletada(actividad.id);
      case TipoActividad.recordatorio:
        await repository.marcarRecordatorioCompletada(actividad.id);
      case TipoActividad.evento:
        await repository.marcarEventoCompletada(actividad.id);
      case TipoActividad.rutina:
      case TipoActividad.tareaMensual:
        return;
    }
    await scheduler.cancelarActividad(actividadId: payload.actividadId);
  }

  Future<void> _posponer(
    ActividadRepository repository,
    NotificationScheduler scheduler,
    NotificationPayload payload,
    int minutos,
  ) async {
    final delta = Duration(minutes: minutos);
    final nuevaFecha = DateTime.now().add(delta);

    if (payload.esOcurrencia) {
      final ocurrencia =
          await repository.obtenerOcurrenciaPorId(payload.ocurrenciaId!);
      if (ocurrencia == null) {
        return;
      }
      if (ocurrencia.estadoOcurrencia == EstadoOcurrencia.completada) {
        return;
      }
      await repository.marcarOcurrenciaPospuesta(
        ocurrenciaId: ocurrencia.id,
        postponedTo: nuevaFecha,
      );
      final actividad = await repository.obtenerPorId(payload.actividadId);
      if (actividad != null) {
        final actualizada = await repository.obtenerOcurrenciaPorId(
          ocurrencia.id,
        );
        if (actualizada != null) {
          await scheduler.sincronizarOcurrencia(
            actividad: actividad,
            ocurrencia: actualizada,
          );
        }
      }
      return;
    }

    final actividad = await repository.obtenerPorId(payload.actividadId);
    if (actividad == null || actividad.deletedAt != null) {
      return;
    }
    if (actividad.estado == EstadoActividad.completada) {
      return;
    }

    final actualizada = switch (actividad.tipo) {
      TipoActividad.recordatorio => actividad.copyWith(fechaAviso: nuevaFecha),
      TipoActividad.evento => actividad.copyWith(fechaInicio: nuevaFecha),
      TipoActividad.tarea => actividad.copyWith(fechaLimite: nuevaFecha),
      TipoActividad.rutina || TipoActividad.tareaMensual => null,
    };

    if (actualizada == null) {
      return;
    }

    switch (actividad.tipo) {
      case TipoActividad.recordatorio:
        await repository.editarRecordatorio(actualizada);
      case TipoActividad.evento:
        await repository.editarEvento(actualizada);
      case TipoActividad.tarea:
        await repository.editarTarea(actualizada);
      case TipoActividad.rutina:
      case TipoActividad.tareaMensual:
        break;
    }
    await scheduler.sincronizarActividad(actualizada);
  }
}
