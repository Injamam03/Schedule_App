import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final color = isDestructive ? AppColors.error : p.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusM),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(AppSize.radiusS),
              ),
              child: Icon(icon, size: AppSize.iconM, color: color),
            ),
            const Gap.h(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? AppColors.error : p.textPrimary,
                  ),
                  if (subtitle != null) ...[
                    const Gap.v(2),
                    CustomText(subtitle!, fontSize: 12, color: p.textHint),
                  ],
                ],
              ),
            ),
            Icon(AppIcons.chevronRight, size: AppSize.iconM, color: p.textHint),
          ],
        ),
      ),
    );
  }
}
