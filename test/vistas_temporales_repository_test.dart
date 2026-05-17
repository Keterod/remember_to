import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
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

  final hoy = DateTime(2026, 5, 17, 12);
  final inicioDia = DateTime(2026, 5, 17, 9);
  final finDia = DateTime(2026, 5, 17, 10);

  test('obtener actividades de Hoy', () async {
    await repository.crearTarea(
      titulo: 'Tarea hoy',
      fechaLimite: DateTime(2026, 5, 17),
    );
    await repository.crearTarea(
      titulo: 'Tarea mañana',
      fechaLimite: DateTime(2026, 5, 18),
    );
    await repository.crearRecordatorio(
      titulo: 'Recordatorio hoy',
      fechaAviso: DateTime(2026, 5, 17, 15),
    );
    await repository.crearEvento(
      titulo: 'Evento hoy',
      fechaInicio: inicioDia,
      fechaFin: finDia,
    );

    final delDia = await repository.listarParaHoy(hoy);

    expect(delDia.map((a) => a.titulo), containsAll(['Tarea hoy', 'Recordatorio hoy', 'Evento hoy']));
    expect(delDia.map((a) => a.titulo), isNot(contains('Tarea mañana')));
  });

  test('obtener próximas actividades ordenadas', () async {
    final referencia = DateTime(2026, 5, 17, 12);

    await repository.crearTarea(
      titulo: 'Tarea lejana',
      fechaLimite: DateTime(2026, 5, 20, 10),
    );
    await repository.crearTarea(
      titulo: 'Tarea cercana',
      fechaLimite: DateTime(2026, 5, 18, 8),
    );
    await repository.crearRecordatorio(
      titulo: 'Recordatorio futuro',
      fechaAviso: DateTime(2026, 5, 19, 9),
    );
    await repository.crearTarea(
      titulo: 'Tarea pasada',
      fechaLimite: DateTime(2026, 5, 16),
    );
    final completada = await repository.crearTarea(
      titulo: 'Tarea completada futura',
      fechaLimite: DateTime(2026, 5, 25),
    );
    await repository.marcarCompletada(completada.id);

    final proximas = await repository.listarProximas(referencia: referencia);

    expect(proximas.map((a) => a.titulo).toList(), [
      'Tarea cercana',
      'Recordatorio futuro',
      'Tarea lejana',
    ]);
  });

  test('calcular vencidas sin guardar estado vencida', () async {
    final referencia = DateTime(2026, 5, 17, 12);

    final vencida = await repository.crearTarea(
      titulo: 'Tarea vencida',
      fechaLimite: DateTime(2026, 5, 15),
    );
    await repository.crearRecordatorio(
      titulo: 'Recordatorio vencido',
      fechaAviso: DateTime(2026, 5, 16, 8),
    );
    await repository.crearEvento(
      titulo: 'Evento vencido',
      fechaInicio: DateTime(2026, 5, 15, 9),
      fechaFin: DateTime(2026, 5, 15, 10),
    );

    final vencidas = await repository.listarVencidas(referencia: referencia);

    expect(vencidas, hasLength(3));

    final persistida = await repository.obtenerPorId(vencida.id);
    expect(persistida!.estado, EstadoActividad.pendiente);
  });

  test('actividad sin fecha no aparece como vencida', () async {
    await repository.crearTarea(titulo: 'Sin fecha');
    final referencia = DateTime(2026, 5, 17, 12);

    final vencidas = await repository.listarVencidas(referencia: referencia);

    expect(vencidas, isEmpty);
  });

  test('consultar actividades por rango de fechas', () async {
    await repository.crearTarea(
      titulo: 'En rango',
      fechaLimite: DateTime(2026, 5, 18),
    );
    await repository.crearTarea(
      titulo: 'Fuera de rango',
      fechaLimite: DateTime(2026, 5, 25),
    );
    await repository.crearEvento(
      titulo: 'Evento cruzado',
      fechaInicio: DateTime(2026, 5, 17, 20),
      fechaFin: DateTime(2026, 5, 19, 8),
    );

    final enRango = await repository.listarPorRangoFechas(
      inicio: DateTime(2026, 5, 17),
      fin: DateTime(2026, 5, 19, 23, 59, 59, 999),
    );

    expect(enRango.map((a) => a.titulo), containsAll(['En rango', 'Evento cruzado']));
    expect(enRango.map((a) => a.titulo), isNot(contains('Fuera de rango')));
  });
}
