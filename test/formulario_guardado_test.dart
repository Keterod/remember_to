import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:remember_to/features/activities/application/providers/actividad_repository_provider.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';
import 'package:remember_to/features/activities/presentation/screens/recordatorio_form_screen.dart';
import 'package:remember_to/features/activities/presentation/screens/tarea_form_screen.dart';
import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/shared/services/notifications/local_notifications_provider.dart';

void main() {
  testWidgets('doble tap en Crear tarea solo registra una', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final notifications = FakeLocalNotificationsService();
    addTearDown(database.close);

    final repository = ActividadRepositoryImpl(database, notifications);

    final router = GoRouter(
      initialLocation: '/tareas/nuevo',
      routes: [
        GoRoute(
          path: '/tareas',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Lista tareas')),
          ),
          routes: [
            GoRoute(
              path: 'nuevo',
              builder: (context, state) => const TareaFormScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localNotificationsServiceProvider.overrideWithValue(notifications),
          actividadRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Título *'),
      'Tarea sin duplicar',
    );

    final botonCrear = find.widgetWithText(FilledButton, 'Crear tarea');
    await tester.tap(botonCrear);
    await tester.tap(botonCrear);
    await tester.pump();
    await tester.pumpAndSettle();

    final tareas = await repository.listarTareasActivas();
    expect(tareas, hasLength(1));
    expect(tareas.first.titulo, 'Tarea sin duplicar');
    expect(find.text('Lista tareas'), findsOneWidget);
  });

  testWidgets('validación fallida no cierra el formulario de tarea', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final notifications = FakeLocalNotificationsService();
    addTearDown(database.close);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TareaFormScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localNotificationsServiceProvider.overrideWithValue(notifications),
          actividadRepositoryProvider.overrideWithValue(
            ActividadRepositoryImpl(database, notifications),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Crear tarea'));
    await tester.pumpAndSettle();

    expect(find.byType(TareaFormScreen), findsOneWidget);
    expect(await ActividadRepositoryImpl(database, notifications).listarTareasActivas(), isEmpty);
  });

  testWidgets('doble tap en Crear recordatorio solo registra una', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final notifications = FakeLocalNotificationsService();
    notifications.permissionsGranted = true;
    addTearDown(database.close);

    final repository = ActividadRepositoryImpl(database, notifications);

    final router = GoRouter(
      initialLocation: '/recordatorios/nuevo',
      routes: [
        GoRoute(
          path: '/recordatorios',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Lista recordatorios')),
          ),
          routes: [
            GoRoute(
              path: 'nuevo',
              builder: (context, state) => const RecordatorioFormScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localNotificationsServiceProvider.overrideWithValue(notifications),
          actividadRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Título *'),
      'Recordatorio sin duplicar',
    );

    await tester.tap(find.byIcon(Icons.event));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final botonCrear =
        find.widgetWithText(FilledButton, 'Crear recordatorio');
    await tester.tap(botonCrear);
    await tester.tap(botonCrear);
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final recordatorios = await repository.listarRecordatoriosActivos();
    expect(recordatorios, hasLength(1));
    expect(recordatorios.first.titulo, 'Recordatorio sin duplicar');
    expect(find.text('Lista recordatorios'), findsOneWidget);
  });
}
