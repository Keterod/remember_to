import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flutter_local_notifications_service.dart';
import 'local_notifications_service.dart';

final localNotificationsServiceProvider =
    Provider<LocalNotificationsService>((ref) {
  return FlutterLocalNotificationsService();
});
