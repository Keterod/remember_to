import 'package:flutter_test/flutter_test.dart';

import 'package:remember_to/shared/services/notifications/fake_local_notifications_service.dart';
import 'package:remember_to/shared/services/notifications/notification_ids.dart';
import 'package:remember_to/shared/services/notifications/notification_schedule_result.dart';

void main() {
  late FakeLocalNotificationsService notifications;

  setUp(() {
    notifications = FakeLocalNotificationsService();
    notifications.permissionsGranted = true;
    notifications.exactAlarmsGranted = true;
  });

  test('programa en modo exacto cuando hay permiso de alarma exacta', () async {
    final futuro = DateTime.now().add(const Duration(minutes: 5));

    final result = await notifications.scheduleReminderNotification(
      actividadId: 'id-exacto',
      title: 'Exacto',
      scheduledDate: futuro,
    );

    expect(result.usedExact, isTrue);
    expect(notifications.schedulePrecisionLog.last,
        NotificationSchedulePrecision.exact);
    expect(notifications.findByActividadId('id-exacto'), isNotNull);
  });

  test('usa fallback inexacto sin permiso de alarma exacta', () async {
    notifications.exactAlarmsGranted = false;
    final futuro = DateTime.now().add(const Duration(minutes: 5));

    final result = await notifications.scheduleReminderNotification(
      actividadId: 'id-inexacto',
      title: 'Inexacto',
      scheduledDate: futuro,
    );

    expect(result.usedExact, isFalse);
    expect(result.shouldSuggestExactAlarmPermission, isTrue);
    expect(notifications.schedulePrecisionLog.last,
        NotificationSchedulePrecision.inexact);
  });

  test('dos recordatorios mantienen IDs de notificación distintos', () async {
    final futuro = DateTime.now().add(const Duration(minutes: 10));

    final r1 = await notifications.scheduleReminderNotification(
      actividadId: 'uuid-aaa',
      title: 'Uno',
      scheduledDate: futuro,
    );
    final r2 = await notifications.scheduleReminderNotification(
      actividadId: 'uuid-bbb',
      title: 'Dos',
      scheduledDate: futuro.add(const Duration(minutes: 1)),
    );

    expect(r1.usedExact, isTrue);
    expect(r2.usedExact, isTrue);
    expect(
      notificationIdForActividad('uuid-aaa'),
      isNot(notificationIdForActividad('uuid-bbb')),
    );
    expect(notifications.scheduled, hasLength(2));
  });

  test('no falla si no hay permiso de alarma exacta', () async {
    notifications.exactAlarmsGranted = false;

    expect(
      notifications.scheduleReminderNotification(
        actividadId: 'sin-exacto',
        title: 'Prueba',
        scheduledDate: DateTime.now().add(const Duration(minutes: 2)),
      ),
      completes,
    );
  });
}
