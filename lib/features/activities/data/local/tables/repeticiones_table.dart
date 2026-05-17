import 'package:drift/drift.dart';

@DataClassName('RepeticionLocal')
class Repeticiones extends Table {
  TextColumn get id => text()();
  TextColumn get actividadId => text()();
  TextColumn get tipo => text()();
  IntColumn get intervalo =>
      integer().withDefault(const Constant(1))();
  TextColumn get diasSemana => text().nullable()();
  IntColumn get diaMes => integer().nullable()();
  DateTimeColumn get fechaInicio => dateTime().nullable()();
  DateTimeColumn get fechaFin => dateTime().nullable()();
  TextColumn get reglaTexto => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
