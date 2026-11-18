import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

enum CustomButtonType { filled, outlined, light }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.type = CustomButtonType.filled,
    this.icon,
    this.imagePath,
    this.isLoading = false,
    this.color,
    this.height,
    this.fullWidth = true,
    this.fontSize = 15,
  });

  final String label;
  final VoidCallback? onTap;
  final CustomButtonType type;
  final IconData? icon;
  final String? imagePath;
  final bool isLoading;

  /// Overrides the accent colour of outlined buttons (e.g. destructive).
  final Color? color;
  final double? height;
  final bool fullWidth;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final enabled = onTap != null && !isLoading;
    final radius = BorderRadius.circular(AppSize.radiusM);

    final Color foreground;
    BoxDecoration decoration;
    switch (type) {
      case CustomButtonType.filled:
        foreground = AppColors.white;
        decoration = BoxDecoration(gradient: p.gradient, borderRadius: radius);
        break;
      case CustomButtonType.light:
        foreground = AppColors.navy1;
        decoration = BoxDecoration(color: AppColors.white, borderRadius: radius);
        break;
      case CustomButtonType.outlined:
        foreground = color ?? p.primary;
        decoration = BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: foreground, width: 1.4),
        );
        break;
    }

    final content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: foreground),
          )
        else ...[
          if (imagePath != null) ...[
            Image.asset(imagePath!, width: AppSize.iconS, height: AppSize.iconS),
            const Gap.h(8),
          ] else if (icon != null) ...[
            Icon(icon, size: AppSize.iconS, color: foreground),
            const Gap.h(8),
          ],
          CustomText(
            label,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ],
      ],
    );

    return Opacity(
      opacity: enabled || isLoading ? 1 : 0.5,
      child: Container(
        height: height ?? AppSize.buttonHeight,
        width: fullWidth ? double.infinity : null,
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }
}
