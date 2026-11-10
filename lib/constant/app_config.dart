/// Central place for tunable behaviour (retention, reminder timing, ...).
class AppConfig {
  AppConfig._();

  /// Schedules older than this many days are purged automatically.
  static const int retentionDays = 30;

  /// Default minutes before the scheduled time that the reminder fires.
  /// Can be overridden at runtime via NotificationService.setReminderLead.
  static const int reminderLeadMinutes = 10;

  /// How long after the scheduled day ends the "missed" notification fires.
  /// 8 hours => 08:00 the next morning (avoids waking the user at midnight).
  static const Duration missedNotificationDelay = Duration(hours: 8);

  /// How often the app re-evaluates statuses (active / missed) while open.
  static const Duration tickInterval = Duration(seconds: 20);

  static const String notificationChannelId = 'schedule_reminders';
  static const int minPasswordLength = 6;
}
