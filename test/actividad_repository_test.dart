import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/features/activities/domain/entities/actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';

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

  test('guardar y consultar una actividad de prueba', () async {
    final now = DateTime(2026, 5, 16, 10);
    const uuid = Uuid();
    final actividad = Actividad(
      id: uuid.v4(),
      tipo: TipoActividad.tarea,
      titulo: 'Actividad de prueba',
      descripcion: 'Descripción de prueba',
      estado: EstadoActividad.pendiente,
      urgente: true,
      fechaLimite: DateTime(2026, 5, 20),
      createdAt: now,
      updatedAt: now,
    );

    await repository.guardar(actividad);

    final guardada = await repository.obtenerPorId(actividad.id);
    expect(guardada, isNotNull);
    expect(guardada!.titulo, 'Actividad de prueba');
    expect(guardada.tipo, TipoActividad.tarea);
    expect(guardada.estado, EstadoActividad.pendiente);
    expect(guardada.urgente, isTrue);

    final activas = await repository.obtenerActivas();
    expect(activas, hasLength(1));
  });
}
