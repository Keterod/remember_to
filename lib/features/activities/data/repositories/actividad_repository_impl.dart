import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/enums/tipo_actividad.dart';
import '../../domain/repositories/actividad_repository.dart';
import '../local/database.dart';
import '../mappers/actividad_mapper.dart';

class ActividadRepositoryImpl implements ActividadRepository {
  ActividadRepositoryImpl(this._database);

  final AppDatabase _database;
  static const _uuid = Uuid();

  @override
  Future<List<Actividad>> obtenerActivas() async {
    final query = _database.select(_database.actividades)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  @override
  Future<List<Actividad>> listarTareasActivas() async {
    final query = _database.select(_database.actividades)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.tipo.equals(TipoActividad.tarea.storageValue),
      )
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

  @override
  Future<Actividad> crearTarea({
    required String titulo,
    String? descripcion,
    DateTime? fechaLimite,
    bool urgente = false,
  }) async {
    final tituloNormalizado = titulo.trim();
    if (tituloNormalizado.isEmpty) {
      throw const ValidationException('El título de la tarea es obligatorio.');
    }

    final ahora = DateTime.now();
    final tarea = Actividad(
      id: _uuid.v4(),
      tipo: TipoActividad.tarea,
      titulo: tituloNormalizado,
      descripcion: _descripcionNormalizada(descripcion),
      estado: EstadoActividad.pendiente,
      urgente: urgente,
      fechaLimite: fechaLimite,
      createdAt: ahora,
      updatedAt: ahora,
    );

    await guardar(tarea);
    return tarea;
  }

  @override
  Future<void> editarTarea(Actividad tarea) async {
    _validarTarea(tarea);

    final existente = await obtenerPorId(tarea.id);
    if (existente == null) {
      throw const ValidationException('La tarea no existe o fue eliminada.');
    }
    if (existente.tipo != TipoActividad.tarea) {
      throw const ValidationException('Solo se pueden editar tareas.');
    }

    final actualizada = Actividad(
      id: tarea.id,
      tipo: TipoActividad.tarea,
      titulo: tarea.titulo.trim(),
      descripcion: _descripcionNormalizada(tarea.descripcion),
      estado: tarea.estado,
      urgente: tarea.urgente,
      fechaLimite: tarea.fechaLimite,
      fechaInicio: tarea.fechaInicio,
      fechaFin: tarea.fechaFin,
      fechaAviso: tarea.fechaAviso,
      createdAt: existente.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: existente.deletedAt,
    );

    await guardar(actualizada);
  }

  @override
  Future<void> marcarCompletada(String id) async {
    await _actualizarEstado(id, EstadoActividad.completada);
  }

  @override
  Future<void> marcarPendiente(String id) async {
    await _actualizarEstado(id, EstadoActividad.pendiente);
  }

  @override
  Future<void> eliminarLogicamente(String id) async {
    final tarea = await _obtenerTarea(id);
    final ahora = DateTime.now();
    await guardar(
      Actividad(
        id: tarea.id,
        tipo: tarea.tipo,
        titulo: tarea.titulo,
        descripcion: tarea.descripcion,
        estado: tarea.estado,
        urgente: tarea.urgente,
        fechaLimite: tarea.fechaLimite,
        fechaInicio: tarea.fechaInicio,
        fechaFin: tarea.fechaFin,
        fechaAviso: tarea.fechaAviso,
        createdAt: tarea.createdAt,
        updatedAt: ahora,
        deletedAt: ahora,
      ),
    );
  }

  Future<void> _actualizarEstado(String id, EstadoActividad estado) async {
    final tarea = await _obtenerTarea(id);
    await guardar(
      Actividad(
        id: tarea.id,
        tipo: tarea.tipo,
        titulo: tarea.titulo,
        descripcion: tarea.descripcion,
        estado: estado,
        urgente: tarea.urgente,
        fechaLimite: tarea.fechaLimite,
        fechaInicio: tarea.fechaInicio,
        fechaFin: tarea.fechaFin,
        fechaAviso: tarea.fechaAviso,
        createdAt: tarea.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: tarea.deletedAt,
      ),
    );
  }

  Future<Actividad> _obtenerTarea(String id) async {
    final tarea = await obtenerPorId(id);
    if (tarea == null) {
      throw const ValidationException('La tarea no existe o fue eliminada.');
    }
    if (tarea.tipo != TipoActividad.tarea) {
      throw const ValidationException('Solo se pueden modificar tareas.');
    }
    return tarea;
  }

  void _validarTarea(Actividad tarea) {
    if (tarea.tipo != TipoActividad.tarea) {
      throw const ValidationException(
        'No se puede guardar una actividad sin tipo tarea.',
      );
    }
    if (tarea.titulo.trim().isEmpty) {
      throw const ValidationException('El título de la tarea es obligatorio.');
    }
    if (tarea.estado != EstadoActividad.pendiente &&
        tarea.estado != EstadoActividad.completada) {
      throw const ValidationException('Estado de tarea no válido.');
    }
  }

  String? _descripcionNormalizada(String? descripcion) {
    if (descripcion == null) {
      return null;
    }
    final valor = descripcion.trim();
    return valor.isEmpty ? null : valor;
  }
}
