import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/actividades_table.dart';
import 'tables/ocurrencias_actividades_table.dart';
import 'tables/repeticiones_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Actividades, Repeticiones, OcurrenciasActividades])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(repeticiones);
            await m.createTable(ocurrenciasActividades);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'remember_to_db');
  }
}
