import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/app_user_data.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/auth_service.dart';
import 'package:jamal_flutter_app/services/notification_feed_service.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';

class HomeTabController extends GetxController {
  final ScheduleService _schedules = ScheduleService.to;
  final NotificationFeedService _feed = NotificationFeedService.to;

  AppUserData? get user => AuthService.to.user.value;
  DateTime get now => _schedules.now.value;

  ScheduleModel? get active => _schedules.activeSchedule;
  ScheduleModel? get next => _schedules.nextSchedule;
  ScheduleModel? get recentlyCompleted => _schedules.recentlyCompleted;
  int get unreadNotifications => _feed.unreadCount;

  void openNotifications() => Get.toNamed(AppRoutes.notifications);
  void openCreateSchedule() => Get.toNamed(AppRoutes.createSchedule);
  void openDetails(int id) => Get.toNamed(AppRoutes.scheduleDetails, arguments: id);

  Future<void> completeActive(int id) async {
    await _schedules.markCompleted(id);
    AppSnack.success(AppConstString.markedComplete);
  }
}
