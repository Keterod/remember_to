import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/core/errors/validation_exception.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/entities/actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';

void main() {
  late AppDatabase database;
  late ActividadRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ActividadRepositoryImpl(
      database,
      FakeLocalNotificationsService(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  final inicio = DateTime(2026, 6, 1, 10);
  final fin = DateTime(2026, 6, 1, 12);

  test('crear evento válido con tipo evento', () async {
    final evento = await repository.crearEvento(
      titulo: 'Reunión',
      descripcion: 'Sprint planning',
      fechaInicio: inicio,
      fechaFin: fin,
      urgente: true,
    );

    expect(evento.tipo, TipoActividad.evento);
    expect(evento.titulo, 'Reunión');
    expect(evento.estado, EstadoActividad.pendiente);
    expect(evento.fechaInicio, inicio);
    expect(evento.fechaFin, fin);
    expect(evento.urgente, isTrue);
  });

  test('impide evento sin título', () async {
    expect(
      () => repository.crearEvento(
        titulo: '   ',
        fechaInicio: inicio,
        fechaFin: fin,
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('impide evento sin fechaInicio al editar', () async {
    final evento = await repository.crearEvento(
      titulo: 'Evento',
      fechaInicio: inicio,
      fechaFin: fin,
    );

    expect(
      () => repository.editarEvento(
        Actividad(
          id: evento.id,
          tipo: TipoActividad.evento,
          titulo: evento.titulo,
          estado: evento.estado,
          fechaFin: evento.fechaFin,
          createdAt: evento.createdAt,
          updatedAt: evento.updatedAt,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('impide evento sin fechaFin al editar', () async {
    final evento = await repository.crearEvento(
      titulo: 'Evento',
      fechaInicio: inicio,
      fechaFin: fin,
    );

    expect(
      () => repository.editarEvento(
        Actividad(
          id: evento.id,
          tipo: TipoActividad.evento,
          titulo: evento.titulo,
          estado: evento.estado,
          fechaInicio: evento.fechaInicio,
          createdAt: evento.createdAt,
          updatedAt: evento.updatedAt,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('impide evento con fechaFin antes de fechaInicio', () async {
    expect(
      () => repository.crearEvento(
        titulo: 'Evento',
        fechaInicio: fin,
        fechaFin: inicio,
      ),
      throwsA(
        predicate<ValidationException>(
          (e) => e.message.contains('posterior'),
        ),
      ),
    );
  });

  test('impide evento con fechaFin igual a fechaInicio', () async {
    expect(
      () => repository.crearEvento(
        titulo: 'Evento',
        fechaInicio: inicio,
        fechaFin: inicio,
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('listar eventos activos excluye eliminados', () async {
    await repository.crearEvento(
      titulo: 'Visible',
      fechaInicio: inicio,
      fechaFin: fin,
    );
    final eliminar = await repository.crearEvento(
      titulo: 'Borrar',
      fechaInicio: inicio,
      fechaFin: fin,
    );
    await repository.eliminarEventoLogicamente(eliminar.id);

    final eventos = await repository.listarEventosActivos();
    expect(eventos, hasLength(1));
    expect(eventos.first.titulo, 'Visible');
  });

  test('editar evento', () async {
    final evento = await repository.crearEvento(
      titulo: 'Original',
      fechaInicio: inicio,
      fechaFin: fin,
    );

    final nuevoFin = DateTime(2026, 6, 1, 14);
    await repository.editarEvento(
      evento.copyWith(
        titulo: 'Actualizado',
        fechaFin: nuevoFin,
      ),
    );

    final actualizado = await repository.obtenerEventoPorId(evento.id);
    expect(actualizado!.titulo, 'Actualizado');
    expect(actualizado.fechaFin, nuevoFin);
  });

  test('eliminar evento lógicamente con deletedAt', () async {
    final evento = await repository.crearEvento(
      titulo: 'Eliminar',
      fechaInicio: inicio,
      fechaFin: fin,
    );

    await repository.eliminarEventoLogicamente(evento.id);

    expect(await repository.obtenerEventoPorId(evento.id), isNull);
    expect(await repository.listarEventosActivos(), isEmpty);
  });
}
