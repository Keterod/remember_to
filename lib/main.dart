import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/time/timezone_setup.dart';
import 'features/activities/application/providers/invalidar_vistas_temporales.dart';
import 'shared/services/notifications/local_notifications_provider.dart';
// Import explícito: conserva onBackgroundNotificationResponse en release.
// ignore: unused_import
import 'shared/services/notifications/notification_action_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocalTimezone();

  final container = ProviderContainer();
  await container.read(localNotificationsServiceProvider).initialize();
  configurarRefrescoTrasNotificacion(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const RememberToApp(),
    ),
  );
}
