import '../entities/actividad.dart';
import '../entities/elemento_vista_temporal.dart';
import '../entities/ocurrencia_actividad.dart';
import '../entities/repeticion.dart';

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

  Future<Actividad> crearRutina({
    required String titulo,
    String? descripcion,
    required List<int> diasSemana,
    bool todosLosDias = false,
    bool urgente = false,
  });

  Future<List<Actividad>> listarRutinasActivas();

  Future<Actividad?> obtenerRutinaPorId(String id);

  Future<Repeticion?> obtenerRepeticionPorActividadId(String actividadId);

  Future<void> editarRutina({
    required Actividad rutina,
    required List<int> diasSemana,
    bool todosLosDias = false,
  });

  Future<void> eliminarRutinaLogicamente(String id);

  Future<Actividad> crearTareaMensual({
    required String titulo,
    String? descripcion,
    required int diaMes,
    bool urgente = false,
  });

  Future<List<Actividad>> listarTareasMensualesActivas();

  Future<Actividad?> obtenerTareaMensualPorId(String id);

  Future<void> editarTareaMensual({
    required Actividad tareaMensual,
    required int diaMes,
  });

  Future<void> eliminarTareaMensualLogicamente(String id);

  Future<OcurrenciaActividad?> obtenerOcurrenciaParaDia({
    required String actividadId,
    required DateTime dia,
  });

  Future<OcurrenciaActividad> obtenerOCrearOcurrenciaParaDia({
    required String actividadId,
    required DateTime dia,
  });

  Future<void> marcarOcurrenciaCompletada(String ocurrenciaId);

  Future<void> marcarOcurrenciaPendiente(String ocurrenciaId);

  Future<List<ElementoVistaTemporal>> listarParaHoy(DateTime dia);

  Future<List<ElementoVistaTemporal>> listarProximas({DateTime? referencia});

  Future<List<ElementoVistaTemporal>> listarVencidas({DateTime? referencia});

  Future<List<ElementoVistaTemporal>> listarPorRangoFechas({
    required DateTime inicio,
    required DateTime fin,
  });
}
