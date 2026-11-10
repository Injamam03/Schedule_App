import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/createSchedule/controller/createScheduleController.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_app_bar/custom_app_bar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custom_text_Field/customtextfield.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';

class CreateScheduleScreen extends GetView<CreateScheduleController> {
  const CreateScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: controller.isEditing
            ? AppConstString.editScheduleTitle
            : AppConstString.createScheduleTitle,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSize.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      AppConstString.createScheduleSubtitle,
                      fontSize: 13.5,
                      color: p.textSecondary,
                      height: 1.45,
                    ),
                    const Gap.v(16),
                    CustomCard(
                      padding: EdgeInsets.all(18.w),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: controller.titleController,
                              label: AppConstString.scheduleTitleLabel,
                              hint: AppConstString.scheduleTitleHint,
                              prefixIcon: AppIcons.title,
                              textInputAction: TextInputAction.next,
                              maxLength: 80,
                              validator: (v) =>
                                  controller.requiredValidator(v, AppConstString.titleRequired),
                            ),
                            const Gap.v(16),
                            CustomTextField(
                              controller: controller.dateController,
                              label: AppConstString.dateLabel,
                              hint: AppConstString.dateHint,
                              prefixIcon: AppIcons.calendar,
                              readOnly: true,
                              onTap: () => controller.pickDate(context),
                              validator: (v) =>
                                  controller.requiredValidator(v, AppConstString.dateRequired),
                            ),
                            const Gap.v(16),
                            CustomTextField(
                              controller: controller.timeController,
                              label: AppConstString.timeLabel,
                              hint: AppConstString.timeHint,
                              prefixIcon: AppIcons.clock,
                              readOnly: true,
                              onTap: () => controller.pickTime(context),
                              validator: (v) =>
                                  controller.requiredValidator(v, AppConstString.timeRequired),
                            ),
                            const Gap.v(16),
                            CustomTextField(
                              controller: controller.descriptionController,
                              label: AppConstString.descriptionLabel,
                              hint: AppConstString.descriptionHint,
                              minLines: 4,
                              maxLines: 6,
                              maxLength: 500,
                              keyboardType: TextInputType.multiline,
                              validator: (v) => controller.requiredValidator(
                                  v, AppConstString.descriptionRequired),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSize.pagePadding, 8.h, AppSize.pagePadding, 14.h),
                child: Obx(() => CustomButton(
                      label: controller.isEditing
                          ? AppConstString.saveChanges
                          : AppConstString.schedule,
                      isLoading: controller.isSaving.value,
                      onTap: controller.submit,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
