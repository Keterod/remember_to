import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/features/activities/domain/utils/tarea_vencimiento.dart';

void main() {
  late AppDatabase database;
  late ActividadRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ActividadRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('crear tarea con tipo tarea y título obligatorio', () async {
    final tarea = await repository.crearTarea(
      titulo: 'Estudiar Flutter',
      descripcion: 'Capítulo 2',
      urgente: true,
    );

    expect(tarea.tipo, TipoActividad.tarea);
    expect(tarea.titulo, 'Estudiar Flutter');
    expect(tarea.estado, EstadoActividad.pendiente);
    expect(tarea.urgente, isTrue);
    expect(tarea.fechaLimite, isNull);
  });

  test('listar tareas activas excluye eliminadas y otros tipos', () async {
    await repository.crearTarea(titulo: 'Tarea visible');
    final otra = await repository.crearTarea(titulo: 'Tarea a eliminar');
    await repository.eliminarLogicamente(otra.id);

    final tareas = await repository.listarTareasActivas();
    expect(tareas, hasLength(1));
    expect(tareas.first.titulo, 'Tarea visible');
  });

  test('marcar tarea como completada y volver a pendiente', () async {
    final tarea = await repository.crearTarea(titulo: 'Tarea de estado');

    await repository.marcarCompletada(tarea.id);
    var actualizada = await repository.obtenerPorId(tarea.id);
    expect(actualizada!.estado, EstadoActividad.completada);

    await repository.marcarPendiente(tarea.id);
    actualizada = await repository.obtenerPorId(tarea.id);
    expect(actualizada!.estado, EstadoActividad.pendiente);
  });

  test('eliminar tarea lógicamente con deletedAt', () async {
    final tarea = await repository.crearTarea(titulo: 'Tarea eliminada');

    await repository.eliminarLogicamente(tarea.id);

    final eliminada = await repository.obtenerPorId(tarea.id);
    expect(eliminada, isNull);

    final activas = await repository.listarTareasActivas();
    expect(activas, isEmpty);
  });

  test('tarea sin fecha límite no es vencida', () async {
    final tarea = await repository.crearTarea(titulo: 'Sin fecha');
    final referencia = DateTime(2026, 12, 31);

    expect(esTareaVencida(tarea, referencia), isFalse);
  });

  test('tarea pendiente con fecha límite pasada es vencida calculada', () async {
    final tarea = await repository.crearTarea(
      titulo: 'Con fecha',
      fechaLimite: DateTime(2026, 5, 10),
    );
    final referencia = DateTime(2026, 5, 16);

    expect(esTareaVencida(tarea, referencia), isTrue);

    await repository.marcarCompletada(tarea.id);
    final completada = await repository.obtenerPorId(tarea.id);
    expect(esTareaVencida(completada!, referencia), isFalse);
  });
}
