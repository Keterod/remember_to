import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/services/notifications/notification_ids.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../../../shared/services/notifications/local_notifications_service.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/enums/tipo_actividad.dart';
import '../../domain/repositories/actividad_repository.dart';
import '../../domain/utils/actividad_temporal.dart';
import '../../domain/utils/actividad_vencimiento.dart';
import '../local/database.dart';
import '../mappers/actividad_mapper.dart';

class ActividadRepositoryImpl implements ActividadRepository {
  ActividadRepositoryImpl(this._database, this._notifications);

  final AppDatabase _database;
  final LocalNotificationsService _notifications;
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
  Future<List<Actividad>> listarRecordatoriosActivos() async {
    final query = _database.select(_database.actividades)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.tipo.equals(TipoActividad.recordatorio.storageValue),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.fechaAviso)]);

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
  Future<Actividad?> obtenerRecordatorioPorId(String id) async {
    final recordatorio = await obtenerPorId(id);
    if (recordatorio == null) {
      return null;
    }
    if (recordatorio.tipo != TipoActividad.recordatorio) {
      throw const ValidationException('El registro no es un recordatorio.');
    }
    return recordatorio;
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
  Future<Actividad> crearRecordatorio({
    required String titulo,
    String? descripcion,
    required DateTime fechaAviso,
    bool urgente = false,
  }) async {
    _validarDatosRecordatorio(
      titulo: titulo,
      fechaAviso: fechaAviso,
    );

    final ahora = DateTime.now();
    final recordatorio = Actividad(
      id: _uuid.v4(),
      tipo: TipoActividad.recordatorio,
      titulo: titulo.trim(),
      descripcion: _descripcionNormalizada(descripcion),
      estado: EstadoActividad.pendiente,
      urgente: urgente,
      fechaAviso: fechaAviso,
      createdAt: ahora,
      updatedAt: ahora,
    );

    await guardar(recordatorio);
    await _sincronizarNotificacionRecordatorio(recordatorio);
    return recordatorio;
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
  Future<void> editarRecordatorio(Actividad recordatorio) async {
    _validarRecordatorio(recordatorio);

    final existente = await obtenerRecordatorioPorId(recordatorio.id);
    if (existente == null) {
      throw const ValidationException(
        'El recordatorio no existe o fue eliminado.',
      );
    }

    final actualizado = Actividad(
      id: recordatorio.id,
      tipo: TipoActividad.recordatorio,
      titulo: recordatorio.titulo.trim(),
      descripcion: _descripcionNormalizada(recordatorio.descripcion),
      estado: recordatorio.estado,
      urgente: recordatorio.urgente,
      fechaAviso: recordatorio.fechaAviso,
      createdAt: existente.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: existente.deletedAt,
    );

    await guardar(actualizado);
    await _sincronizarNotificacionRecordatorio(actualizado);
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

  @override
  Future<Actividad> crearEvento({
    required String titulo,
    String? descripcion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    bool urgente = false,
  }) async {
    _validarDatosEvento(
      titulo: titulo,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );

    final ahora = DateTime.now();
    final evento = Actividad(
      id: _uuid.v4(),
      tipo: TipoActividad.evento,
      titulo: titulo.trim(),
      descripcion: _descripcionNormalizada(descripcion),
      estado: EstadoActividad.pendiente,
      urgente: urgente,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      createdAt: ahora,
      updatedAt: ahora,
    );

    await guardar(evento);
    return evento;
  }

  @override
  Future<List<Actividad>> listarEventosActivos() async {
    final query = _database.select(_database.actividades)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.tipo.equals(TipoActividad.evento.storageValue),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.fechaInicio)]);

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  @override
  Future<Actividad?> obtenerEventoPorId(String id) async {
    final evento = await obtenerPorId(id);
    if (evento == null) {
      return null;
    }
    if (evento.tipo != TipoActividad.evento) {
      throw const ValidationException('El registro no es un evento.');
    }
    return evento;
  }

  @override
  Future<void> editarEvento(Actividad evento) async {
    _validarEvento(evento);

    final existente = await obtenerEventoPorId(evento.id);
    if (existente == null) {
      throw const ValidationException('El evento no existe o fue eliminado.');
    }

    final actualizado = Actividad(
      id: evento.id,
      tipo: TipoActividad.evento,
      titulo: evento.titulo.trim(),
      descripcion: _descripcionNormalizada(evento.descripcion),
      estado: evento.estado,
      urgente: evento.urgente,
      fechaInicio: evento.fechaInicio,
      fechaFin: evento.fechaFin,
      createdAt: existente.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: existente.deletedAt,
    );

    await guardar(actualizado);
  }

  @override
  Future<void> eliminarEventoLogicamente(String id) async {
    final evento = await _obtenerEvento(id);
    final ahora = DateTime.now();
    await guardar(
      Actividad(
        id: evento.id,
        tipo: evento.tipo,
        titulo: evento.titulo,
        descripcion: evento.descripcion,
        estado: evento.estado,
        urgente: evento.urgente,
        fechaInicio: evento.fechaInicio,
        fechaFin: evento.fechaFin,
        createdAt: evento.createdAt,
        updatedAt: ahora,
        deletedAt: ahora,
      ),
    );
  }

  @override
  Future<void> marcarEventoCompletada(String id) async {
    await _actualizarEstadoEvento(id, EstadoActividad.completada);
  }

  @override
  Future<void> marcarEventoPendiente(String id) async {
    await _actualizarEstadoEvento(id, EstadoActividad.pendiente);
  }

  @override
  Future<List<Actividad>> listarParaHoy(DateTime dia) async {
    final activas = await _listarActivasVistasTemporales();
    final delDia = activas.where((a) => correspondeAlDia(a, dia)).toList();
    delDia.sort(compararPorFechaOrdenacion);
    return delDia;
  }

  @override
  Future<List<Actividad>> listarProximas({DateTime? referencia}) async {
    final ahora = referencia ?? DateTime.now();
    final activas = await _listarActivasVistasTemporales();
    final futuras = activas
        .where(
          (a) =>
              a.estado == EstadoActividad.pendiente &&
              esActividadFutura(a, ahora),
        )
        .toList();
    futuras.sort(compararPorFechaOrdenacion);
    return futuras;
  }

  @override
  Future<List<Actividad>> listarVencidas({DateTime? referencia}) async {
    final ahora = referencia ?? DateTime.now();
    final activas = await _listarActivasVistasTemporales();
    final vencidas =
        activas.where((a) => esActividadVencida(a, ahora)).toList();
    vencidas.sort(compararPorFechaOrdenacion);
    return vencidas;
  }

  @override
  Future<List<Actividad>> listarPorRangoFechas({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final activas = await _listarActivasVistasTemporales();
    final enRango =
        activas.where((a) => intersectaRango(a, inicio, fin)).toList();
    enRango.sort(compararPorFechaOrdenacion);
    return enRango;
  }

  @override
  Future<void> eliminarRecordatorioLogicamente(String id) async {
    final recordatorio = await _obtenerRecordatorio(id);
    await _notifications.cancelReminderNotification(recordatorio.id);

    final ahora = DateTime.now();
    await guardar(
      Actividad(
        id: recordatorio.id,
        tipo: recordatorio.tipo,
        titulo: recordatorio.titulo,
        descripcion: recordatorio.descripcion,
        estado: recordatorio.estado,
        urgente: recordatorio.urgente,
        fechaAviso: recordatorio.fechaAviso,
        createdAt: recordatorio.createdAt,
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

  Future<void> _sincronizarNotificacionRecordatorio(Actividad recordatorio) async {
    final ahora = DateTime.now();
    await _notifications.cancelReminderNotification(recordatorio.id);

    if (recordatorio.fechaAviso == null) {
      if (kDebugMode) {
        debugPrint(
          '[Notif] omitir ${recordatorio.id}: sin fechaAviso',
        );
      }
      return;
    }

    if (!recordatorio.fechaAviso!.isAfter(ahora)) {
      if (kDebugMode) {
        debugPrint(
          '[Notif] omitir ${recordatorio.id}: fechaAviso en pasado '
          '(${recordatorio.fechaAviso})',
        );
      }
      return;
    }

    final permisos = await _notifications.areNotificationsEnabled();
    if (!permisos) {
      if (kDebugMode) {
        debugPrint(
          '[Notif] omitir ${recordatorio.id}: permisos de notificación no activos',
        );
      }
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[Notif] sincronizar ${recordatorio.id} '
        'notifId=${notificationIdForActividad(recordatorio.id)} '
        'fechaAviso=${recordatorio.fechaAviso}',
      );
    }

    await _notifications.scheduleReminderNotification(
      actividadId: recordatorio.id,
      title: recordatorio.titulo,
      body: recordatorio.descripcion,
      scheduledDate: recordatorio.fechaAviso!,
    );
    // El resultado (exacto/inexacto) queda disponible vía el servicio para la UI.
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

  Future<List<Actividad>> _listarActivasVistasTemporales() async {
    final tipos = [
      TipoActividad.tarea.storageValue,
      TipoActividad.recordatorio.storageValue,
      TipoActividad.evento.storageValue,
    ];
    final query = _database.select(_database.actividades)
      ..where(
        (row) => row.deletedAt.isNull() & row.tipo.isIn(tipos),
      );

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  Future<void> _actualizarEstadoEvento(
    String id,
    EstadoActividad estado,
  ) async {
    final evento = await _obtenerEvento(id);
    await guardar(
      Actividad(
        id: evento.id,
        tipo: evento.tipo,
        titulo: evento.titulo,
        descripcion: evento.descripcion,
        estado: estado,
        urgente: evento.urgente,
        fechaInicio: evento.fechaInicio,
        fechaFin: evento.fechaFin,
        createdAt: evento.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: evento.deletedAt,
      ),
    );
  }

  Future<Actividad> _obtenerEvento(String id) async {
    final evento = await obtenerEventoPorId(id);
    if (evento == null) {
      throw const ValidationException('El evento no existe o fue eliminado.');
    }
    return evento;
  }

  Future<Actividad> _obtenerRecordatorio(String id) async {
    final recordatorio = await obtenerRecordatorioPorId(id);
    if (recordatorio == null) {
      throw const ValidationException(
        'El recordatorio no existe o fue eliminado.',
      );
    }
    return recordatorio;
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

  void _validarRecordatorio(Actividad recordatorio) {
    if (recordatorio.tipo != TipoActividad.recordatorio) {
      throw const ValidationException(
        'No se puede guardar una actividad sin tipo recordatorio.',
      );
    }
    _validarDatosRecordatorio(
      titulo: recordatorio.titulo,
      fechaAviso: recordatorio.fechaAviso,
    );
    if (recordatorio.estado != EstadoActividad.pendiente &&
        recordatorio.estado != EstadoActividad.completada) {
      throw const ValidationException('Estado de recordatorio no válido.');
    }
  }

  void _validarDatosRecordatorio({
    required String titulo,
    required DateTime? fechaAviso,
  }) {
    if (titulo.trim().isEmpty) {
      throw const ValidationException(
        'El título del recordatorio es obligatorio.',
      );
    }
    if (fechaAviso == null) {
      throw const ValidationException(
        'La fecha y hora de aviso son obligatorias.',
      );
    }
  }

  void _validarEvento(Actividad evento) {
    if (evento.tipo != TipoActividad.evento) {
      throw const ValidationException(
        'No se puede guardar una actividad sin tipo evento.',
      );
    }
    _validarDatosEvento(
      titulo: evento.titulo,
      fechaInicio: evento.fechaInicio,
      fechaFin: evento.fechaFin,
    );
    if (evento.estado != EstadoActividad.pendiente &&
        evento.estado != EstadoActividad.completada) {
      throw const ValidationException('Estado de evento no válido.');
    }
  }

  void _validarDatosEvento({
    required String titulo,
    required DateTime? fechaInicio,
    required DateTime? fechaFin,
  }) {
    if (titulo.trim().isEmpty) {
      throw const ValidationException('El título del evento es obligatorio.');
    }
    if (fechaInicio == null) {
      throw const ValidationException(
        'La fecha y hora de inicio son obligatorias.',
      );
    }
    if (fechaFin == null) {
      throw const ValidationException(
        'La fecha y hora de fin son obligatorias.',
      );
    }
    if (!fechaFin.isAfter(fechaInicio)) {
      throw const ValidationException(
        'La fecha de fin debe ser posterior a la de inicio.',
      );
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
