import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/application/providers/actividad_repository_provider.dart';
import 'package:remember_to/features/activities/application/providers/busqueda_provider.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';

void main() {
  late AppDatabase database;
  late ActividadRepositoryImpl repository;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ActividadRepositoryImpl(
      database,
      FakeLocalNotificationsService(),
    );
    container = ProviderContainer(
      overrides: [
        actividadRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('provider actualiza resultados al cambiar consulta sin buscar manual', () async {
    await repository.crearTarea(
      titulo: 'Comprar leche',
      descripcion: 'Supermercado',
    );

    container.read(busquedaConsultaProvider.notifier).state = 'le';
    final parcial = await container.read(busquedaActividadesProvider.future);
    expect(parcial, hasLength(1));

    container.read(busquedaConsultaProvider.notifier).state = 'leche';
    final completo = await container.read(busquedaActividadesProvider.future);
    expect(completo.first.titulo, 'Comprar leche');
  });

  test('consulta vacía limpia resultados', () async {
    await repository.crearTarea(titulo: 'Tarea visible');

    container.read(busquedaConsultaProvider.notifier).state = 'visible';
    expect(
      await container.read(busquedaActividadesProvider.future),
      hasLength(1),
    );

    container.read(busquedaConsultaProvider.notifier).state = '';
    expect(
      await container.read(busquedaActividadesProvider.future),
      isEmpty,
    );
  });

  test('resultados incluyen id y tipo para navegación', () async {
    final tarea = await repository.crearTarea(titulo: 'Navegable');

    container.read(busquedaConsultaProvider.notifier).state = 'nave';
    final resultados = await container.read(busquedaActividadesProvider.future);

    expect(resultados.single.id, tarea.id);
    expect(resultados.single.tipo, TipoActividad.tarea);
    expect(resultados.single.tipo.rutaEdicion(tarea.id), isNotNull);
  });

  test('buscar por descripción vía provider', () async {
    await repository.crearTarea(
      titulo: 'Compras',
      descripcion: 'Frutas frescas',
    );

    container.read(busquedaConsultaProvider.notifier).state = 'frutas';
    final resultados = await container.read(busquedaActividadesProvider.future);
    expect(resultados, hasLength(1));
  });
}
