import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/status_chip/status_chip.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.schedule, required this.onTap});

  final ScheduleModel schedule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final accent = schedule.status.color(p);

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5.w,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(AppSize.radiusL)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            schedule.title,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            maxLines: 1,
                          ),
                        ),
                        const Gap.h(8),
                        StatusChip(status: schedule.status),
                      ],
                    ),
                    const Gap.v(8),
                    Row(
                      children: [
                        Icon(AppIcons.calendar, size: 15.w, color: p.textHint),
                        const Gap.h(5),
                        CustomText(
                          AppDateUtils.formatDate(schedule.scheduledAt),
                          fontSize: 12.5,
                          color: p.textSecondary,
                        ),
                        const Gap.h(14),
                        Icon(AppIcons.clock, size: 15.w, color: p.textHint),
                        const Gap.h(5),
                        CustomText(
                          AppDateUtils.formatTime(schedule.scheduledAt),
                          fontSize: 12.5,
                          color: p.textSecondary,
                        ),
                      ],
                    ),
                    if (schedule.description.isNotEmpty) ...[
                      const Gap.v(8),
                      CustomText(
                        schedule.description,
                        fontSize: 12.5,
                        color: p.textHint,
                        maxLines: 2,
                        height: 1.4,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
