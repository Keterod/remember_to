import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/notifications/local_notifications_provider.dart';
import '../../data/repositories/actividad_repository_impl.dart';
import '../../domain/repositories/actividad_repository.dart';
import 'database_provider.dart';

final actividadRepositoryProvider = Provider<ActividadRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final notifications = ref.watch(localNotificationsServiceProvider);
  return ActividadRepositoryImpl(database, notifications);
});
