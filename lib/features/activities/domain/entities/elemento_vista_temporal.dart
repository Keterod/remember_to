import 'actividad.dart';
import 'ocurrencia_actividad.dart';

/// Actividad simple o actividad recurrente mostrada mediante una ocurrencia.
class ElementoVistaTemporal {
  const ElementoVistaTemporal({
    required this.actividad,
    this.ocurrencia,
  });

  final Actividad actividad;
  final OcurrenciaActividad? ocurrencia;

  bool get esOcurrencia => ocurrencia != null;
}
