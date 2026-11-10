import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  /// Smaller, left-aligned variant used inside dashboard cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    if (compact) {
      return Row(
        children: [
          Icon(icon, size: AppSize.iconM, color: p.textHint),
          const Gap.h(10),
          Expanded(
            child: CustomText(title, fontSize: 13, color: p.textSecondary, height: 1.4),
          ),
        ],
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84.w,
              height: 84.w,
              decoration: BoxDecoration(color: p.surfaceVariant, shape: BoxShape.circle),
              child: Icon(icon, size: 40.w, color: p.primary),
            ),
            const Gap.v(16),
            CustomText(
              title,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const Gap.v(6),
              CustomText(
                message!,
                fontSize: 13,
                color: p.textSecondary,
                textAlign: TextAlign.center,
                height: 1.45,
              ),
            ],
            if (action != null) ...[const Gap.v(20), action!],
          ],
        ),
      ),
    );
  }
}
