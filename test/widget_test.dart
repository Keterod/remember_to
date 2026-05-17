import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/app/app.dart';

void main() {
  testWidgets('RememberToApp muestra pantalla inicial', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: RememberToApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remember To.App'), findsOneWidget);
    expect(find.text('Base local lista. Sprint 1.'), findsOneWidget);
  });
}
