import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

/// Titled card used by the three Home dashboard sections.
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.accent,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final color = accent ?? p.primary;
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppSize.radiusS),
                ),
                child: Icon(icon, size: AppSize.iconM, color: color),
              ),
              const Gap.h(12),
              CustomText(title, fontSize: 15, fontWeight: FontWeight.w700),
            ],
          ),
          const Gap.v(14),
          child,
        ],
      ),
    );
  }
}
