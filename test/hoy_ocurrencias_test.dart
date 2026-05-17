import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/mappers/ocurrencia_mapper.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/entities/ocurrencia_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_ocurrencia.dart';
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

  test('Hoy carga con rutina aplicable al día', () async {
    final dia = DateTime(2026, 6, 2, 10);
    await repository.crearRutina(
      titulo: 'Rutina hoy',
      diasSemana: [dia.weekday],
    );

    final elementos = await repository.listarParaHoy(dia);

    expect(elementos.any((e) => e.actividad.titulo == 'Rutina hoy'), isTrue);
  });

  test('Hoy carga con tarea mensual aplicable al día', () async {
    final dia = DateTime(2026, 5, 31, 10);
    await repository.crearTareaMensual(titulo: 'Pago mensual', diaMes: 31);

    final elementos = await repository.listarParaHoy(dia);

    expect(elementos.any((e) => e.actividad.titulo == 'Pago mensual'), isTrue);
  });

  test('Hoy no falla con ocurrencias duplicadas para misma actividad y día', () async {
    final dia = DateTime(2026, 6, 2, 10);
    final rutina = await repository.crearRutina(
      titulo: 'Duplicados',
      diasSemana: [dia.weekday],
    );
    final repeticion =
        await repository.obtenerRepeticionPorActividadId(rutina.id);
    final fechaProg = fechaProgramadaParaDia(repeticion!, dia);
    final ahora = DateTime.now();

    await database.into(database.ocurrenciasActividades).insert(
          OcurrenciaMapper.toCompanion(
            OcurrenciaActividad(
              id: 'dup-1',
              actividadId: rutina.id,
              fechaProgramada: fechaProg,
              estadoOcurrencia: EstadoOcurrencia.pendiente,
              createdAt: ahora,
              updatedAt: ahora,
            ),
          ),
        );
    await database.into(database.ocurrenciasActividades).insert(
          OcurrenciaMapper.toCompanion(
            OcurrenciaActividad(
              id: 'dup-2',
              actividadId: rutina.id,
              fechaProgramada: fechaProg,
              estadoOcurrencia: EstadoOcurrencia.pendiente,
              createdAt: ahora,
              updatedAt: ahora,
            ),
          ),
        );

    final elementos = await repository.listarParaHoy(dia);

    expect(
      elementos.where((e) => e.actividad.id == rutina.id),
      hasLength(1),
    );
  });

  test('obtenerOCrearOcurrenciaParaDia es idempotente', () async {
    final dia = DateTime(2026, 6, 2);
    final rutina = await repository.crearRutina(
      titulo: 'Idempotente',
      diasSemana: [dia.weekday],
    );

    final primera = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: dia,
    );
    final segunda = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: rutina.id,
      dia: dia,
    );

    expect(primera.id, segunda.id);

    final filas = await (database.select(database.ocurrenciasActividades)
          ..where((row) => row.actividadId.equals(rutina.id)))
        .get();
    expect(filas, hasLength(1));
  });
}
