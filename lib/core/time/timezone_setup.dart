import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Configura la zona horaria local para programar notificaciones.
Future<void> setupLocalTimezone() async {
  tz_data.initializeTimeZones();

  try {
    tz.setLocalLocation(tz.getLocation('America/Lima'));
  } catch (_) {
    tz.setLocalLocation(tz.UTC);
  }
}
