import 'package:drift/drift.dart';

/// Tabla local principal de actividades (Sprint 1).
@DataClassName('ActividadLocal')
class Actividades extends Table {
  TextColumn get id => text()();
  TextColumn get tipo => text()();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get estado => text()();
  BoolColumn get urgente =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get fechaLimite => dateTime().nullable()();
  DateTimeColumn get fechaInicio => dateTime().nullable()();
  DateTimeColumn get fechaFin => dateTime().nullable()();
  DateTimeColumn get fechaAviso => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
