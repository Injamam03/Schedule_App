import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/homeScreen/homeTap/homeTabScreen.dart';
import 'package:jamal_flutter_app/screens/homeScreen/mainScreen/controller/mainController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/profileTabScreen.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/scheduleTabScreen.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeTabScreen(),
              ScheduleTabScreen(),
              ProfileTabScreen(),
            ],
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: p.surface,
          border: Border(top: BorderSide(color: p.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Obx(() => Row(
                  children: [
                    _NavItem(
                      icon: AppIcons.home,
                      label: AppConstString.navHome,
                      selected: controller.selectedIndex.value == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    _NavItem(
                      icon: AppIcons.schedule,
                      label: AppConstString.navSchedule,
                      selected: controller.selectedIndex.value == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                    _NavItem(
                      icon: AppIcons.profile,
                      label: AppConstString.navProfile,
                      selected: controller.selectedIndex.value == 2,
                      onTap: () => controller.changeTab(2),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
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
    final color = selected ? p.primary : p.textHint;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.radiusM),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: selected ? p.surfaceVariant : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(icon, size: AppSize.iconM + 2.w, color: color),
              ),
              const Gap.v(2),
              CustomText(
                label,
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
