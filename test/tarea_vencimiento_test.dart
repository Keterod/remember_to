import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/domain/entities/actividad.dart';
import 'package:remember_to/features/activities/domain/enums/estado_actividad.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';
import 'package:remember_to/features/activities/domain/utils/tarea_vencimiento.dart';

void main() {
  final ahora = DateTime(2026, 5, 16, 15);

  Actividad tarea({
    EstadoActividad estado = EstadoActividad.pendiente,
    DateTime? fechaLimite,
    TipoActividad tipo = TipoActividad.tarea,
  }) {
    return Actividad(
      id: '1',
      tipo: tipo,
      titulo: 'Prueba',
      estado: estado,
      fechaLimite: fechaLimite,
      createdAt: ahora,
      updatedAt: ahora,
    );
  }

  test('sin fecha límite no es vencida', () {
    expect(esTareaVencida(tarea(), ahora), isFalse);
  });

  test('fecha límite hoy no es vencida', () {
    expect(
      esTareaVencida(tarea(fechaLimite: DateTime(2026, 5, 16)), ahora),
      isFalse,
    );
  });

  test('fecha límite ayer es vencida si está pendiente', () {
    expect(
      esTareaVencida(tarea(fechaLimite: DateTime(2026, 5, 15)), ahora),
      isTrue,
    );
  });

  test('completada no es vencida aunque la fecha haya pasado', () {
    expect(
      esTareaVencida(
        tarea(
          estado: EstadoActividad.completada,
          fechaLimite: DateTime(2026, 5, 10),
        ),
        ahora,
      ),
      isFalse,
    );
  });

  test('solo aplica a tipo tarea', () {
    expect(
      esTareaVencida(
        tarea(
          tipo: TipoActividad.recordatorio,
          fechaLimite: DateTime(2026, 5, 10),
        ),
        ahora,
      ),
      isFalse,
    );
  });
}
