import 'package:drift/drift.dart';

@DataClassName('HistorialActividadLocal')
class HistorialActividades extends Table {
  TextColumn get id => text()();
  TextColumn get actividadId => text().nullable()();
  TextColumn get ocurrenciaId => text().nullable()();
  TextColumn get accion => text()();
  TextColumn get detalle => text().nullable()();
  DateTimeColumn get fechaHora => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
