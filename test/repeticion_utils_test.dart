import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/features/activities/domain/entities/repeticion.dart';
import 'package:remember_to/features/activities/domain/enums/tipo_repeticion.dart';
import 'package:remember_to/features/activities/domain/utils/ocurrencia_vencimiento.dart';
import 'package:remember_to/features/activities/domain/utils/repeticion_utils.dart';

void main() {
  test('fecha mínima usa fechaInicio de repetición si existe', () {
    final repeticion = Repeticion(
      id: 'r1',
      actividadId: 'a1',
      tipo: TipoRepeticion.diaria,
      fechaInicio: DateTime(2026, 5, 10),
    );
    final minima = fechaMinimaGeneracionOcurrencias(
      repeticion,
      DateTime(2026, 5, 1),
    );
    expect(minima, DateTime(2026, 5, 10));
  });

  test('fecha mínima usa createdAt si no hay fechaInicio', () {
    final repeticion = Repeticion(
      id: 'r1',
      actividadId: 'a1',
      tipo: TipoRepeticion.diaria,
    );
    final minima = fechaMinimaGeneracionOcurrencias(
      repeticion,
      DateTime(2026, 5, 15, 18),
    );
    expect(minima, DateTime(2026, 5, 15));
  });

  test('ocurrencia recurrente no vence el mismo día programado', () {
    final programada = DateTime(2026, 5, 17);
    expect(
      esOcurrenciaRecurrenteVencida(
        fechaProgramada: programada,
        referencia: DateTime(2026, 5, 17, 23),
      ),
      isFalse,
    );
    expect(
      esOcurrenciaRecurrenteVencida(
        fechaProgramada: programada,
        referencia: DateTime(2026, 5, 18, 0),
      ),
      isTrue,
    );
  });

  test('día 31 en febrero usa último día disponible', () {
    expect(diaEfectivoEnMes(2026, 2, 31), 28);
    expect(diaEfectivoEnMes(2024, 2, 31), 29);
    expect(
      fechaMensualProgramada(2026, 2, 31),
      DateTime(2026, 2, 28),
    );
  });

  test('día 31 en marzo se mantiene', () {
    expect(diaEfectivoEnMes(2026, 3, 31), 31);
    expect(
      fechaMensualProgramada(2026, 3, 31),
      DateTime(2026, 3, 31),
    );
  });
}
