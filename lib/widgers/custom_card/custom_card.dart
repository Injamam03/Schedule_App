import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.gradient = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// Paints the Deep Azure gradient instead of the surface colour.
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final radius = BorderRadius.circular(AppSize.radiusL);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient ? null : p.surface,
        gradient: gradient ? p.gradient : null,
        borderRadius: radius,
        border: gradient ? null : Border.all(color: p.border),
        boxShadow: [
          BoxShadow(color: p.shadow, blurRadius: 14.r, offset: Offset(0, 6.h)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.all(16.w),
            child: child,
          ),
        ),
      ),
    );
  }
}
