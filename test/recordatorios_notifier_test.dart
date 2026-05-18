import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/application/providers/actividad_repository_provider.dart';
import 'package:remember_to/features/activities/application/providers/recordatorios_provider.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/shared/services/notifications/local_notifications_provider.dart';

void main() {
  late AppDatabase database;
  late FakeLocalNotificationsService notifications;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    notifications = FakeLocalNotificationsService();
    notifications.permissionsGranted = true;
    container = ProviderContainer(
      overrides: [
        localNotificationsServiceProvider.overrideWithValue(notifications),
        actividadRepositoryProvider.overrideWithValue(
          ActividadRepositoryImpl(database, notifications),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('crearRecordatorio termina y actualiza la lista', () async {
    final notifier = container.read(recordatoriosProvider.notifier);
    await container.read(recordatoriosProvider.future);

    final fechaAviso = DateTime.now().add(const Duration(days: 1));

    await notifier.crearRecordatorio(
      titulo: 'Recordatorio notifier',
      fechaAviso: fechaAviso,
    );

    final estado = container.read(recordatoriosProvider);
    expect(estado.hasValue, isTrue);
    expect(estado.value, hasLength(1));
    expect(estado.value!.first.titulo, 'Recordatorio notifier');
  });

  test('crearRecordatorio no deja el provider colgado en loading', () async {
    final notifier = container.read(recordatoriosProvider.notifier);
    await container.read(recordatoriosProvider.future);

    await notifier.crearRecordatorio(
      titulo: 'Sin auto-invalidar',
      fechaAviso: DateTime.now().add(const Duration(days: 2)),
    );

    final estado = container.read(recordatoriosProvider);
    expect(estado.isLoading, isFalse);
    expect(estado.hasError, isFalse);
    expect(estado.hasValue, isTrue);
  });
}
