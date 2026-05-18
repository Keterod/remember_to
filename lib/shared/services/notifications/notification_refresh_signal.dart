import 'dart:isolate';
import 'dart:ui';

/// Notifica al isolate principal que debe refrescar providers tras una acción
/// de notificación ejecutada en segundo plano.
const String notificationRefreshPortName = 'remember_to_notif_refresh';

void registerNotificationRefreshListener(void Function() onRefresh) {
  final existing = IsolateNameServer.lookupPortByName(notificationRefreshPortName);
  if (existing != null) {
    IsolateNameServer.removePortNameMapping(notificationRefreshPortName);
  }

  final port = ReceivePort();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    notificationRefreshPortName,
  );
  port.listen((_) => onRefresh());
}

void notifyNotificationDataChanged() {
  IsolateNameServer.lookupPortByName(notificationRefreshPortName)?.send(null);
}
