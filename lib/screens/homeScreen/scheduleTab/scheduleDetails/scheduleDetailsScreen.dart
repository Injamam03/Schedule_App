import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/scheduleDetails/controller/scheduleDetailsController.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_app_bar/custom_app_bar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';
import 'package:jamal_flutter_app/widgers/empty_state/empty_state.dart';
import 'package:jamal_flutter_app/widgers/status_chip/status_chip.dart';

class ScheduleDetailsScreen extends GetView<ScheduleDetailsController> {
  const ScheduleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstString.scheduleDetailsTitle,
        actions: [
          Obx(() => controller.canEdit
              ? IconButton(
                  onPressed: controller.edit,
                  icon: Icon(AppIcons.edit, size: AppSize.iconM, color: p.primary),
                )
              : const Gap.h(0)),
        ],
      ),
      body: Obx(() {
        final s = controller.schedule;
        if (s == null) {
          return EmptyState(
            icon: AppIcons.calendar,
            title: AppConstString.scheduleNotFound,
            message: AppConstString.scheduleNotFoundMessage,
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChip(status: s.status),
                    const Gap.v(12),
                    CustomText(s.title, fontSize: 22, fontWeight: FontWeight.w800, height: 1.25),
                    const Gap.v(18),
                    _DetailRow(
                      icon: AppIcons.calendar,
                      label: AppConstString.dateLabel,
                      value: AppDateUtils.formatDate(s.scheduledAt),
                    ),
                    const Gap.v(14),
                    _DetailRow(
                      icon: AppIcons.clock,
                      label: AppConstString.timeLabel,
                      value: AppDateUtils.formatTime(s.scheduledAt),
                    ),
                    const Gap.v(14),
                    _DetailRow(
                      icon: s.status.icon,
                      iconColor: s.status.color(p),
                      label: AppConstString.statusLabel,
                      value: controller.statusLine(s),
                    ),
                  ],
                ),
              ),
              const Gap.v(16),
              CustomCard(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      AppConstString.descriptionLabel,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: p.textSecondary,
                    ),
                    const Gap.v(8),
                    SizedBox(
                      width: double.infinity,
                      child: CustomText(
                        s.description.isEmpty ? AppConstString.noDescription : s.description,
                        fontSize: 14.5,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap.v(24),
              ..._actions(s, p),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _actions(ScheduleModel s, AppPalette p) {
    switch (s.status) {
      case ScheduleStatus.upcoming:
        return [
          CustomButton(
            label: AppConstString.completedThisSchedule,
            icon: AppIcons.task,
            onTap: controller.complete,
          ),
          if (s.canCancel(controller.now)) ...[
            const Gap.v(12),
            CustomButton(
              label: AppConstString.cancelSchedule,
              icon: AppIcons.cancelled,
              type: CustomButtonType.outlined,
              color: AppColors.error,
              onTap: controller.cancel,
            ),
          ],
        ];
      case ScheduleStatus.missed:
        return [
          CustomText(
            AppConstString.missedHint,
            fontSize: 13,
            color: p.textSecondary,
            height: 1.45,
          ),
          const Gap.v(12),
          CustomButton(
            label: AppConstString.completedMissedTask,
            icon: AppIcons.task,
            onTap: controller.complete,
          ),
        ];
      case ScheduleStatus.completed:
      case ScheduleStatus.cancelled:
        return const [];
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: p.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSize.radiusS),
          ),
          child: Icon(icon, size: AppSize.iconM, color: iconColor ?? p.primary),
        ),
        const Gap.h(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(label, fontSize: 12, color: p.textHint),
              const Gap.v(2),
              CustomText(value, fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.35),
            ],
          ),
        ),
      ],
    );
  }
}
