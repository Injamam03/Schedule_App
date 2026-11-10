import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return AppBar(
      backgroundColor: p.background,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              onPressed: Get.back,
              icon: Icon(AppIcons.arrowBack, size: AppSize.iconS, color: p.textPrimary),
            )
          : null,
      title: CustomText(title, fontSize: 18, fontWeight: FontWeight.w700),
      actions: actions,
    );
  }
}
