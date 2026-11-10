import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

/// Presentation helpers for [ScheduleStatus].
extension ScheduleStatusUi on ScheduleStatus {
  String get label => switch (this) {
        ScheduleStatus.upcoming => AppConstString.statusUpcoming,
        ScheduleStatus.completed => AppConstString.statusCompleted,
        ScheduleStatus.missed => AppConstString.statusMissed,
        ScheduleStatus.cancelled => AppConstString.statusCancelled,
      };

  IconData get icon => switch (this) {
        ScheduleStatus.upcoming => AppIcons.upcoming,
        ScheduleStatus.completed => AppIcons.completed,
        ScheduleStatus.missed => AppIcons.missed,
        ScheduleStatus.cancelled => AppIcons.cancelled,
      };

  Color color(AppPalette p) => switch (this) {
        ScheduleStatus.upcoming => p.primary,
        ScheduleStatus.completed => AppColors.success,
        ScheduleStatus.missed => AppColors.error,
        ScheduleStatus.cancelled => AppColors.cancelled,
      };
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final ScheduleStatus status;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final color = status.color(p);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 13.w, color: color),
          const Gap.h(5),
          CustomText(status.label, fontSize: 11.5, fontWeight: FontWeight.w700, color: color),
        ],
      ),
    );
  }
}
