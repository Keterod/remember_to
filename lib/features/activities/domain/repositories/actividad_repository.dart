import '../entities/actividad.dart';

/// Contrato base de persistencia para actividades (Sprint 1).
abstract class ActividadRepository {
  Future<List<Actividad>> obtenerActivas();

  Future<Actividad?> obtenerPorId(String id);

  Future<void> guardar(Actividad actividad);
}
