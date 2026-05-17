import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/domain/entities/actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/features/activities/domain/utils/actividad_vencimiento.dart';

void main() {
  final referencia = DateTime(2026, 5, 17, 12);

  Actividad actividad({
    required TipoActividad tipo,
    DateTime? fechaLimite,
    DateTime? fechaAviso,
    DateTime? fechaFin,
    EstadoActividad estado = EstadoActividad.pendiente,
  }) {
    return Actividad(
      id: '1',
      tipo: tipo,
      titulo: 'Prueba',
      estado: estado,
      fechaLimite: fechaLimite,
      fechaAviso: fechaAviso,
      fechaFin: fechaFin,
      createdAt: referencia,
      updatedAt: referencia,
    );
  }

  test('recordatorio pendiente con fechaAviso pasada es vencido', () {
    expect(
      esActividadVencida(
        actividad(
          tipo: TipoActividad.recordatorio,
          fechaAviso: DateTime(2026, 5, 16, 20),
        ),
        referencia,
      ),
      isTrue,
    );
  });

  test('evento pendiente con fechaFin pasada es vencido', () {
    expect(
      esActividadVencida(
        actividad(
          tipo: TipoActividad.evento,
          fechaFin: DateTime(2026, 5, 16, 23),
        ),
        referencia,
      ),
      isTrue,
    );
  });

  test('sin fecha no es vencida', () {
    expect(
      esActividadVencida(
        actividad(tipo: TipoActividad.tarea),
        referencia,
      ),
      isFalse,
    );
    expect(
      esActividadVencida(
        actividad(tipo: TipoActividad.recordatorio),
        referencia,
      ),
      isFalse,
    );
  });

  test('completada no es vencida', () {
    expect(
      esActividadVencida(
        actividad(
          tipo: TipoActividad.recordatorio,
          fechaAviso: DateTime(2026, 5, 10),
          estado: EstadoActividad.completada,
        ),
        referencia,
      ),
      isFalse,
    );
  });
}
