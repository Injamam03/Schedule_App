import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/photo_model.dart';
import 'package:jamal_flutter_app/screens/profileScreen/savedPhotos/controller/savedPhotosController.dart';
import 'package:jamal_flutter_app/utils/app_files.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/widgers/custom_app_bar/custom_app_bar.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';
import 'package:jamal_flutter_app/widgers/empty_state/empty_state.dart';

class SavedPhotosScreen extends GetView<SavedPhotosController> {
  const SavedPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstString.savedPhotosTitle,
        actions: [
          IconButton(
            onPressed: controller.addPhotos,
            icon: Icon(AppIcons.add, size: AppSize.iconL, color: p.primary),
          ),
        ],
      ),
      body: Obx(() {
        final photos = controller.photos;
        if (photos.isEmpty) {
          return EmptyState(
            icon: AppIcons.photo,
            title: AppConstString.noPhotos,
            message: AppConstString.noPhotosMessage,
            action: CustomButton(
              label: AppConstString.addPhotos,
              icon: AppIcons.add,
              fullWidth: false,
              height: 44.h,
              isLoading: controller.isBusy.value,
              onTap: controller.addPhotos,
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSize.pagePadding, 4.h, AppSize.pagePadding, 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  AppConstString.photoCount(photos.length),
                  fontSize: 13,
                  color: p.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                    AppSize.pagePadding, 4.h, AppSize.pagePadding, 24.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.w,
                ),
                itemCount: photos.length,
                itemBuilder: (_, i) => _PhotoTile(
                  photo: photos[i],
                  onTap: () => controller.open(i),
                  onLongPress: () => controller.delete(photos[i]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo, required this.onTap, required this.onLongPress});

  final PhotoModel photo;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.radiusM),
        child: Image.file(
          AppFiles.photo(photo.fileName),
          fit: BoxFit.cover,
          cacheWidth: 400,
          errorBuilder: (_, __, ___) => Container(
            color: p.surfaceVariant,
            child: Icon(AppIcons.image, color: p.textHint),
          ),
        ),
      ),
    );
  }
}
