import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/profileScreen/createNote/controller/createNoteController.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_app_bar/custom_app_bar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text_Field/customtextfield.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';

class CreateNoteScreen extends GetView<CreateNoteController> {
  const CreateNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: controller.isEditing
            ? AppConstString.editNoteTitle
            : AppConstString.createNoteTitle,
        actions: [
          if (controller.isEditing)
            IconButton(
              onPressed: controller.delete,
              icon: Icon(AppIcons.delete, size: AppSize.iconM, color: AppColors.error),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSize.pagePadding),
                child: CustomCard(
                  padding: EdgeInsets.all(18.w),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controller.titleController,
                          label: AppConstString.noteTitleLabel,
                          hint: AppConstString.noteTitleHint,
                          prefixIcon: AppIcons.title,
                          textInputAction: TextInputAction.next,
                          maxLength: 80,
                        ),
                        const Gap.v(16),
                        CustomTextField(
                          controller: controller.contentController,
                          label: AppConstString.noteContentLabel,
                          hint: AppConstString.noteContentHint,
                          minLines: 10,
                          maxLines: 16,
                          keyboardType: TextInputType.multiline,
                          validator: controller.validateContent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSize.pagePadding, 8.h, AppSize.pagePadding, 14.h),
                child: Obx(() => CustomButton(
                      label: AppConstString.saveNote,
                      isLoading: controller.isSaving.value,
                      onTap: controller.save,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
