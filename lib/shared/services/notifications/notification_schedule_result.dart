/// Precisión usada al programar un recordatorio en Android.
enum NotificationSchedulePrecision {
  exact,
  inexact,
}

/// Resultado de programar un aviso local.
class ScheduleReminderResult {
  const ScheduleReminderResult(this.precision);

  final NotificationSchedulePrecision precision;

  bool get usedExact => precision == NotificationSchedulePrecision.exact;

  bool get shouldSuggestExactAlarmPermission => !usedExact;
}
