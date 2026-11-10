import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';
import 'package:jamal_flutter_app/widgers/confirmDialog/confirmDialog.dart';

class ScheduleDetailsController extends GetxController {
  late final int scheduleId;
  final ScheduleService _service = ScheduleService.to;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    scheduleId = args is int ? args : -1;
  }

  /// Reactive lookup: the screen always shows the latest state.
  ScheduleModel? get schedule => _service.byId(scheduleId);
  DateTime get now => _service.now.value;

  bool get canEdit => schedule?.canCancel(now) ?? false;

  /// One-line status explanation shown in the info card.
  String statusLine(ScheduleModel s) {
    switch (s.status) {
      case ScheduleStatus.upcoming:
        return s.isActive(now)
            ? AppConstString.inProgressSince(
                AppDateUtils.formatDuration(now.difference(s.scheduledAt)))
            : AppConstString.startsIn(
                AppDateUtils.formatDuration(s.scheduledAt.difference(now)));
      case ScheduleStatus.completed:
        return AppConstString.completedOn(
            AppDateUtils.formatDateTime(s.completedAt ?? s.scheduledAt));
      case ScheduleStatus.missed:
        return AppConstString.missedOn(AppDateUtils.formatDate(s.scheduledAt));
      case ScheduleStatus.cancelled:
        return AppConstString.cancelledOn(
            AppDateUtils.formatDateTime(s.cancelledAt ?? s.scheduledAt));
    }
  }

  void edit() {
    final s = schedule;
    if (s == null) return;
    Get.toNamed(AppRoutes.createSchedule, arguments: s);
  }

  Future<void> complete() async {
    await _service.markCompleted(scheduleId);
    AppSnack.success(AppConstString.markedComplete);
  }

  Future<void> cancel() async {
    final confirmed = await ConfirmDialog.show(
      title: AppConstString.cancelScheduleTitle,
      message: AppConstString.cancelScheduleMessage,
      confirmLabel: AppConstString.cancelSchedule,
      cancelLabel: AppConstString.keepSchedule,
      isDestructive: true,
    );
    if (!confirmed) return;
    final ok = await _service.cancel(scheduleId);
    if (ok) {
      AppSnack.success(AppConstString.scheduleCancelled);
    } else {
      AppSnack.error(AppConstString.cancelNotAllowed);
    }
  }
}
