import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/app/app.dart';
import 'package:remember_to/features/activities/application/providers/actividad_repository_provider.dart';
import 'package:remember_to/features/activities/data/local/database.dart';
import 'package:remember_to/features/activities/data/repositories/actividad_repository_impl.dart';

void main() {
  testWidgets('RememberToApp muestra lista de tareas', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          actividadRepositoryProvider.overrideWithValue(
            ActividadRepositoryImpl(database),
          ),
        ],
        child: const RememberToApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tareas'), findsOneWidget);
    expect(
      find.text('No hay tareas. Pulsa + para crear una.'),
      findsOneWidget,
    );
  });
}
