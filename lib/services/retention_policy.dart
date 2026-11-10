import 'package:jamal_flutter_app/constant/app_config.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';

/// Single source of truth for the 30-day history rule.
/// Notes and saved photos are intentionally NOT covered by this policy.
class RetentionPolicy {
  RetentionPolicy._();

  static const int days = AppConfig.retentionDays;

  static DateTime cutoff(DateTime now) => now.subtract(const Duration(days: days));

  /// Only records whose scheduled time is older than the cutoff expire.
  /// Current and future schedules are never expired.
  static bool isExpired(ScheduleModel schedule, DateTime now) =>
      schedule.scheduledAt.isBefore(cutoff(now));
}
