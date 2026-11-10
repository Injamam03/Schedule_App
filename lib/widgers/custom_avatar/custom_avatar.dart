import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamal_flutter_app/constant/app_assert_image.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/model/app_user_data.dart';
import 'package:jamal_flutter_app/utils/app_files.dart';

/// Circular profile picture; falls back to the placeholder asset.
class CustomAvatar extends StatelessWidget {
  const CustomAvatar({super.key, required this.user, this.size = 48, this.onTap});

  final AppUserData? user;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final fileName = user?.avatarFileName;
    final ImageProvider image = (fileName != null && AppFiles.avatar(fileName).existsSync())
        ? FileImage(AppFiles.avatar(fileName))
        : const AssetImage(AppImages.avatarPlaceholder);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: p.primary, width: 2),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
