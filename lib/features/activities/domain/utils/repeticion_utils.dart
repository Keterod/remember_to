import 'package:flutter/material.dart';

import '../entities/repeticion.dart';
import '../enums/tipo_repeticion.dart';
import 'actividad_temporal.dart';

/// Primera fecha en la que puede existir una ocurrencia de la actividad recurrente.
DateTime fechaMinimaGeneracionOcurrencias(
  Repeticion repeticion,
  DateTime actividadCreatedAt,
) {
  if (repeticion.fechaInicio != null) {
    return inicioDelDia(repeticion.fechaInicio!);
  }
  return inicioDelDia(actividadCreatedAt);
}

/// Día aplicable considerando fecha mínima de la actividad.
bool diaAplicaParaActividadRecurrente(
  Repeticion repeticion,
  DateTime actividadCreatedAt,
  DateTime dia,
) {
  final diaCivil = inicioDelDia(dia);
  final minima = fechaMinimaGeneracionOcurrencias(repeticion, actividadCreatedAt);
  if (diaCivil.isBefore(minima)) {
    return false;
  }
  return repeticionAplicaEnDia(repeticion, dia);
}

/// Convierte lista de días (1=lunes … 7=domingo) a texto almacenable.
String diasSemanaToStorage(List<int> dias) {
  final ordenados = dias.toSet().toList()..sort();
  return ordenados.join(',');
}

List<int> diasSemanaFromStorage(String? value) {
  if (value == null || value.trim().isEmpty) {
    return [];
  }
  return value
      .split(',')
      .map((s) => int.tryParse(s.trim()))
      .whereType<int>()
      .where((d) => d >= DateTime.monday && d <= DateTime.sunday)
      .toList();
}

/// Último día disponible del mes si [diaMes] no existe (p. ej. 31 en febrero).
int diaEfectivoEnMes(int year, int month, int diaMes) {
  final ultimo = DateUtils.getDaysInMonth(year, month);
  return diaMes > ultimo ? ultimo : diaMes;
}

DateTime fechaMensualProgramada(int year, int month, int diaMes) {
  final dia = diaEfectivoEnMes(year, month, diaMes);
  return DateTime(year, month, dia);
}

/// La repetición aplica al día civil [dia].
bool repeticionAplicaEnDia(Repeticion repeticion, DateTime dia) {
  final diaCivil = inicioDelDia(dia);

  if (repeticion.fechaInicio != null) {
    final inicio = inicioDelDia(repeticion.fechaInicio!);
    if (diaCivil.isBefore(inicio)) {
      return false;
    }
  }
  if (repeticion.fechaFin != null) {
    final fin = finDelDia(repeticion.fechaFin!);
    if (diaCivil.isAfter(fin)) {
      return false;
    }
  }

  switch (repeticion.tipo) {
    case TipoRepeticion.diaria:
      return true;
    case TipoRepeticion.semanal:
      final dias = repeticion.diasSemana ?? [];
      if (dias.isEmpty) {
        return false;
      }
      return dias.contains(diaCivil.weekday);
    case TipoRepeticion.mensual:
      final diaMes = repeticion.diaMes;
      if (diaMes == null) {
        return false;
      }
      return diaCivil.day == diaEfectivoEnMes(diaCivil.year, diaCivil.month, diaMes);
    case TipoRepeticion.anual:
    case TipoRepeticion.personalizada:
      return false;
  }
}

DateTime fechaProgramadaParaDia(Repeticion repeticion, DateTime dia) {
  if (repeticion.tipo == TipoRepeticion.mensual && repeticion.diaMes != null) {
    return fechaMensualProgramada(dia.year, dia.month, repeticion.diaMes!);
  }
  return inicioDelDia(dia);
}
