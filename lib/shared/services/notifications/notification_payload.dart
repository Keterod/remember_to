import 'dart:convert';

import '../../../features/activities/domain/enums/tipo_actividad.dart';
import 'notification_slot.dart';

/// Datos serializados en el payload de [flutter_local_notifications].
class NotificationPayload {
  const NotificationPayload({
    required this.actividadId,
    this.ocurrenciaId,
    required this.tipo,
    this.slot = NotificationSlot.principal,
    this.repeatAttempt = 0,
  });

  final String actividadId;
  final String? ocurrenciaId;
  final TipoActividad tipo;
  final NotificationSlot slot;
  final int repeatAttempt;

  bool get esOcurrencia =>
      ocurrenciaId != null && ocurrenciaId!.trim().isNotEmpty;

  NotificationPayload copyWith({
    String? actividadId,
    String? ocurrenciaId,
    TipoActividad? tipo,
    NotificationSlot? slot,
    int? repeatAttempt,
  }) {
    return NotificationPayload(
      actividadId: actividadId ?? this.actividadId,
      ocurrenciaId: ocurrenciaId ?? this.ocurrenciaId,
      tipo: tipo ?? this.tipo,
      slot: slot ?? this.slot,
      repeatAttempt: repeatAttempt ?? this.repeatAttempt,
    );
  }

  String toJsonString() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'actividadId': actividadId,
        'ocurrenciaId': ocurrenciaId,
        'tipo': tipo.name,
        'slot': slot.name,
        'repeatAttempt': repeatAttempt,
      };

  static NotificationPayload? fromJsonString(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      final map = jsonDecode(raw);
      if (map is! Map<String, dynamic>) {
        return null;
      }
      return fromMap(map);
    } catch (_) {
      return null;
    }
  }

  static NotificationPayload? fromMap(Map<String, dynamic> map) {
    final actividadId = map['actividadId'] as String?;
    if (actividadId == null || actividadId.isEmpty) {
      return null;
    }
    final tipoRaw = map['tipo'] as String?;
    if (tipoRaw == null) {
      return null;
    }
    TipoActividad tipo;
    try {
      tipo = TipoActividad.values.firstWhere((t) => t.name == tipoRaw);
    } catch (_) {
      return null;
    }
    final slotRaw = map['slot'] as String? ?? NotificationSlot.principal.name;
    NotificationSlot slot;
    try {
      slot = NotificationSlot.values.firstWhere((s) => s.name == slotRaw);
    } catch (_) {
      slot = NotificationSlot.principal;
    }
    final repeatAttempt = map['repeatAttempt'] as int? ?? 0;
    final ocurrenciaId = map['ocurrenciaId'] as String?;
    return NotificationPayload(
      actividadId: actividadId,
      ocurrenciaId: ocurrenciaId,
      tipo: tipo,
      slot: slot,
      repeatAttempt: repeatAttempt,
    );
  }
}
