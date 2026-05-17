import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/domain/enums/tipo_actividad.dart';

void main() {
  group('rutaEdicion por tipo', () {
    test('tarea', () {
      expect(
        TipoActividad.tarea.rutaEdicion('abc'),
        '/tareas/abc/editar',
      );
    });

    test('recordatorio', () {
      expect(
        TipoActividad.recordatorio.rutaEdicion('abc'),
        '/recordatorios/abc/editar',
      );
    });

    test('evento', () {
      expect(
        TipoActividad.evento.rutaEdicion('abc'),
        '/eventos/abc/editar',
      );
    });

    test('rutina', () {
      expect(
        TipoActividad.rutina.rutaEdicion('abc'),
        '/rutinas/abc/editar',
      );
    });

    test('tarea mensual', () {
      expect(
        TipoActividad.tareaMensual.rutaEdicion('abc'),
        '/tareas-mensuales/abc/editar',
      );
    });
  });
}
