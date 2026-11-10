import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/core/theme/theme_controller.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/controller/profiletapController.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

/// Bottom sheet with the three theme options.
class ThemeSheet extends StatelessWidget {
  const ThemeSheet({super.key, required this.controller});

  final ProfileTabController controller;

  static void show(ProfileTabController controller) {
    Get.bottomSheet(
      ThemeSheet(controller: controller),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.radiusXL)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: p.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            const Gap.v(18),
            CustomText(AppConstString.changeTheme, fontSize: 18, fontWeight: FontWeight.w800),
            const Gap.v(4),
            CustomText(AppConstString.themeSubtitle, fontSize: 13, color: p.textSecondary),
            const Gap.v(14),
            Obx(() {
              final selected = ThemeController.to.mode.value;
              return Column(
                children: [
                  _ThemeOption(
                    icon: AppIcons.lightMode,
                    label: AppConstString.themeLight,
                    selected: selected == ThemeMode.light,
                    onTap: () => controller.setTheme(ThemeMode.light),
                  ),
                  _ThemeOption(
                    icon: AppIcons.darkMode,
                    label: AppConstString.themeDark,
                    selected: selected == ThemeMode.dark,
                    onTap: () => controller.setTheme(ThemeMode.dark),
                  ),
                  _ThemeOption(
                    icon: AppIcons.systemMode,
                    label: AppConstString.themeSystem,
                    selected: selected == ThemeMode.system,
                    onTap: () => controller.setTheme(ThemeMode.system),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.radiusM),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: selected ? p.primary.withValues(alpha: 0.12) : p.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSize.radiusM),
            border: Border.all(color: selected ? p.primary : Colors.transparent, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, size: AppSize.iconM, color: selected ? p.primary : p.textSecondary),
              const Gap.h(14),
              Expanded(
                child: CustomText(label, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              if (selected) Icon(AppIcons.completed, size: AppSize.iconM, color: p.primary),
            ],
          ),
        ),
      ),
    );
  }
}
