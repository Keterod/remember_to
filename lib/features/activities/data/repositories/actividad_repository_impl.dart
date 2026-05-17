import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/services/notifications/notification_ids.dart';

import '../../../../core/errors/validation_exception.dart';
import '../../../../shared/services/notifications/local_notifications_service.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/entities/elemento_vista_temporal.dart';
import '../../domain/entities/ocurrencia_actividad.dart';
import '../../domain/entities/repeticion.dart';
import '../../domain/enums/estado_actividad.dart';
import '../../domain/enums/estado_ocurrencia.dart';
import '../../domain/enums/tipo_actividad.dart';
import '../../domain/enums/tipo_repeticion.dart';
import '../../domain/repositories/actividad_repository.dart';
import '../../domain/utils/actividad_temporal.dart';
import '../../domain/utils/actividad_vencimiento.dart';
import '../../domain/utils/elemento_vista_temporal_utils.dart';
import '../../domain/utils/ocurrencia_vencimiento.dart';
import '../../domain/utils/repeticion_utils.dart';
import '../local/database.dart';
import '../mappers/actividad_mapper.dart';
import '../mappers/ocurrencia_mapper.dart';
import '../mappers/repeticion_mapper.dart';

class ActividadRepositoryImpl implements ActividadRepository {
  ActividadRepositoryImpl(this.database, this._notifications);

  final AppDatabase database;
  final LocalNotificationsService _notifications;
  static const _uuid = Uuid();

  @override
  Future<List<Actividad>> obtenerActivas() async {
    final query = database.select(database.actividades)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  @override
  Future<List<Actividad>> listarTareasActivas() async {
    final query = database.select(database.actividades)
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
    final query = database.select(database.actividades)
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
    final query = database.select(database.actividades)
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
    await database.into(database.actividades).insertOnConflictUpdate(
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
    final query = database.select(database.actividades)
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
  Future<Actividad> crearRutina({
    required String titulo,
    String? descripcion,
    required List<int> diasSemana,
    bool todosLosDias = false,
    bool urgente = false,
  }) async {
    _validarTituloRutina(titulo);
    if (!todosLosDias && diasSemana.isEmpty) {
      throw const ValidationException(
        'Debes indicar al menos un día de la semana o marcar todos los días.',
      );
    }

    final ahora = DateTime.now();
    final rutina = Actividad(
      id: _uuid.v4(),
      tipo: TipoActividad.rutina,
      titulo: titulo.trim(),
      descripcion: _descripcionNormalizada(descripcion),
      estado: EstadoActividad.pendiente,
      urgente: urgente,
      createdAt: ahora,
      updatedAt: ahora,
    );
    await guardar(rutina);

    await _guardarRepeticion(
      Repeticion(
        id: _uuid.v4(),
        actividadId: rutina.id,
        tipo: todosLosDias ? TipoRepeticion.diaria : TipoRepeticion.semanal,
        diasSemana: todosLosDias ? null : diasSemana,
        fechaInicio: ahora,
      ),
    );
    return rutina;
  }

  @override
  Future<List<Actividad>> listarRutinasActivas() async {
    final query = database.select(database.actividades)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.tipo.equals(TipoActividad.rutina.storageValue),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.titulo)]);

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  @override
  Future<Actividad?> obtenerRutinaPorId(String id) async {
    final rutina = await obtenerPorId(id);
    if (rutina == null) {
      return null;
    }
    if (rutina.tipo != TipoActividad.rutina) {
      throw const ValidationException('El registro no es una rutina.');
    }
    return rutina;
  }

  @override
  Future<Repeticion?> obtenerRepeticionPorActividadId(String actividadId) async {
    final query = database.select(database.repeticiones)
      ..where((row) => row.actividadId.equals(actividadId))
      ..orderBy([(row) => OrderingTerm.desc(row.id)]);

    final rows = await query.get();
    if (rows.isEmpty) {
      return null;
    }
    return RepeticionMapper.toDomain(rows.first);
  }

  @override
  Future<void> editarRutina({
    required Actividad rutina,
    required List<int> diasSemana,
    bool todosLosDias = false,
  }) async {
    _validarRutinaEdicion(rutina, diasSemana, todosLosDias);

    final existente = await obtenerRutinaPorId(rutina.id);
    if (existente == null) {
      throw const ValidationException('La rutina no existe o fue eliminada.');
    }

    await guardar(
      Actividad(
        id: rutina.id,
        tipo: TipoActividad.rutina,
        titulo: rutina.titulo.trim(),
        descripcion: _descripcionNormalizada(rutina.descripcion),
        estado: EstadoActividad.pendiente,
        urgente: rutina.urgente,
        createdAt: existente.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: existente.deletedAt,
      ),
    );

    final repeticionExistente =
        await obtenerRepeticionPorActividadId(rutina.id);
    if (repeticionExistente == null) {
      throw const ValidationException('La rutina no tiene repetición asociada.');
    }

    await _guardarRepeticion(
      Repeticion(
        id: repeticionExistente.id,
        actividadId: rutina.id,
        tipo: todosLosDias ? TipoRepeticion.diaria : TipoRepeticion.semanal,
        diasSemana: todosLosDias ? null : diasSemana,
        intervalo: repeticionExistente.intervalo,
        fechaInicio: repeticionExistente.fechaInicio,
        fechaFin: repeticionExistente.fechaFin,
        reglaTexto: repeticionExistente.reglaTexto,
      ),
    );
  }

  @override
  Future<void> eliminarRutinaLogicamente(String id) async {
    final rutina = await _obtenerRutina(id);
    final ahora = DateTime.now();
    await guardar(
      Actividad(
        id: rutina.id,
        tipo: rutina.tipo,
        titulo: rutina.titulo,
        descripcion: rutina.descripcion,
        estado: rutina.estado,
        urgente: rutina.urgente,
        createdAt: rutina.createdAt,
        updatedAt: ahora,
        deletedAt: ahora,
      ),
    );
  }

  @override
  Future<Actividad> crearTareaMensual({
    required String titulo,
    String? descripcion,
    required int diaMes,
    bool urgente = false,
  }) async {
    _validarTituloRutina(titulo);
    _validarDiaMes(diaMes);

    final ahora = DateTime.now();
    final tareaMensual = Actividad(
      id: _uuid.v4(),
      tipo: TipoActividad.tareaMensual,
      titulo: titulo.trim(),
      descripcion: _descripcionNormalizada(descripcion),
      estado: EstadoActividad.pendiente,
      urgente: urgente,
      createdAt: ahora,
      updatedAt: ahora,
    );
    await guardar(tareaMensual);

    await _guardarRepeticion(
      Repeticion(
        id: _uuid.v4(),
        actividadId: tareaMensual.id,
        tipo: TipoRepeticion.mensual,
        diaMes: diaMes,
        fechaInicio: ahora,
      ),
    );
    return tareaMensual;
  }

  @override
  Future<List<Actividad>> listarTareasMensualesActivas() async {
    final query = database.select(database.actividades)
      ..where(
        (row) =>
            row.deletedAt.isNull() &
            row.tipo.equals(TipoActividad.tareaMensual.storageValue),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.titulo)]);

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  @override
  Future<Actividad?> obtenerTareaMensualPorId(String id) async {
    final tarea = await obtenerPorId(id);
    if (tarea == null) {
      return null;
    }
    if (tarea.tipo != TipoActividad.tareaMensual) {
      throw const ValidationException('El registro no es una tarea mensual.');
    }
    return tarea;
  }

  @override
  Future<void> editarTareaMensual({
    required Actividad tareaMensual,
    required int diaMes,
  }) async {
    if (tareaMensual.tipo != TipoActividad.tareaMensual) {
      throw const ValidationException('No es una tarea mensual.');
    }
    _validarTituloRutina(tareaMensual.titulo);
    _validarDiaMes(diaMes);

    final existente = await obtenerTareaMensualPorId(tareaMensual.id);
    if (existente == null) {
      throw const ValidationException(
        'La tarea mensual no existe o fue eliminada.',
      );
    }

    await guardar(
      Actividad(
        id: tareaMensual.id,
        tipo: TipoActividad.tareaMensual,
        titulo: tareaMensual.titulo.trim(),
        descripcion: _descripcionNormalizada(tareaMensual.descripcion),
        estado: EstadoActividad.pendiente,
        urgente: tareaMensual.urgente,
        createdAt: existente.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: existente.deletedAt,
      ),
    );

    final repeticion =
        await obtenerRepeticionPorActividadId(tareaMensual.id);
    if (repeticion == null) {
      throw const ValidationException(
        'La tarea mensual no tiene repetición asociada.',
      );
    }

    await _guardarRepeticion(
      Repeticion(
        id: repeticion.id,
        actividadId: tareaMensual.id,
        tipo: TipoRepeticion.mensual,
        diaMes: diaMes,
        intervalo: repeticion.intervalo,
        fechaInicio: repeticion.fechaInicio,
        fechaFin: repeticion.fechaFin,
        reglaTexto: repeticion.reglaTexto,
      ),
    );
  }

  @override
  Future<void> eliminarTareaMensualLogicamente(String id) async {
    final tarea = await _obtenerTareaMensual(id);
    final ahora = DateTime.now();
    await guardar(
      Actividad(
        id: tarea.id,
        tipo: tarea.tipo,
        titulo: tarea.titulo,
        descripcion: tarea.descripcion,
        estado: tarea.estado,
        urgente: tarea.urgente,
        createdAt: tarea.createdAt,
        updatedAt: ahora,
        deletedAt: ahora,
      ),
    );
  }

  @override
  Future<OcurrenciaActividad?> obtenerOcurrenciaParaDia({
    required String actividadId,
    required DateTime dia,
  }) async {
    final repeticion = await obtenerRepeticionPorActividadId(actividadId);
    if (repeticion == null) {
      return null;
    }
    final fechaProgramada = fechaProgramadaParaDia(repeticion, dia);
    final inicio = inicioDelDia(fechaProgramada);
    final fin = finDelDia(fechaProgramada);
    final query = database.select(database.ocurrenciasActividades)
      ..where(
        (row) =>
            row.actividadId.equals(actividadId) &
            row.fechaProgramada.isBiggerOrEqualValue(inicio) &
            row.fechaProgramada.isSmallerOrEqualValue(fin),
      )
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);

    final rows = await query.get();
    if (rows.isEmpty) {
      return null;
    }
    return OcurrenciaMapper.toDomain(rows.first);
  }

  @override
  Future<OcurrenciaActividad> obtenerOCrearOcurrenciaParaDia({
    required String actividadId,
    required DateTime dia,
  }) async {
    final existente = await obtenerOcurrenciaParaDia(
      actividadId: actividadId,
      dia: dia,
    );
    if (existente != null) {
      return existente;
    }

    final repeticion = await obtenerRepeticionPorActividadId(actividadId);
    if (repeticion == null) {
      throw const ValidationException(
        'La actividad no tiene repetición asociada.',
      );
    }

    final ahora = DateTime.now();
    final ocurrencia = OcurrenciaActividad(
      id: _uuid.v4(),
      actividadId: actividadId,
      fechaProgramada: fechaProgramadaParaDia(repeticion, dia),
      estadoOcurrencia: EstadoOcurrencia.pendiente,
      createdAt: ahora,
      updatedAt: ahora,
    );
    await _guardarOcurrencia(ocurrencia);
    return ocurrencia;
  }

  @override
  Future<void> marcarOcurrenciaCompletada(String ocurrenciaId) async {
    final ocurrencia = await _obtenerOcurrencia(ocurrenciaId);
    final ahora = DateTime.now();
    await _guardarOcurrencia(
      ocurrencia.copyWith(
        estadoOcurrencia: EstadoOcurrencia.completada,
        completedAt: ahora,
        updatedAt: ahora,
      ),
    );
  }

  @override
  Future<void> marcarOcurrenciaPendiente(String ocurrenciaId) async {
    final ocurrencia = await _obtenerOcurrencia(ocurrenciaId);
    await _guardarOcurrencia(
      ocurrencia.copyWith(
        estadoOcurrencia: EstadoOcurrencia.pendiente,
        completedAt: null,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<ElementoVistaTemporal>> listarParaHoy(DateTime dia) async {
    final activas = await _listarActivasVistasTemporales();
    final elementos = activas
        .where((a) => correspondeAlDia(a, dia))
        .map((a) => ElementoVistaTemporal(actividad: a))
        .toList();
    elementos.addAll(await _listarElementosRecurrentesParaHoy(dia));
    final sinDuplicados = _deduplicarElementosPorActividadYDia(elementos, dia);
    sinDuplicados.sort(compararElementosVistaTemporal);
    return sinDuplicados;
  }

  @override
  Future<List<ElementoVistaTemporal>> listarProximas({
    DateTime? referencia,
  }) async {
    final ahora = referencia ?? DateTime.now();
    final activas = await _listarActivasVistasTemporales();
    final elementos = activas
        .where(
          (a) =>
              a.estado == EstadoActividad.pendiente &&
              esActividadFutura(a, ahora),
        )
        .map((a) => ElementoVistaTemporal(actividad: a))
        .toList();
    elementos.addAll(await _listarElementosRecurrentesProximas(ahora));
    elementos.sort(compararElementosVistaTemporal);
    return elementos;
  }

  @override
  Future<List<ElementoVistaTemporal>> listarVencidas({
    DateTime? referencia,
  }) async {
    final ahora = referencia ?? DateTime.now();
    final activas = await _listarActivasVistasTemporales();
    final elementos = activas
        .where((a) => esActividadVencida(a, ahora))
        .map((a) => ElementoVistaTemporal(actividad: a))
        .toList();
    elementos.addAll(await _listarElementosRecurrentesVencidas(ahora));
    final sinDuplicados = _deduplicarElementosPorActividadYDia(elementos, ahora);
    sinDuplicados.sort(compararElementosVistaTemporal);
    return sinDuplicados;
  }

  @override
  Future<List<ElementoVistaTemporal>> listarPorRangoFechas({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final activas = await _listarActivasVistasTemporales();
    final elementos = activas
        .where((a) => intersectaRango(a, inicio, fin))
        .map((a) => ElementoVistaTemporal(actividad: a))
        .toList();
    elementos.addAll(
      await _listarElementosRecurrentesEnRango(inicio: inicio, fin: fin),
    );
    elementos.sort(compararElementosVistaTemporal);
    return elementos;
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
    final query = database.select(database.actividades)
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

  /// Evita filas repetidas si ya existían duplicados en base de datos.
  List<ElementoVistaTemporal> _deduplicarElementosPorActividadYDia(
    List<ElementoVistaTemporal> elementos,
    DateTime dia,
  ) {
    final vistos = <String>{};
    final resultado = <ElementoVistaTemporal>[];
    for (final elemento in elementos) {
      final clave = elemento.ocurrencia != null
          ? '${elemento.actividad.id}_'
              '${inicioDelDia(fechaEfectivaOcurrencia(elemento.ocurrencia!)).toIso8601String()}'
          : elemento.actividad.id;
      if (vistos.add(clave)) {
        resultado.add(elemento);
      }
    }
    return resultado;
  }

  Future<List<ElementoVistaTemporal>> _listarElementosRecurrentesParaHoy(
    DateTime dia,
  ) async {
    final elementos = <ElementoVistaTemporal>[];
    final recurrentes = await _listarActividadesRecurrentesActivas();

    for (final actividad in recurrentes) {
      final repeticion = await obtenerRepeticionPorActividadId(actividad.id);
      if (repeticion == null ||
          !diaAplicaParaActividadRecurrente(repeticion, actividad.createdAt, dia)) {
        continue;
      }
      final ocurrencia = await obtenerOCrearOcurrenciaParaDia(
        actividadId: actividad.id,
        dia: dia,
      );
      if (!ocurrenciaVisibleEnVistas(ocurrencia)) {
        continue;
      }
      elementos.add(
        ElementoVistaTemporal(actividad: actividad, ocurrencia: ocurrencia),
      );
    }
    return elementos;
  }

  Future<List<ElementoVistaTemporal>> _listarElementosRecurrentesProximas(
    DateTime referencia,
  ) async {
    final elementos = <ElementoVistaTemporal>[];
    final recurrentes = await _listarActividadesRecurrentesActivas();
    final finRango = referencia.add(const Duration(days: 60));

    for (final actividad in recurrentes) {
      final repeticion = await obtenerRepeticionPorActividadId(actividad.id);
      if (repeticion == null) {
        continue;
      }
      final fechaMinima = fechaMinimaGeneracionOcurrencias(
        repeticion,
        actividad.createdAt,
      );
      var cursor = inicioDelDia(referencia);
      if (cursor.isBefore(fechaMinima)) {
        cursor = fechaMinima;
      }
      final limite = inicioDelDia(finRango);
      while (!cursor.isAfter(limite)) {
        if (diaAplicaParaActividadRecurrente(
          repeticion,
          actividad.createdAt,
          cursor,
        )) {
          final ocurrencia = await obtenerOCrearOcurrenciaParaDia(
            actividadId: actividad.id,
            dia: cursor,
          );
          final elemento = ElementoVistaTemporal(
            actividad: actividad,
            ocurrencia: ocurrencia,
          );
          if (esElementoFuturo(elemento, referencia)) {
            elementos.add(elemento);
          }
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }
    return elementos;
  }

  Future<List<ElementoVistaTemporal>> _listarElementosRecurrentesVencidas(
    DateTime referencia,
  ) async {
    final elementos = <ElementoVistaTemporal>[];
    final recurrentes = await _listarActividadesRecurrentesActivas();
    final finExclusivo = inicioDelDia(referencia);

    for (final actividad in recurrentes) {
      final repeticion = await obtenerRepeticionPorActividadId(actividad.id);
      if (repeticion == null) {
        continue;
      }
      final fechaMinima = fechaMinimaGeneracionOcurrencias(
        repeticion,
        actividad.createdAt,
      );
      var cursor = fechaMinima;
      while (cursor.isBefore(finExclusivo)) {
        if (diaAplicaParaActividadRecurrente(
          repeticion,
          actividad.createdAt,
          cursor,
        )) {
          final fechaProg = fechaProgramadaParaDia(repeticion, cursor);
          if (inicioDelDia(fechaProg).isBefore(fechaMinima)) {
            cursor = cursor.add(const Duration(days: 1));
            continue;
          }
          final ocurrencia = await obtenerOcurrenciaParaDia(
            actividadId: actividad.id,
            dia: cursor,
          );
          if (ocurrencia != null &&
              inicioDelDia(fechaEfectivaOcurrencia(ocurrencia)).isBefore(fechaMinima)) {
            cursor = cursor.add(const Duration(days: 1));
            continue;
          }
          if (esOcurrenciaRecurrenteVencida(
            ocurrencia: ocurrencia,
            fechaProgramada: fechaProg,
            referencia: referencia,
          )) {
            final ocurrenciaVista = ocurrencia ??
                OcurrenciaActividad(
                  id: 'vista-${actividad.id}-${fechaProg.millisecondsSinceEpoch}',
                  actividadId: actividad.id,
                  fechaProgramada: fechaProg,
                  estadoOcurrencia: EstadoOcurrencia.pendiente,
                  createdAt: actividad.createdAt,
                  updatedAt: actividad.createdAt,
                );
            elementos.add(
              ElementoVistaTemporal(
                actividad: actividad,
                ocurrencia: ocurrenciaVista,
              ),
            );
          }
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }
    return elementos;
  }

  Future<List<ElementoVistaTemporal>> _listarElementosRecurrentesEnRango({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final elementos = <ElementoVistaTemporal>[];
    final recurrentes = await _listarActividadesRecurrentesActivas();
    var cursor = inicioDelDia(inicio);
    final limite = finDelDia(fin);

    while (!cursor.isAfter(limite)) {
      for (final actividad in recurrentes) {
        final repeticion = await obtenerRepeticionPorActividadId(actividad.id);
        if (repeticion == null ||
            !diaAplicaParaActividadRecurrente(
              repeticion,
              actividad.createdAt,
              cursor,
            )) {
          continue;
        }
        final ocurrencia = await obtenerOCrearOcurrenciaParaDia(
          actividadId: actividad.id,
          dia: cursor,
        );
        if (!ocurrenciaVisibleEnVistas(ocurrencia)) {
          continue;
        }
        final elemento = ElementoVistaTemporal(
          actividad: actividad,
          ocurrencia: ocurrencia,
        );
        if (elementoIntersectaRango(elemento, inicio, fin)) {
          elementos.add(elemento);
        }
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return elementos;
  }

  Future<void> _guardarRepeticion(Repeticion repeticion) async {
    await database.into(database.repeticiones).insertOnConflictUpdate(
          RepeticionMapper.toCompanion(repeticion),
        );
  }

  Future<void> _guardarOcurrencia(OcurrenciaActividad ocurrencia) async {
    await database.into(database.ocurrenciasActividades).insertOnConflictUpdate(
          OcurrenciaMapper.toCompanion(ocurrencia),
        );
  }

  Future<List<Actividad>> _listarActividadesRecurrentesActivas() async {
    final tipos = [
      TipoActividad.rutina.storageValue,
      TipoActividad.tareaMensual.storageValue,
    ];
    final query = database.select(database.actividades)
      ..where(
        (row) => row.deletedAt.isNull() & row.tipo.isIn(tipos),
      );

    final rows = await query.get();
    return rows.map(ActividadMapper.toDomain).toList();
  }

  Future<OcurrenciaActividad> _obtenerOcurrencia(String id) async {
    final query = database.select(database.ocurrenciasActividades)
      ..where((row) => row.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) {
      throw const ValidationException('La ocurrencia no existe.');
    }
    return OcurrenciaMapper.toDomain(row);
  }

  Future<Actividad> _obtenerRutina(String id) async {
    final rutina = await obtenerRutinaPorId(id);
    if (rutina == null) {
      throw const ValidationException('La rutina no existe o fue eliminada.');
    }
    return rutina;
  }

  Future<Actividad> _obtenerTareaMensual(String id) async {
    final tarea = await obtenerTareaMensualPorId(id);
    if (tarea == null) {
      throw const ValidationException(
        'La tarea mensual no existe o fue eliminada.',
      );
    }
    return tarea;
  }

  void _validarTituloRutina(String titulo) {
    if (titulo.trim().isEmpty) {
      throw const ValidationException('El título es obligatorio.');
    }
  }

  void _validarDiaMes(int diaMes) {
    if (diaMes < 1 || diaMes > 31) {
      throw const ValidationException(
        'El día del mes debe estar entre 1 y 31.',
      );
    }
  }

  void _validarRutinaEdicion(
    Actividad rutina,
    List<int> diasSemana,
    bool todosLosDias,
  ) {
    if (rutina.tipo != TipoActividad.rutina) {
      throw const ValidationException('No es una rutina.');
    }
    _validarTituloRutina(rutina.titulo);
    if (!todosLosDias && diasSemana.isEmpty) {
      throw const ValidationException(
        'Debes indicar al menos un día de la semana o marcar todos los días.',
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
