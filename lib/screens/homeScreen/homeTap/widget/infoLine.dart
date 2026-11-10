import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

/// Small icon + text row ("calendar · Mon, 10 Nov 2026").
class InfoLine extends StatelessWidget {
  const InfoLine({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Row(
      children: [
        Icon(icon, size: 16.w, color: p.textHint),
        const Gap.h(8),
        Expanded(
          child: CustomText(text, fontSize: 13, color: p.textSecondary, maxLines: 1),
        ),
      ],
    );
  }
}
