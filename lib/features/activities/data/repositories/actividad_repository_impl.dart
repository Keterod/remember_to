import 'package:drift/drift.dart';

import '../../domain/entities/actividad.dart';
import '../../domain/repositories/actividad_repository.dart';
import '../local/database.dart';
import '../mappers/actividad_mapper.dart';

class ActividadRepositoryImpl implements ActividadRepository {
  ActividadRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<Actividad>> obtenerActivas() async {
    final query = _database.select(_database.actividades)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  @override
  Future<Actividad?> obtenerPorId(String id) async {
    final query = _database.select(_database.actividades)
      ..where((row) => row.id.equals(id) & row.deletedAt.isNull());

    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }
    return ActividadMapper.toDomain(row);
  }

  @override
  Future<void> guardar(Actividad actividad) async {
    await _database.into(_database.actividades).insertOnConflictUpdate(
          ActividadMapper.toCompanion(actividad),
        );
  }
}
