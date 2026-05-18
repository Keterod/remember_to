import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/time/timezone_setup.dart';
import 'notification_action_executor.dart';
import '../../../features/activities/domain/enums/tipo_actividad.dart';
import 'notification_action_ids.dart';
import 'notification_payload.dart';

/// Despacha una respuesta de notificación (foreground o background).
Future<void> dispatchNotificationAction(
  NotificationResponse response, {
  bool background = false,
}) async {
  if (kDebugMode) {
    debugPrint('[NotifAction] callback recibido (background=$background)');
    debugPrint('[NotifAction] actionId=${response.actionId}');
    debugPrint('[NotifAction] payload=${response.payload}');
    debugPrint(
      '[NotifAction] type=${response.notificationResponseType.name}',
    );
  }

  final actionId = response.actionId;
  if (actionId == null || actionId.isEmpty) {
    if (kDebugMode) {
      debugPrint('[NotifAction] sin actionId, se ignora');
    }
    return;
  }

  final payload = NotificationPayload.fromJsonString(response.payload);
  if (payload == null) {
    if (kDebugMode) {
      debugPrint('[NotifAction] payload inválido o vacío');
    }
    return;
  }

  if (kDebugMode) {
    debugPrint('[NotifAction] actividadId=${payload.actividadId}');
    debugPrint('[NotifAction] ocurrenciaId=${payload.ocurrenciaId}');
    debugPrint('[NotifAction] tipo=${payload.tipo.name}');
    switch (actionId) {
      case NotificationActionIds.completar:
        debugPrint(
          payload.tipo == TipoActividad.recordatorio
              ? '[NotifAction] ejecutando listo'
              : '[NotifAction] ejecutando completar',
        );
      case NotificationActionIds.posponer10:
      case NotificationActionIds.posponer30:
      case NotificationActionIds.posponer60:
        debugPrint('[NotifAction] ejecutando posponer ($actionId)');
      default:
        debugPrint('[NotifAction] actionId no reconocido: $actionId');
    }
  }

  try {
    await NotificationActionExecutor.instance.handle(response);
    if (kDebugMode) {
      debugPrint('[NotifAction] resultado=ok');
    }
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('[NotifAction] resultado=error: $error');
      debugPrint('$stackTrace');
    }
  }
}

/// Callback en isolate de fondo para acciones de notificación (Sprint 7).
@pragma('vm:entry-point')
void onBackgroundNotificationResponse(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocalTimezone();
  await dispatchNotificationAction(response, background: true);
}

/// Callback en primer plano (mismo isolate que la app).
Future<void> onForegroundNotificationResponse(
  NotificationResponse response,
) async {
  await dispatchNotificationAction(response, background: false);
}
