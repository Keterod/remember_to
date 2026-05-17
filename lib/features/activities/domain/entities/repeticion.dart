import '../enums/tipo_repeticion.dart';

class Repeticion {
  const Repeticion({
    required this.id,
    required this.actividadId,
    required this.tipo,
    this.intervalo = 1,
    this.diasSemana,
    this.diaMes,
    this.fechaInicio,
    this.fechaFin,
    this.reglaTexto,
  });

  final String id;
  final String actividadId;
  final TipoRepeticion tipo;
  final int intervalo;
  final List<int>? diasSemana;
  final int? diaMes;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? reglaTexto;
}
