import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/core/errors/validation_exception.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/entities/actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/shared/services/notifications/notification_ids.dart';
import 'package:remember_to/shared/services/notifications/notification_slot.dart';

void main() {
  late AppDatabase database;
  late FakeLocalNotificationsService notifications;
  late ActividadRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    notifications = FakeLocalNotificationsService();
    repository = ActividadRepositoryImpl(database, notifications);
  });

  tearDown(() async {
    await database.close();
  });

  test('crear recordatorio válido con tipo recordatorio', () async {
    final fechaAviso = DateTime.now().add(const Duration(days: 1));
    notifications.permissionsGranted = true;

    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Llamar al médico',
      descripcion: 'Consulta',
      fechaAviso: fechaAviso,
      urgente: true,
    );

    expect(recordatorio.tipo, TipoActividad.recordatorio);
    expect(recordatorio.titulo, 'Llamar al médico');
    expect(recordatorio.fechaAviso, fechaAviso);
    expect(recordatorio.urgente, isTrue);

    final principal = notifications.findPrincipal(recordatorio.id);
    expect(principal, isNotNull);
    expect(principal!.title, 'Llamar al médico');
  });

  test('impide recordatorio sin título', () async {
    expect(
      () => repository.crearRecordatorio(
        titulo: '   ',
        fechaAviso: DateTime.now().add(const Duration(hours: 1)),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('impide recordatorio sin fechaAviso en edición', () async {
    final creado = await repository.crearRecordatorio(
      titulo: 'Recordatorio',
      fechaAviso: DateTime.now().add(const Duration(hours: 2)),
    );

    expect(
      () => repository.editarRecordatorio(
        Actividad(
          id: creado.id,
          tipo: TipoActividad.recordatorio,
          titulo: creado.titulo,
          estado: creado.estado,
          fechaAviso: null,
          createdAt: creado.createdAt,
          updatedAt: creado.updatedAt,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('listar recordatorios activos', () async {
    await repository.crearRecordatorio(
      titulo: 'Uno',
      fechaAviso: DateTime.now().add(const Duration(hours: 1)),
    );
    final dos = await repository.crearRecordatorio(
      titulo: 'Dos',
      fechaAviso: DateTime.now().add(const Duration(hours: 2)),
    );
    await repository.eliminarRecordatorioLogicamente(dos.id);

    final activos = await repository.listarRecordatoriosActivos();
    expect(activos, hasLength(1));
    expect(activos.first.titulo, 'Uno');
  });

  test('editar fechaAviso reprograma notificación', () async {
    notifications.permissionsGranted = true;
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Reprogramar',
      fechaAviso: DateTime.now().add(const Duration(hours: 1)),
    );

    final nuevaFecha = DateTime.now().add(const Duration(hours: 5));
    await repository.editarRecordatorio(
      recordatorio.copyWith(fechaAviso: nuevaFecha),
    );

    final principal = notifications.findPrincipal(recordatorio.id);
    expect(principal!.scheduledDate, nuevaFecha);
  });

  test('eliminar recordatorio lógicamente y cancelar notificación', () async {
    notifications.permissionsGranted = true;
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Eliminar',
      fechaAviso: DateTime.now().add(const Duration(hours: 3)),
    );

    expect(notifications.findPrincipal(recordatorio.id), isNotNull);

    await repository.eliminarRecordatorioLogicamente(recordatorio.id);

    expect(await repository.obtenerRecordatorioPorId(recordatorio.id), isNull);
    expect(notifications.findPrincipal(recordatorio.id), isNull);
  });

  test('dos recordatorios usan IDs de notificación distintos', () async {
    notifications.permissionsGranted = true;
    final futuro = DateTime.now().add(const Duration(hours: 1));

    final uno = await repository.crearRecordatorio(
      titulo: 'Uno',
      fechaAviso: futuro,
    );
    final dos = await repository.crearRecordatorio(
      titulo: 'Dos',
      fechaAviso: futuro.add(const Duration(minutes: 5)),
    );

    expect(
      notificationIdForActividad(uno.id),
      isNot(notificationIdForActividad(dos.id)),
    );
    final principales = notifications.scheduled
        .where((n) => n.payload.slot == NotificationSlot.principal)
        .length;
    expect(principales, greaterThanOrEqualTo(2));
  });

  test('eliminar un recordatorio no cancela el otro', () async {
    notifications.permissionsGranted = true;
    final futuro = DateTime.now().add(const Duration(hours: 2));

    final permanece = await repository.crearRecordatorio(
      titulo: 'Permanece',
      fechaAviso: futuro,
    );
    final eliminar = await repository.crearRecordatorio(
      titulo: 'Eliminar',
      fechaAviso: futuro.add(const Duration(minutes: 10)),
    );

    notifications.cancelCalls.clear();
    await repository.eliminarRecordatorioLogicamente(eliminar.id);

    expect(
      notifications.cancelCalls.any((c) => c.startsWith('${eliminar.id}|')),
      isTrue,
    );
    expect(notifications.findPrincipal(permanece.id), isNotNull);
    expect(notifications.findPrincipal(eliminar.id), isNull);
  });

  test('fechaAviso en pasado guarda recordatorio pero no programa notificación',
      () async {
    notifications.permissionsGranted = true;
    final pasado = DateTime.now().subtract(const Duration(minutes: 5));

    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Pasado',
      fechaAviso: pasado,
    );

    expect(await repository.obtenerRecordatorioPorId(recordatorio.id), isNotNull);
    expect(notifications.findPrincipal(recordatorio.id), isNull);
  });

  test('fechaAviso en futuro programa notificación', () async {
    notifications.permissionsGranted = true;
    final futuro = DateTime.now().add(const Duration(minutes: 10));

    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Futuro',
      fechaAviso: futuro,
    );

    final principal = notifications.findPrincipal(recordatorio.id);
    expect(principal, isNotNull);
    expect(principal!.scheduledDate, futuro);
  });

  test('obtenerRecordatorioPorId rechaza actividad que no es recordatorio', () async {
    final tarea = await repository.crearTarea(titulo: 'Solo tarea');

    expect(
      () => repository.obtenerRecordatorioPorId(tarea.id),
      throwsA(isA<ValidationException>()),
    );
  });
}
