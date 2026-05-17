import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/mappers/ocurrencia_mapper.dart';
import 'package:remember_to/features/activities/data/mappers/repeticion_mapper.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/entities/ocurrencia_actividad.dart';
import 'package:remember_to/features/activities/domain/entities/repeticion.dart';
import 'package:remember_to/features/activities/domain/enums/estado_ocurrencia.dart';
import 'package:remember_to/features/activities/domain/utils/actividad_temporal.dart';
import 'package:remember_to/features/activities/domain/utils/ocurrencia_vencimiento.dart';
import 'package:remember_to/features/activities/domain/utils/repeticion_utils.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';

Future<void> fijarInicioActividadRecurrente({
  required ActividadRepositoryImpl repository,
  required AppDatabase database,
  required String actividadId,
  required DateTime inicio,
}) async {
  final actividad = await repository.obtenerPorId(actividadId);
  await repository.guardar(
    actividad!.copyWith(createdAt: inicio, updatedAt: inicio),
  );
  final repeticion = await repository.obtenerRepeticionPorActividadId(actividadId);
  await database.into(database.repeticiones).insertOnConflictUpdate(
        RepeticionMapper.toCompanion(
          Repeticion(
            id: repeticion!.id,
            actividadId: repeticion.actividadId,
            tipo: repeticion.tipo,
            intervalo: repeticion.intervalo,
            diasSemana: repeticion.diasSemana,
            diaMes: repeticion.diaMes,
            fechaInicio: inicio,
            fechaFin: repeticion.fechaFin,
            reglaTexto: repeticion.reglaTexto,
          ),
        ),
      );
}

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

  test('rutina creada hoy no aparece en Vencidas con días anteriores', () async {
    final hoy = DateTime(2026, 5, 17, 12);
    final rutina = await repository.crearRutina(
      titulo: 'Nueva rutina',
      diasSemana: [hoy.weekday],
      todosLosDias: true,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: rutina.id,
      inicio: hoy,
    );

    final vencidas = await repository.listarVencidas(referencia: hoy);

    expect(
      vencidas.where((e) => e.actividad.id == rutina.id),
      isEmpty,
    );
  });

  test('rutina aplicable hoy aparece en Hoy y no en Vencidas el mismo día', () async {
    final hoy = DateTime(2026, 5, 17, 10);
    final rutina = await repository.crearRutina(
      titulo: 'Rutina hoy',
      diasSemana: [hoy.weekday],
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: rutina.id,
      inicio: hoy,
    );

    final hoyLista = await repository.listarParaHoy(hoy);
    final vencidas = await repository.listarVencidas(referencia: hoy);

    expect(hoyLista.any((e) => e.actividad.id == rutina.id), isTrue);
    expect(vencidas.any((e) => e.actividad.id == rutina.id), isFalse);
  });

  test('rutina pendiente de ayer aparece en Vencidas al día siguiente', () async {
    final ayer = DateTime(2026, 5, 16);
    final hoy = DateTime(2026, 5, 17, 10);
    final rutina = await repository.crearRutina(
      titulo: 'Rutina ayer',
      diasSemana: [DateTime.monday],
      todosLosDias: true,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: rutina.id,
      inicio: ayer,
    );

    final vencidas = await repository.listarVencidas(referencia: hoy);
    final deRutina = vencidas.where((e) => e.actividad.id == rutina.id).toList();

    expect(deRutina, hasLength(1));
    expect(
      inicioDelDia(fechaEfectivaOcurrencia(deRutina.single.ocurrencia!)),
      inicioDelDia(ayer),
    );
  });

  test('rutina creada hace 3 días no genera vencidas anteriores a createdAt', () async {
    final inicio = DateTime(2026, 5, 14);
    final referencia = DateTime(2026, 5, 17, 10);
    final rutina = await repository.crearRutina(
      titulo: 'Rutina 3 días',
      diasSemana: [DateTime.monday],
      todosLosDias: true,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: rutina.id,
      inicio: inicio,
    );

    final vencidas = await repository.listarVencidas(referencia: referencia);
    final fechas = vencidas
        .where((e) => e.actividad.id == rutina.id)
        .map((e) => inicioDelDia(fechaEfectivaOcurrencia(e.ocurrencia!)))
        .toList();

    expect(fechas.every((f) => !f.isBefore(inicioDelDia(inicio))), isTrue);
    expect(fechas.any((f) => f == inicioDelDia(DateTime(2026, 5, 13))), isFalse);
  });

  test('tarea mensual creada hoy no muestra meses anteriores en Vencidas', () async {
    final hoy = DateTime(2026, 5, 17, 10);
    final tarea = await repository.crearTareaMensual(
      titulo: 'Mensual nueva',
      diaMes: 17,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: tarea.id,
      inicio: hoy,
    );

    final vencidas = await repository.listarVencidas(referencia: hoy);

    expect(
      vencidas.where((e) => e.actividad.id == tarea.id),
      isEmpty,
    );
  });

  test('tarea mensual día 31 respeta febrero sin vencidas antes de fecha mínima', () async {
    final inicio = DateTime(2026, 3, 1);
    final referencia = DateTime(2026, 3, 2, 10);
    final tarea = await repository.crearTareaMensual(
      titulo: 'Fin de mes',
      diaMes: 31,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: tarea.id,
      inicio: inicio,
    );

    final repeticion =
        await repository.obtenerRepeticionPorActividadId(tarea.id);
    final fechaFeb = fechaMensualProgramada(2026, 2, repeticion!.diaMes!);
    expect(fechaFeb, DateTime(2026, 2, 28));

    final vencidas = await repository.listarVencidas(referencia: referencia);
    final deTarea = vencidas.where((e) => e.actividad.id == tarea.id);

    expect(deTarea, isEmpty);
  });

  test('Vencidas ignora ocurrencias en BD anteriores a fecha mínima', () async {
    final inicio = DateTime(2026, 5, 17);
    final referencia = DateTime(2026, 5, 20, 10);
    final rutina = await repository.crearRutina(
      titulo: 'Con basura en BD',
      diasSemana: [DateTime.monday],
      todosLosDias: true,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: rutina.id,
      inicio: inicio,
    );
    final repeticion =
        await repository.obtenerRepeticionPorActividadId(rutina.id);
    final diaAntiguo = DateTime(2026, 5, 10);
    final fechaProg = fechaProgramadaParaDia(repeticion!, diaAntiguo);

    await database.into(database.ocurrenciasActividades).insert(
          OcurrenciaMapper.toCompanion(
            OcurrenciaActividad(
              id: 'antigua',
              actividadId: rutina.id,
              fechaProgramada: fechaProg,
              estadoOcurrencia: EstadoOcurrencia.pendiente,
              createdAt: diaAntiguo,
              updatedAt: diaAntiguo,
            ),
          ),
        );

    final vencidas = await repository.listarVencidas(referencia: referencia);
    final fechas = vencidas
        .where((e) => e.actividad.id == rutina.id)
        .map((e) => inicioDelDia(fechaEfectivaOcurrencia(e.ocurrencia!)))
        .toList();

    expect(fechas.any((f) => f == inicioDelDia(diaAntiguo)), isFalse);
    expect(fechas.every((f) => !f.isBefore(inicioDelDia(inicio))), isTrue);
  });

  test('listarVencidas no crea filas nuevas en ocurrencias_actividades', () async {
    final inicio = DateTime(2026, 5, 1);
    final referencia = DateTime(2026, 5, 20, 10);
    final rutina = await repository.crearRutina(
      titulo: 'Sin persistir vencidas',
      diasSemana: [DateTime.monday],
      todosLosDias: true,
    );
    await fijarInicioActividadRecurrente(
      repository: repository,
      database: database,
      actividadId: rutina.id,
      inicio: inicio,
    );

    await repository.listarVencidas(referencia: referencia);

    final filas = await (database.select(database.ocurrenciasActividades)
          ..where((row) => row.actividadId.equals(rutina.id)))
        .get();
    expect(filas, isEmpty);
  });
}
