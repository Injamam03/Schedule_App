import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/controller/profiletapController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/widget/optionTile.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/widget/themeSheet.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_avatar/custom_avatar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

class ProfileTabScreen extends GetView<ProfileTabController> {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(AppSize.pagePadding, 16.h, AppSize.pagePadding, 24.h),
        child: Column(
          children: [
            Obx(() {
              final user = controller.user;
              return Column(
                children: [
                  Stack(
                    children: [
                      CustomAvatar(user: user, size: 96, onTap: controller.changeAvatar),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: controller.changeAvatar,
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              gradient: p.gradient,
                              shape: BoxShape.circle,
                              border: Border.all(color: p.background, width: 2.5),
                            ),
                            child: Icon(AppIcons.camera, size: 16.w, color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap.v(14),
                  CustomText(
                    user?.name ?? '',
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                  ),
                  const Gap.v(3),
                  CustomText(user?.email ?? '', fontSize: 13, color: p.textSecondary),
                ],
              );
            }),
            const Gap.v(22),
            _StatsCard(controller: controller),
            const Gap.v(18),
            CustomCard(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                children: [
                  OptionTile(
                    icon: AppIcons.note,
                    title: AppConstString.createNote,
                    subtitle: AppConstString.createNoteSubtitle,
                    onTap: controller.openNotes,
                  ),
                  OptionTile(
                    icon: AppIcons.photo,
                    title: AppConstString.savePhoto,
                    subtitle: AppConstString.savePhotoSubtitle,
                    onTap: controller.openPhotos,
                  ),
                  Obx(() => OptionTile(
                        icon: AppIcons.theme,
                        title: AppConstString.changeTheme,
                        subtitle: controller.themeLabel,
                        onTap: () => ThemeSheet.show(controller),
                      )),
                  OptionTile(
                    icon: AppIcons.logout,
                    title: AppConstString.logout,
                    isDestructive: true,
                    onTap: controller.logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.controller});

  final ProfileTabController controller;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return CustomCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  AppConstString.statistics,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: p.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSize.radiusS),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StatsPeriod>(
                        value: controller.period.value,
                        dropdownColor: p.surface,
                        borderRadius: BorderRadius.circular(AppSize.radiusM),
                        icon: Icon(AppIcons.dropdown, color: p.primary),
                        onChanged: controller.selectPeriod,
                        items: [
                          for (final period in StatsPeriod.values)
                            DropdownMenuItem(
                              value: period,
                              child: CustomText(
                                period.label,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          const Gap.v(16),
          Obx(() => Row(
                children: [
                  _StatTile(
                    icon: AppIcons.total,
                    color: p.primary,
                    value: controller.totalCount,
                    label: AppConstString.statTotal,
                  ),
                  const Gap.h(10),
                  _StatTile(
                    icon: AppIcons.completed,
                    color: AppColors.success,
                    value: controller.completedCount,
                    label: AppConstString.statCompleted,
                  ),
                  const Gap.h(10),
                  _StatTile(
                    icon: AppIcons.missed,
                    color: AppColors.error,
                    value: controller.missedCount,
                    label: AppConstString.statMissed,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: p.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSize.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, size: AppSize.iconL, color: color),
            const Gap.v(8),
            CustomText('$value', fontSize: 22, fontWeight: FontWeight.w800),
            const Gap.v(2),
            CustomText(
              label,
              fontSize: 11.5,
              color: p.textSecondary,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
