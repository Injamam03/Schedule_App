import 'package:get/get.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/controller/scheduleTabController.dart';
import 'package:jamal_flutter_app/services/notification_service.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  final RxInt selectedIndex = 0.obs;

  void changeTab(int index) => selectedIndex.value = index;

  /// Jumps to the Schedule tab with a given filter (e.g. after creating one).
  void goToSchedule(ScheduleFilter filter) {
    if (Get.isRegistered<ScheduleTabController>()) {
      Get.find<ScheduleTabController>().selectFilter(filter);
    }
    selectedIndex.value = 1;
  }

  @override
  void onReady() {
    super.onReady();
    final notifications = NotificationService.to;
    // Ask once the user lands on the main screen, then handle a cold-start tap.
    notifications.requestPermissions().then((_) {
      NotificationService.openFromPayload(notifications.takeLaunchPayload());
    });
  }
}
