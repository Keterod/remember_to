import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_ocurrencia.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/shared/services/notifications/notification_action_executor.dart';
import 'package:remember_to/shared/services/notifications/notification_action_handler.dart';
import 'package:remember_to/shared/services/notifications/notification_action_ids.dart';
import 'package:remember_to/shared/services/notifications/notification_payload.dart';
import 'package:remember_to/shared/services/notifications/notification_scheduler.dart';

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
    NotificationActionExecutor.onActionHandled = null;
  });

  tearDown(() async {
    await database.close();
  });

  NotificationResponse response({
    required String actionId,
    String? payload,
  }) {
    return NotificationResponse(
      notificationResponseType:
          NotificationResponseType.selectedNotificationAction,
      actionId: actionId,
      payload: payload,
    );
  }

  test('dispatch con completar ejecuta marcarRecordatorioCompletada', () async {
    final futuro = DateTime.now().add(const Duration(hours: 1));
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Completar handler',
      fechaAviso: futuro,
    );

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: response(
        actionId: NotificationActionIds.completar,
        payload: NotificationPayload(
          actividadId: recordatorio.id,
          tipo: TipoActividad.recordatorio,
        ).toJsonString(),
      ),
    );

    final actualizado =
        await repository.obtenerRecordatorioPorId(recordatorio.id);
    expect(actualizado?.estado, EstadoActividad.completada);
  });

  test('dispatch con posponer_10 actualiza fechaAviso', () async {
    final futuro = DateTime.now().add(const Duration(minutes: 5));
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Posponer handler',
      fechaAviso: futuro,
    );

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: response(
        actionId: NotificationActionIds.posponer10,
        payload: NotificationPayload(
          actividadId: recordatorio.id,
          tipo: TipoActividad.recordatorio,
        ).toJsonString(),
      ),
    );

    final actualizado =
        await repository.obtenerRecordatorioPorId(recordatorio.id);
    expect(actualizado?.fechaAviso!.isAfter(futuro), isTrue);
  });

  test('payload inválido en dispatch no rompe', () async {
    await expectLater(
      dispatchNotificationAction(
        response(
          actionId: NotificationActionIds.completar,
          payload: '{}',
        ),
      ),
      completes,
    );
  });

  test('completar ocurrencia no completa toda la rutina', () async {
    final dia = DateTime.now().add(const Duration(days: 1));
    final rutina = await repository.crearRutina(
      titulo: 'Rutina handler',
      diasSemana: [dia.weekday],
    );
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: dia,
    );

    await NotificationActionExecutor.instance.runWith(
      repository: repository,
      scheduler: scheduler,
      response: response(
        actionId: NotificationActionIds.completar,
        payload: NotificationPayload(
          actividadId: rutina.id,
          ocurrenciaId: ocurrencia.id,
          tipo: TipoActividad.rutina,
        ).toJsonString(),
      ),
    );

    final rutinaActual = await repository.obtenerRutinaPorId(rutina.id);
    expect(rutinaActual?.estado, isNot(EstadoActividad.completada));
    final occ = await repository.obtenerOcurrenciaPorId(ocurrencia.id);
    expect(occ?.estadoOcurrencia, EstadoOcurrencia.completada);
  });
}
