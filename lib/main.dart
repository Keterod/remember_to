import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/time/timezone_setup.dart';
import 'shared/services/notifications/local_notifications_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocalTimezone();

  final container = ProviderContainer();
  await container.read(localNotificationsServiceProvider).initialize();
  container.dispose();

  runApp(
    const ProviderScope(
      child: RememberToApp(),
    ),
  );
}
