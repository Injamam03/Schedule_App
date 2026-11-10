import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';

class AppSnack {
  AppSnack._();

  static void success(String message, {String? title}) =>
      _show(title ?? '', message, AppColors.success);

  static void error(String message, {String? title}) =>
      _show(title ?? '', message, AppColors.error);

  static void info(String message, {String? title}) =>
      _show(title ?? '', message, AppColors.secondary1);

  static void _show(String title, String message, Color color) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      titleText: title.isEmpty ? const SizedBox.shrink() : null,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(14),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
    );
  }
}
