import '../entities/actividad.dart';

/// Contrato de persistencia para actividades y tareas.
abstract class ActividadRepository {
  Future<List<Actividad>> obtenerActivas();

  Future<List<Actividad>> listarTareasActivas();

  Future<Actividad?> obtenerPorId(String id);

  Future<void> guardar(Actividad actividad);

  Future<Actividad> crearTarea({
    required String titulo,
    String? descripcion,
    DateTime? fechaLimite,
    bool urgente = false,
  });

  Future<void> editarTarea(Actividad tarea);

  Future<void> marcarCompletada(String id);

  Future<void> marcarPendiente(String id);

  Future<void> eliminarLogicamente(String id);

  Future<Actividad> crearRecordatorio({
    required String titulo,
    String? descripcion,
    required DateTime fechaAviso,
    bool urgente = false,
  });

  Future<List<Actividad>> listarRecordatoriosActivos();

  Future<Actividad?> obtenerRecordatorioPorId(String id);

  Future<void> editarRecordatorio(Actividad recordatorio);

  Future<void> eliminarRecordatorioLogicamente(String id);

  Future<Actividad> crearEvento({
    required String titulo,
    String? descripcion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    bool urgente = false,
  });

  Future<List<Actividad>> listarEventosActivos();

  Future<Actividad?> obtenerEventoPorId(String id);

  Future<void> editarEvento(Actividad evento);

  Future<void> eliminarEventoLogicamente(String id);

  Future<void> marcarEventoCompletada(String id);

  Future<void> marcarEventoPendiente(String id);

  Future<List<Actividad>> listarParaHoy(DateTime dia);

  Future<List<Actividad>> listarProximas({DateTime? referencia});

  Future<List<Actividad>> listarVencidas({DateTime? referencia});

  Future<List<Actividad>> listarPorRangoFechas({
    required DateTime inicio,
    required DateTime fin,
  });
}
