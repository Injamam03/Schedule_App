import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';

enum ScheduleFilter { all, upcoming, complete, missing, cancel }

extension ScheduleFilterX on ScheduleFilter {
  String get label => switch (this) {
        ScheduleFilter.all => AppConstString.filterAll,
        ScheduleFilter.upcoming => AppConstString.filterUpcoming,
        ScheduleFilter.complete => AppConstString.filterComplete,
        ScheduleFilter.missing => AppConstString.filterMissing,
        ScheduleFilter.cancel => AppConstString.filterCancel,
      };

  ScheduleStatus? get status => switch (this) {
        ScheduleFilter.all => null,
        ScheduleFilter.upcoming => ScheduleStatus.upcoming,
        ScheduleFilter.complete => ScheduleStatus.completed,
        ScheduleFilter.missing => ScheduleStatus.missed,
        ScheduleFilter.cancel => ScheduleStatus.cancelled,
      };
}

class ScheduleTabController extends GetxController {
  final ScheduleService _schedules = ScheduleService.to;
  final Rx<ScheduleFilter> filter = ScheduleFilter.all.obs;

  void selectFilter(ScheduleFilter value) => filter.value = value;

  /// Reactive: reads the schedule list and the selected filter.
  List<ScheduleModel> get filtered {
    final status = filter.value.status;
    final list = _schedules.schedules
        .where((s) => status == null || s.status == status)
        .toList();
    if (filter.value == ScheduleFilter.upcoming) {
      list.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    } else {
      list.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    }
    return list;
  }

  String get emptyMessage => switch (filter.value) {
        ScheduleFilter.all => AppConstString.emptyAll,
        ScheduleFilter.upcoming => AppConstString.emptyUpcoming,
        ScheduleFilter.complete => AppConstString.emptyComplete,
        ScheduleFilter.missing => AppConstString.emptyMissing,
        ScheduleFilter.cancel => AppConstString.emptyCancel,
      };

  void openCreate() => Get.toNamed(AppRoutes.createSchedule);
  void openDetails(int id) => Get.toNamed(AppRoutes.scheduleDetails, arguments: id);
}
