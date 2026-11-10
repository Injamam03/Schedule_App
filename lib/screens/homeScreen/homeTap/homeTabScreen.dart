import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/screens/homeScreen/homeTap/controller/homeTapController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/homeTap/widget/dashboardCard.dart';
import 'package:jamal_flutter_app/screens/homeScreen/homeTap/widget/infoLine.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_avatar/custom_avatar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';
import 'package:jamal_flutter_app/widgers/empty_state/empty_state.dart';

class HomeTabScreen extends GetView<HomeTabController> {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            AppSize.pagePadding, 12.h, AppSize.pagePadding, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(controller: controller),
            const Gap.v(20),
            _SetupCard(onTap: controller.openCreateSchedule),
            const Gap.v(20),
            _CurrentlyWorking(controller: controller),
            const Gap.v(16),
            _NextSchedule(controller: controller),
            const Gap.v(16),
            _RecentlyCompleted(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Obx(() {
      final user = controller.user;
      final unread = controller.unreadNotifications;
      return Row(
        children: [
          CustomAvatar(user: user, size: 48),
          const Gap.h(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(AppConstString.welcomeBack, fontSize: 12.5, color: p.textSecondary),
                const Gap.v(2),
                CustomText(
                  user?.name ?? '',
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const Gap.h(8),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: controller.openNotifications,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    color: p.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: p.border),
                  ),
                  child: Icon(AppIcons.notification, size: AppSize.iconM, color: p.primary),
                ),
                if (unread > 0)
                  Positioned(
                    right: -2.w,
                    top: -2.h,
                    child: Container(
                      constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: p.background, width: 1.5),
                      ),
                      child: Center(
                        child: CustomText(
                          unread > 9 ? '9+' : '$unread',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _SetupCard extends StatelessWidget {
  const _SetupCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: true,
      padding: EdgeInsets.all(18.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  AppConstString.setupTitle,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
                const Gap.v(6),
                CustomText(
                  AppConstString.setupDescription,
                  fontSize: 12.5,
                  color: AppColors.primary4,
                  height: 1.45,
                ),
                const Gap.v(14),
                CustomButton(
                  label: AppConstString.setupButton,
                  icon: AppIcons.add,
                  type: CustomButtonType.light,
                  fullWidth: false,
                  height: 40.h,
                  fontSize: 13,
                  onTap: onTap,
                ),
              ],
            ),
          ),
          const Gap.h(8),
          Icon(AppIcons.schedule, size: 76.w, color: AppColors.white.withValues(alpha: 0.22)),
        ],
      ),
    );
  }
}

class _CurrentlyWorking extends StatelessWidget {
  const _CurrentlyWorking({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s = controller.active;
      final now = controller.now;
      return DashboardCard(
        title: AppConstString.currentlyWorking,
        icon: AppIcons.active,
        onTap: s == null ? null : () => controller.openDetails(s.id),
        child: s == null
            ? EmptyState(
                compact: true,
                icon: AppIcons.task,
                title: AppConstString.noActiveSchedule,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(s.title, fontSize: 16.5, fontWeight: FontWeight.w700, maxLines: 1),
                  const Gap.v(8),
                  InfoLine(
                    icon: AppIcons.clock,
                    text: AppConstString.startedAt(
                      AppDateUtils.formatTime(s.scheduledAt),
                      AppDateUtils.formatDuration(now.difference(s.scheduledAt)),
                    ),
                  ),
                  if (s.description.isNotEmpty) ...[
                    const Gap.v(8),
                    CustomText(
                      s.description,
                      fontSize: 12.5,
                      color: AppColors.of(context).textHint,
                      maxLines: 2,
                      height: 1.4,
                    ),
                  ],
                  const Gap.v(14),
                  CustomButton(
                    label: AppConstString.markAsComplete,
                    icon: AppIcons.task,
                    height: 42.h,
                    fontSize: 13,
                    onTap: () => controller.completeActive(s.id),
                  ),
                ],
              ),
      );
    });
  }
}

class _NextSchedule extends StatelessWidget {
  const _NextSchedule({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ScheduleModel? s = controller.next;
      final now = controller.now;
      return DashboardCard(
        title: AppConstString.nextSchedule,
        icon: AppIcons.next,
        onTap: s == null ? null : () => controller.openDetails(s.id),
        child: s == null
            ? EmptyState(
                compact: true,
                icon: AppIcons.calendar,
                title: AppConstString.noNextSchedule,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(s.title, fontSize: 16.5, fontWeight: FontWeight.w700, maxLines: 1),
                  const Gap.v(8),
                  InfoLine(icon: AppIcons.calendar, text: AppDateUtils.formatDate(s.scheduledAt)),
                  const Gap.v(6),
                  InfoLine(icon: AppIcons.clock, text: AppDateUtils.formatTime(s.scheduledAt)),
                  const Gap.v(10),
                  CustomText(
                    AppConstString.startsIn(
                        AppDateUtils.formatDuration(s.scheduledAt.difference(now))),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.of(context).primary,
                  ),
                ],
              ),
      );
    });
  }
}

class _RecentlyCompleted extends StatelessWidget {
  const _RecentlyCompleted({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s = controller.recentlyCompleted;
      return DashboardCard(
        title: AppConstString.recentlyCompleted,
        icon: AppIcons.completed,
        accent: AppColors.success,
        onTap: s == null ? null : () => controller.openDetails(s.id),
        child: s == null
            ? EmptyState(
                compact: true,
                icon: AppIcons.task,
                title: AppConstString.noCompleted,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(s.title, fontSize: 16.5, fontWeight: FontWeight.w700, maxLines: 1),
                  const Gap.v(8),
                  InfoLine(
                    icon: AppIcons.completed,
                    text: AppConstString.completedOn(
                        AppDateUtils.formatDateTime(s.completedAt ?? s.scheduledAt)),
                  ),
                ],
              ),
      );
    });
  }
}
