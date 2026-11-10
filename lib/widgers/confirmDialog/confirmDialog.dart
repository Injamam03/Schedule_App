import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

/// Generic yes/no dialog. `await ConfirmDialog.show(...)` -> true when confirmed.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;

  static Future<bool> show({
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return AlertDialog(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.radiusL)),
      title: CustomText(title, fontSize: 18, fontWeight: FontWeight.w700),
      content: CustomText(message, fontSize: 14, color: p.textSecondary, height: 1.45),
      actionsPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: CustomText(
            cancelLabel ?? AppConstString.cancel,
            fontWeight: FontWeight.w600,
            color: p.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: CustomText(
            confirmLabel,
            fontWeight: FontWeight.w700,
            color: isDestructive ? AppColors.error : p.primary,
          ),
        ),
      ],
    );
  }
}
