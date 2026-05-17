import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/actividad_repository_impl.dart';
import '../../domain/repositories/actividad_repository.dart';
import 'database_provider.dart';

final actividadRepositoryProvider = Provider<ActividadRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ActividadRepositoryImpl(database);
});
