import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_config.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/services/notification_service.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';

enum NotificationKind { reminder, start, missed }

class AppNotificationItem {
  const AppNotificationItem({
    required this.scheduleId,
    required this.kind,
    required this.title,
    required this.body,
    required this.time,
  });

  final int scheduleId;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime time;
}

/// In-app notification history. Local notifications fire while the app may be
/// closed, so the feed is *derived* from schedules: an item exists for every
/// reminder / start / missed event whose time has passed and that was not
/// pre-empted by completing or cancelling the schedule.
class NotificationFeedService extends GetxService {
  NotificationFeedService(this._schedules, this._notifications, this._storage);

  static NotificationFeedService get to => Get.find();

  final ScheduleService _schedules;
  final NotificationService _notifications;
  final GetStorageService _storage;

  final RxInt lastSeenMs = 0.obs;

  Future<NotificationFeedService> init() async {
    lastSeenMs.value =
        _storage.read<int>(AppStorageKey.lastSeenNotifications) ?? 0;
    return this;
  }

  List<AppNotificationItem> get items {
    final now = _schedules.now.value;
    final lead = _notifications.reminderLeadMinutes;
    final result = <AppNotificationItem>[];

    for (final s in _schedules.schedules) {
      bool fired(DateTime t) {
        if (t.isAfter(now)) return false;
        if (t.isBefore(s.updatedAt)) return false; // created/edited later
        if (s.cancelledAt != null && !s.cancelledAt!.isAfter(t)) return false;
        if (s.completedAt != null && !s.completedAt!.isAfter(t)) return false;
        return true;
      }

      final reminderAt = s.scheduledAt.subtract(Duration(minutes: lead));
      if (fired(reminderAt)) {
        result.add(AppNotificationItem(
          scheduleId: s.id,
          kind: NotificationKind.reminder,
          title: AppConstString.notifReminderTitle,
          body: AppConstString.notifReminderBody(s.title, lead),
          time: reminderAt,
        ));
      }
      if (fired(s.scheduledAt)) {
        result.add(AppNotificationItem(
          scheduleId: s.id,
          kind: NotificationKind.start,
          title: AppConstString.notifStartTitle,
          body: AppConstString.notifStartBody(s.title),
          time: s.scheduledAt,
        ));
      }
      if (s.missedAt != null) {
        final missedAt = s.deadline.add(AppConfig.missedNotificationDelay);
        if (fired(missedAt)) {
          result.add(AppNotificationItem(
            scheduleId: s.id,
            kind: NotificationKind.missed,
            title: AppConstString.notifMissedTitle,
            body: AppConstString.notifMissedBody(s.title),
            time: missedAt,
          ));
        }
      }
    }
    result.sort((a, b) => b.time.compareTo(a.time));
    return result;
  }

  int get unreadCount => items
      .where((i) => i.time.millisecondsSinceEpoch > lastSeenMs.value)
      .length;

  Future<void> markAllSeen() async {
    lastSeenMs.value = DateTime.now().millisecondsSinceEpoch;
    await _storage.write(AppStorageKey.lastSeenNotifications, lastSeenMs.value);
  }

  bool isScheduleKnown(int id) =>
      _schedules.byId(id) != null; // used to guard taps on purged items
}
