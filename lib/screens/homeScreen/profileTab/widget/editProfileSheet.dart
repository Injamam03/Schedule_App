import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/controller/profiletapController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/widget/optionTile.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custom_text_Field/customtextfield.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key, required this.controller});

  final ProfileTabController controller;

  static void show(ProfileTabController controller) {
    Get.bottomSheet(
      EditProfileSheet(controller: controller),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.radiusXL)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: p.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            const Gap.v(18),
            CustomText(AppConstString.editProfile, fontSize: 18, fontWeight: FontWeight.w800),
            const Gap.v(4),
            CustomText(AppConstString.editProfileSubtitle, fontSize: 13, color: p.textSecondary),
            const Gap.v(14),
            CustomCard(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                children: [
                  OptionTile(
                    icon: AppIcons.edit,
                    title: AppConstString.changeName,
                    subtitle: AppConstString.changeNameSubtitle,
                    onTap: () {
                      Get.back();
                      ChangeNameDialog.show(controller);
                    },
                  ),
                  OptionTile(
                    icon: AppIcons.camera,
                    title: AppConstString.changeProfilePhoto,
                    subtitle: AppConstString.changeProfilePhotoSubtitle,
                    onTap: () {
                      Get.back();
                      PhotoSourceSheet.show(controller);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoSourceSheet extends StatelessWidget {
  const PhotoSourceSheet({super.key, required this.controller});

  final ProfileTabController controller;

  static void show(ProfileTabController controller) {
    Get.bottomSheet(
      PhotoSourceSheet(controller: controller),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.radiusXL)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: p.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            const Gap.v(18),
            CustomText(AppConstString.choosePhotoSource, fontSize: 18, fontWeight: FontWeight.w800),
            const Gap.v(14),
            CustomCard(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                children: [
                  OptionTile(
                    icon: AppIcons.photo,
                    title: AppConstString.fromGallery,
                    onTap: () {
                      Get.back();
                      controller.changeAvatar(ImageSource.gallery);
                    },
                  ),
                  OptionTile(
                    icon: AppIcons.camera,
                    title: AppConstString.fromCamera,
                    onTap: () {
                      Get.back();
                      controller.changeAvatar(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeNameDialog extends StatefulWidget {
  const ChangeNameDialog({super.key, required this.controller});

  final ProfileTabController controller;

  static void show(ProfileTabController controller) {
    Get.dialog(ChangeNameDialog(controller: controller));
  }

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.controller.user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.controller.updateName(_nameController.text);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return AlertDialog(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.radiusL)),
      title: CustomText(AppConstString.changeName, fontSize: 18, fontWeight: FontWeight.w700),
      content: Form(
        key: _formKey,
        child: CustomTextField(
          controller: _nameController,
          label: AppConstString.enterName,
          prefixIcon: AppIcons.profile,
          maxLength: 40,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? AppConstString.nameRequired : null,
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: CustomText(
            AppConstString.cancel,
            fontWeight: FontWeight.w600,
            color: p.textSecondary,
          ),
        ),
        TextButton(
          onPressed: _submit,
          child: CustomText(
            AppConstString.save,
            fontWeight: FontWeight.w700,
            color: p.primary,
          ),
        ),
      ],
    );
  }
}
