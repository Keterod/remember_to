import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
