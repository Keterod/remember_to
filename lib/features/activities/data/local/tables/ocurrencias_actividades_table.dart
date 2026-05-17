import 'package:drift/drift.dart';

@DataClassName('OcurrenciaActividadLocal')
class OcurrenciasActividades extends Table {
  TextColumn get id => text()();
  TextColumn get actividadId => text()();
  DateTimeColumn get fechaProgramada => dateTime()();
  TextColumn get estadoOcurrencia => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get skippedAt => dateTime().nullable()();
  DateTimeColumn get postponedTo => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
