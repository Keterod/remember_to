import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_ocurrencia.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/shared/services/notifications/notification_action_executor.dart';
import 'package:remember_to/shared/services/notifications/notification_action_ids.dart';
import 'package:remember_to/shared/services/notifications/notification_constants.dart';
import 'package:remember_to/shared/services/notifications/notification_payload.dart';
import 'package:remember_to/shared/services/notifications/notification_scheduler.dart';
import 'package:remember_to/shared/services/notifications/notification_slot.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  late AppDatabase database;
  late FakeLocalNotificationsService notifications;
  late ActividadRepositoryImpl repository;
  late NotificationScheduler scheduler;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    notifications = FakeLocalNotificationsService();
    repository = ActividadRepositoryImpl(database, notifications);
    scheduler = NotificationScheduler(notifications);
  });

  tearDown(() async {
    await database.close();
  });

  test('payload codifica y decodifica actividad y ocurrencia', () {
    const payload = NotificationPayload(
      actividadId: 'a1',
      ocurrenciaId: 'o1',
      tipo: TipoActividad.rutina,
    );
    final decoded = NotificationPayload.fromJsonString(payload.toJsonString());
    expect(decoded?.actividadId, 'a1');
    expect(decoded?.ocurrenciaId, 'o1');
    expect(decoded?.tipo, TipoActividad.rutina);
  });

  test('payload inválido no rompe', () {
    expect(NotificationPayload.fromJsonString('{}'), isNull);
    expect(NotificationPayload.fromJsonString(null), isNull);
  });

  test('recordatorio programa principal anticipado y repeticiones', () async {
    final futuro = DateTime.now().add(const Duration(hours: 2));
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Llamar',
      fechaAviso: futuro,
    );

    final delRecordatorio = notifications.findByActividadId(recordatorio.id);
    expect(delRecordatorio, isNotEmpty);
    expect(
      delRecordatorio.any((n) => n.payload.slot == NotificationSlot.principal),
      isTrue,
    );
    expect(
      delRecordatorio.any((n) => n.payload.slot == NotificationSlot.anticipada),
      isTrue,
    );
    expect(
      delRecordatorio
          .where((n) => n.payload.slot == NotificationSlot.repeticion)
          .length,
      NotificationConstants.maxRepeticiones,
    );
    final repeticiones = delRecordatorio
        .where((n) => n.payload.slot == NotificationSlot.repeticion);
    expect(repeticiones.every((n) => n.includeActions), isTrue);
  });

  test('tarea con fecha límite programa aviso anticipado', () async {
    final limite = DateTime.now().add(const Duration(days: 1));
    final tarea = await repository.crearTarea(
      titulo: 'Entrega',
      fechaLimite: limite,
    );

    expect(
      notifications.findByActividadId(tarea.id).any(
            (n) => n.payload.slot == NotificationSlot.anticipada,
          ),
      isTrue,
    );
  });

  test('no programa si falta fecha', () async {
    final tarea = await repository.crearTarea(titulo: 'Sin fecha');
    expect(notifications.findByActividadId(tarea.id), isEmpty);
  });

  test('completar actividad desde acción cancela notificaciones', () async {
    final futuro = DateTime.now().add(const Duration(hours: 1));
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Completar',
      fechaAviso: futuro,
    );
    expect(notifications.findByActividadId(recordatorio.id), isNotEmpty);

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotificationAction,
        actionId: NotificationActionIds.completar,
        payload: NotificationPayload(
          actividadId: recordatorio.id,
          tipo: TipoActividad.recordatorio,
        ).toJsonString(),
      ),
    );

    final actualizado = await repository.obtenerRecordatorioPorId(recordatorio.id);
    expect(actualizado?.estado, EstadoActividad.completada);
    expect(notifications.findByActividadId(recordatorio.id), isEmpty);
  });

  test('completar ocurrencia desde acción', () async {
    final dia = DateTime.now().add(const Duration(days: 1));
    final rutina = await repository.crearRutina(
      titulo: 'Rutina',
      diasSemana: [dia.weekday],
    );
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: dia,
    );

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotificationAction,
        actionId: NotificationActionIds.completar,
        payload: NotificationPayload(
          actividadId: rutina.id,
          ocurrenciaId: ocurrencia.id,
          tipo: TipoActividad.rutina,
        ).toJsonString(),
      ),
    );

    final occ = await repository.obtenerOcurrenciaPorId(ocurrencia.id);
    expect(occ?.estadoOcurrencia, EstadoOcurrencia.completada);
  });

  test('posponer recordatorio reprograma fecha', () async {
    final futuro = DateTime.now().add(const Duration(minutes: 5));
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Posponer',
      fechaAviso: futuro,
    );

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotificationAction,
        actionId: NotificationActionIds.posponer30,
        payload: NotificationPayload(
          actividadId: recordatorio.id,
          tipo: TipoActividad.recordatorio,
        ).toJsonString(),
      ),
    );

    final actualizado = await repository.obtenerRecordatorioPorId(recordatorio.id);
    expect(actualizado?.fechaAviso!.isAfter(futuro), isTrue);
  });

  test('actividad eliminada no rompe callback de completar', () async {
    final futuro = DateTime.now().add(const Duration(hours: 1));
    final tarea = await repository.crearTarea(
      titulo: 'Borrada',
      fechaLimite: futuro,
    );
    await repository.eliminarLogicamente(tarea.id);

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotificationAction,
        actionId: NotificationActionIds.completar,
        payload: NotificationPayload(
          actividadId: tarea.id,
          tipo: TipoActividad.tarea,
        ).toJsonString(),
      ),
    );
  });

  test('completar desde repetición cancela avisos futuros', () async {
    final futuro = DateTime.now().add(const Duration(hours: 1));
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Repetición',
      fechaAviso: futuro,
    );
    expect(
      notifications.scheduled
          .where((n) => n.payload.slot == NotificationSlot.repeticion)
          .length,
      NotificationConstants.maxRepeticiones,
    );

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: NotificationResponse(
        notificationResponseType:
            NotificationResponseType.selectedNotificationAction,
        actionId: NotificationActionIds.completar,
        payload: NotificationPayload(
          actividadId: recordatorio.id,
          tipo: TipoActividad.recordatorio,
          slot: NotificationSlot.repeticion,
          repeatAttempt: 1,
        ).toJsonString(),
      ),
    );

    expect(notifications.findByActividadId(recordatorio.id), isEmpty);
    final actualizado =
        await repository.obtenerRecordatorioPorId(recordatorio.id);
    expect(actualizado?.estado, EstadoActividad.completada);
  });

  test('anticipado calculado antes de fecha principal', () {
    final principal = DateTime(2026, 8, 1, 12);
    final anticipado =
        principal.subtract(NotificationConstants.anticipadoRecordatorio);
    expect(anticipado.isBefore(principal), isTrue);
  });
}
