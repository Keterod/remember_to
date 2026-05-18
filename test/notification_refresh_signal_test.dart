import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/shared/services/notifications/notification_refresh_signal.dart';

void main() {
  tearDown(() {
    final existing =
        IsolateNameServer.lookupPortByName(notificationRefreshPortName);
    if (existing != null) {
      IsolateNameServer.removePortNameMapping(notificationRefreshPortName);
    }
  });

  test('notifyNotificationDataChanged invoca listener registrado', () async {
    var refrescado = false;
    registerNotificationRefreshListener(() {
      refrescado = true;
    });

    notifyNotificationDataChanged();
    await Future<void>.delayed(Duration.zero);

    expect(refrescado, isTrue);
  });
}
