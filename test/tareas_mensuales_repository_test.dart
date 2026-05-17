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

  test('crear tarea mensual válida', () async {
    final tarea = await repository.crearTareaMensual(
      titulo: 'Pagar alquiler',
      diaMes: 5,
    );

    expect(tarea.tipo, TipoActividad.tareaMensual);
    final repeticion =
        await repository.obtenerRepeticionPorActividadId(tarea.id);
    expect(repeticion!.tipo, TipoRepeticion.mensual);
    expect(repeticion.diaMes, 5);
    expect(repeticion.fechaInicio, isNotNull);
  });

  test('impide tarea mensual sin título', () async {
    expect(
      () => repository.crearTareaMensual(titulo: ' ', diaMes: 10),
      throwsA(isA<ValidationException>()),
    );
  });

  test('impide tarea mensual sin día del mes válido', () async {
    expect(
      () => repository.crearTareaMensual(titulo: 'Tarea', diaMes: 0),
      throwsA(isA<ValidationException>()),
    );
  });

  test('listar tareas mensuales activas', () async {
    await repository.crearTareaMensual(titulo: 'Una', diaMes: 1);
    final tareas = await repository.listarTareasMensualesActivas();
    expect(tareas, hasLength(1));
  });

  test('generar ocurrencia mensual con regla día 31 en febrero', () async {
    final tarea = await repository.crearTareaMensual(
      titulo: 'Fin de mes',
      diaMes: 31,
    );
    final repeticion =
        await repository.obtenerRepeticionPorActividadId(tarea.id);

    final fechaFeb = fechaMensualProgramada(2026, 2, repeticion!.diaMes!);
    expect(fechaFeb, DateTime(2026, 2, 28));

    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: tarea.id,
      dia: fechaFeb,
    );
    expect(ocurrencia.fechaProgramada, fechaFeb);
  });

  test('completar ocurrencia mensual no elimina la repetición', () async {
    final tarea = await repository.crearTareaMensual(
      titulo: 'Mensual',
      diaMes: 15,
    );
    final ocurrencia = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: tarea.id,
      dia: DateTime(2026, 5, 15),
    );
    await repository.marcarOcurrenciaCompletada(ocurrencia.id);

    final tareaActualizada =
        await repository.obtenerTareaMensualPorId(tarea.id);
    expect(tareaActualizada!.estado, EstadoActividad.pendiente);

    final repeticion =
        await repository.obtenerRepeticionPorActividadId(tarea.id);
    expect(repeticion, isNotNull);

    final siguienteMes = await repository.obtenerOCrearOcurrenciaParaDia(
      actividadId: tarea.id,
      dia: DateTime(2026, 6, 15),
    );
    expect(
      siguienteMes.estadoOcurrencia,
      EstadoOcurrencia.pendiente,
    );
  });

  test('incluir tarea mensual en Hoy', () async {
    final hoy = DateTime(2026, 5, 31, 12);
    await repository.crearTareaMensual(titulo: 'Pago', diaMes: 31);

    final elementos = await repository.listarParaHoy(hoy);
    expect(elementos.any((e) => e.actividad.titulo == 'Pago'), isTrue);
  });
}
