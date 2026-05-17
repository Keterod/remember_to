import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/core/errors/validation_exception.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_ocurrencia.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_repeticion.dart';
import 'package:remember_to/features/activities/domain/utils/repeticion_utils.dart';
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

  test('crear rutina válida', () async {
    final rutina = await repository.crearRutina(
      titulo: 'Ejercicio',
      diasSemana: [DateTime.monday, DateTime.wednesday],
    );

    expect(rutina.tipo, TipoActividad.rutina);
    expect(rutina.estado, EstadoActividad.pendiente);

    final repeticion =
        await repository.obtenerRepeticionPorActividadId(rutina.id);
    expect(repeticion!.tipo, TipoRepeticion.semanal);
    expect(repeticion.diasSemana, [DateTime.monday, DateTime.wednesday]);
    expect(repeticion.fechaInicio, isNotNull);
  });

  test('impide rutina sin título', () async {
    expect(
      () => repository.crearRutina(
        titulo: '  ',
        diasSemana: [DateTime.monday],
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('impide rutina sin días ni todos los días', () async {
    expect(
      () => repository.crearRutina(
        titulo: 'Rutina',
        diasSemana: [],
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('listar rutinas activas excluye eliminadas', () async {
    await repository.crearRutina(
      titulo: 'Visible',
      diasSemana: [DateTime.monday],
    );
    final borrar = await repository.crearRutina(
      titulo: 'Borrar',
      diasSemana: [DateTime.tuesday],
    );
    await repository.eliminarRutinaLogicamente(borrar.id);

    final rutinas = await repository.listarRutinasActivas();
    expect(rutinas, hasLength(1));
    expect(rutinas.first.titulo, 'Visible');
  });

  test('generar ocurrencia solo en día aplicable', () async {
    final rutina = await repository.crearRutina(
      titulo: 'Lunes',
      diasSemana: [DateTime.monday],
    );

    final lunes = DateTime(2026, 5, 18);
    final martes = DateTime(2026, 5, 19);

    expect(repeticionAplicaEnDia(
      (await repository.obtenerRepeticionPorActividadId(rutina.id))!,
      lunes,
    ), isTrue);
    expect(repeticionAplicaEnDia(
      (await repository.obtenerRepeticionPorActividadId(rutina.id))!,
      martes,
    ), isFalse);

    final occLunes = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: lunes,
    );
    expect(occLunes.estadoOcurrencia, EstadoOcurrencia.pendiente);

    final occMartes = await repository.obtenerOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: martes,
    );
    expect(occMartes, isNull);
  });

  test('completar ocurrencia no completa toda la rutina', () async {
    final rutina = await repository.crearRutina(
      titulo: 'Rutina',
      diasSemana: [DateTime.monday],
    );
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: DateTime(2026, 5, 18),
    );

    await repository.marcarOcurrenciaCompletada(ocurrencia.id);

    final rutinaActualizada = await repository.obtenerRutinaPorId(rutina.id);
    expect(rutinaActualizada!.estado, EstadoActividad.pendiente);

    final occActualizada = await repository.obtenerOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: DateTime(2026, 5, 18),
    );
    expect(occActualizada!.estadoOcurrencia, EstadoOcurrencia.completada);
  });

  test('incluir rutina en Hoy si aplica', () async {
    final dia = DateTime(2026, 5, 18, 10);
  await repository.crearRutina(
      titulo: 'Rutina hoy',
      diasSemana: [dia.weekday],
    );

    final hoy = await repository.listarParaHoy(dia);
    expect(hoy.any((e) => e.actividad.titulo == 'Rutina hoy'), isTrue);
  });

  test('ocurrencia completada no aparece en Vencidas', () async {
    final dia = DateTime(2026, 5, 10);
    final referencia = DateTime(2026, 5, 17, 12);
    final rutina = await repository.crearRutina(
      titulo: 'Rutina vencida',
      diasSemana: [dia.weekday],
    );
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: dia,
    );
    await repository.marcarOcurrenciaCompletada(ocurrencia.id);

    final vencidas = await repository.listarVencidas(referencia: referencia);
    expect(
      vencidas.any((e) => e.ocurrencia?.id == ocurrencia.id),
      isFalse,
    );
  });
}
