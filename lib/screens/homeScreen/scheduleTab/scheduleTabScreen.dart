import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/controller/scheduleTabController.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/empty_state/empty_state.dart';
import 'package:jamal_flutter_app/widgers/schedule_card/schedule_card.dart';

class ScheduleTabScreen extends GetView<ScheduleTabController> {
  const ScheduleTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.openCreate,
        shape: const CircleBorder(),
        child: Icon(AppIcons.add, size: AppSize.iconL),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppSize.pagePadding, 16.h, AppSize.pagePadding, 14.h),
              child: CustomText(AppConstString.mySchedule, fontSize: 24, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSize.pagePadding),
                itemCount: ScheduleFilter.values.length,
                separatorBuilder: (_, __) => const Gap.h(8),
                itemBuilder: (_, i) {
                  final f = ScheduleFilter.values[i];
                  return Obx(() => _FilterTab(
                        label: f.label,
                        selected: controller.filter.value == f,
                        onTap: () => controller.selectFilter(f),
                      ));
                },
              ),
            ),
            const Gap.v(8),
            Expanded(
              child: Obx(() {
                final items = controller.filtered;
                if (items.isEmpty) {
                  return EmptyState(
                    icon: AppIcons.calendar,
                    title: controller.filter.value.label,
                    message: controller.emptyMessage,
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                      AppSize.pagePadding, 12.h, AppSize.pagePadding, 100.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Gap.v(12),
                  itemBuilder: (_, i) => ScheduleCard(
                    schedule: items[i],
                    onTap: () => controller.openDetails(items[i].id),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? p.gradient : null,
          color: selected ? null : p.surface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: selected ? Colors.transparent : p.border),
        ),
        child: CustomText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.white : p.textSecondary,
        ),
      ),
    );
  }
}
