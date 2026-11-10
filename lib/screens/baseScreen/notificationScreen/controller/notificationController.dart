import 'package:get/get.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/notification_feed_service.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';

class NotificationsController extends GetxController {
  final NotificationFeedService _feed = NotificationFeedService.to;

  /// Items newer than this were not yet seen when the screen opened.
  late final int previouslySeenMs;

  List<AppNotificationItem> get items => _feed.items;
  DateTime get now => ScheduleService.to.now.value;

  @override
  void onInit() {
    super.onInit();
    previouslySeenMs = _feed.lastSeenMs.value;
    _feed.markAllSeen();
  }

  bool isNew(AppNotificationItem item) =>
      item.time.millisecondsSinceEpoch > previouslySeenMs;

  void open(AppNotificationItem item) {
    if (!_feed.isScheduleKnown(item.scheduleId)) return;
    Get.toNamed(AppRoutes.scheduleDetails, arguments: item.scheduleId);
  }
}
