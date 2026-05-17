import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/core/errors/validation_exception.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/entities/actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';

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

    final programada = notifications.findByActividadId(recordatorio.id);
    expect(programada, isNotNull);
    expect(programada!.title, 'Llamar al médico');
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

    final programada = notifications.findByActividadId(recordatorio.id);
    expect(programada!.scheduledDate, nuevaFecha);
  });

  test('eliminar recordatorio lógicamente y cancelar notificación', () async {
    notifications.permissionsGranted = true;
    final recordatorio = await repository.crearRecordatorio(
      titulo: 'Eliminar',
      fechaAviso: DateTime.now().add(const Duration(hours: 3)),
    );

    expect(notifications.findByActividadId(recordatorio.id), isNotNull);

    await repository.eliminarRecordatorioLogicamente(recordatorio.id);

    expect(await repository.obtenerRecordatorioPorId(recordatorio.id), isNull);
    expect(notifications.findByActividadId(recordatorio.id), isNull);
  });

  test('obtenerRecordatorioPorId rechaza actividad que no es recordatorio', () async {
    final tarea = await repository.crearTarea(titulo: 'Solo tarea');

    expect(
      () => repository.obtenerRecordatorioPorId(tarea.id),
      throwsA(isA<ValidationException>()),
    );
  });
}
