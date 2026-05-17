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
}
