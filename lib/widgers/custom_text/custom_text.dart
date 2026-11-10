import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';

/// App-wide text widget. Use this instead of Flutter's Text.
class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.decoration,
    this.fontStyle,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.of(context).textPrimary,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
        fontStyle: fontStyle,
      ),
    );
  }
}
