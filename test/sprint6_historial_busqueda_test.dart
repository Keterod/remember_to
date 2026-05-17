import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/enums/accion_historial.dart';
import 'package:remember_to/features/activities/domain/utils/elemento_vista_temporal_utils.dart';
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

  test('registra historial al crear tarea', () async {
    await repository.crearTarea(titulo: 'Nueva tarea');
    final historial = await repository.listarHistorialReciente();
    expect(historial.first.accion, AccionHistorial.creada);
    expect(historial.first.detalle, 'Nueva tarea');
  });

  test('registra historial al editar y reprogramar tarea', () async {
    final tarea = await repository.crearTarea(
      titulo: 'Con fecha',
      fechaLimite: DateTime(2026, 6, 1),
    );
    await repository.editarTarea(
      tarea.copyWith(fechaLimite: DateTime(2026, 6, 10)),
    );
    final historial = await repository.listarHistorialReciente();
    expect(
      historial.any((h) => h.accion == AccionHistorial.editada),
      isTrue,
    );
    expect(
      historial.any((h) => h.accion == AccionHistorial.reprogramada),
      isTrue,
    );
  });

  test('registra historial al eliminar tarea', () async {
    final tarea = await repository.crearTarea(titulo: 'Borrar');
    await repository.eliminarLogicamente(tarea.id);
    final historial = await repository.listarHistorialReciente();
    expect(
      historial.any((h) => h.accion == AccionHistorial.eliminada),
      isTrue,
    );
    expect(historial.first.actividadId, tarea.id);
  });

  test('registra historial al completar y volver a pendiente', () async {
    final tarea = await repository.crearTarea(titulo: 'Estado');
    await repository.marcarCompletada(tarea.id);
    await repository.marcarPendiente(tarea.id);
    final filas = await database.select(database.historialActividades).get();
    final acciones = filas.map((r) => r.accion).toList();
    expect(acciones, contains('completada'));
    expect(acciones, contains('marcadaPendiente'));
  });

  test('registra historial al completar ocurrencia de rutina', () async {
    final dia = DateTime(2026, 6, 2);
    final rutina = await repository.crearRutina(
      titulo: 'Rutina',
      diasSemana: [dia.weekday],
    );
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: dia,
    );
    await repository.marcarOcurrenciaCompletada(ocurrencia.id);
    await repository.marcarOcurrenciaPendiente(ocurrencia.id);

    final filas = await database.select(database.historialActividades).get();
    final acciones = filas.map((r) => r.accion).toList();
    expect(acciones, contains('ocurrenciaCompletada'));
    expect(acciones, contains('ocurrenciaPendiente'));
  });

  test('actividad reciente ordenada por fecha desc', () async {
    await repository.crearTarea(titulo: 'Primera');
    await repository.crearTarea(titulo: 'Segunda');
    final historial = await repository.listarHistorialReciente();
    expect(historial.first.detalle, 'Segunda');
    expect(
      historial.every((h) => h.accion != AccionHistorial.ocurrenciaCompletada),
      isTrue,
    );
  });

  test('buscar por título y descripción excluye eliminadas', () async {
    await repository.crearTarea(
      titulo: 'Comprar leche',
      descripcion: 'Supermercado',
    );
    final borrar = await repository.crearTarea(titulo: 'Comprar pan');
    await repository.eliminarLogicamente(borrar.id);

    final porTitulo = await repository.buscarActividadesActivas('leche');
    final porDescripcion =
        await repository.buscarActividadesActivas('supermercado');
    final pan = await repository.buscarActividadesActivas('pan');

    expect(porTitulo, hasLength(1));
    expect(porDescripcion, hasLength(1));
    expect(pan, isEmpty);
  });

  test('próximas excluye vencidas y ordena por fecha', () async {
    final referencia = DateTime(2026, 6, 10, 12);
    await repository.crearTarea(
      titulo: 'Futura tarde',
      fechaLimite: DateTime(2026, 6, 11, 18),
    );
    await repository.crearTarea(
      titulo: 'Futura mañana',
      fechaLimite: DateTime(2026, 6, 11, 8),
    );
    await repository.crearTarea(
      titulo: 'Vencida',
      fechaLimite: DateTime(2026, 6, 9),
    );

    final proximas = await repository.listarProximas(referencia: referencia);

    expect(proximas.any((e) => e.actividad.titulo == 'Vencida'), isFalse);
    expect(proximas, hasLength(2));
    expect(proximas.first.actividad.titulo, 'Futura mañana');
  });

  test('vencidas no incluye sin fecha ni completadas', () async {
    final referencia = DateTime(2026, 6, 10, 12);
    await repository.crearTarea(titulo: 'Sin fecha');
    await repository.crearTarea(
      titulo: 'Ayer',
      fechaLimite: DateTime(2026, 6, 9),
    );
    final completada = await repository.crearTarea(
      titulo: 'Completada ayer',
      fechaLimite: DateTime(2026, 6, 8),
    );
    await repository.marcarCompletada(completada.id);

    final vencidas = await repository.listarVencidas(referencia: referencia);

    expect(vencidas.any((e) => e.actividad.titulo == 'Sin fecha'), isFalse);
    expect(vencidas.any((e) => e.actividad.titulo == 'Completada ayer'), isFalse);
    expect(vencidas.any((e) => e.actividad.titulo == 'Ayer'), isTrue);
    expect(
      vencidas.every((e) => esElementoVencido(e, referencia)),
      isTrue,
    );
  });

  test('próximas no duplica ocurrencias de rutina', () async {
    final referencia = DateTime(2026, 6, 2, 8);
    final rutina = await repository.crearRutina(
      titulo: 'Diaria',
      diasSemana: [DateTime.monday],
      todosLosDias: true,
    );
    final proximas = await repository.listarProximas(referencia: referencia);
    final deRutina = proximas.where((e) => e.actividad.id == rutina.id);
    final claves = deRutina
        .map((e) => e.ocurrencia?.fechaProgramada.toIso8601String())
        .toSet();
    expect(claves.length, deRutina.length);
  });
}
