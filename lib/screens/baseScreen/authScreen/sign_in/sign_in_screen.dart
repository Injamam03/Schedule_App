import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_assert_image.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/baseScreen/authScreen/sign_in/controller/sign_in_controller.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custom_text_Field/customtextfield.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    AppSize.pagePadding, 80.h, AppSize.pagePadding, 56.h),
                decoration: BoxDecoration(
                  gradient: p.gradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(AppSize.radiusXL + 8.r),
                  ),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radiusL),
                      child: Image.asset(AppImages.logo, width: 76.w, height: 76.w),
                    ),
                    const Gap.v(18),
                    CustomText(
                      AppConstString.appName,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                    const Gap.v(6),
                    CustomText(
                      AppConstString.appTagline,
                      fontSize: 13.5,
                      color: AppColors.primary4,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSize.pagePadding),
                child: CustomCard(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(AppConstString.welcomeBackTitle,
                            fontSize: 21, fontWeight: FontWeight.w800),
                        const Gap.v(4),
                        CustomText(AppConstString.signInSubtitle,
                            fontSize: 13, color: p.textSecondary),
                        const Gap.v(22),
                        CustomTextField(
                          controller: controller.emailController,
                          label: AppConstString.email,
                          hint: AppConstString.emailHint,
                          prefixIcon: AppIcons.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateEmail,
                        ),
                        const Gap.v(16),
                        CustomTextField(
                          controller: controller.passwordController,
                          label: AppConstString.password,
                          hint: AppConstString.passwordHint,
                          prefixIcon: AppIcons.lock,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: controller.validatePassword,
                          onSubmitted: (_) => controller.signIn(),
                        ),
                        const Gap.v(24),
                        Obx(() => CustomButton(
                              label: AppConstString.signIn,
                              isLoading: controller.isLoading.value,
                              onTap: controller.signIn,
                            )),
                        const Gap.v(12),
                        // TODO(google_auth): Replace demo icon below with actual Google logo asset (e.g. assets/images/google_logo.png)
                        CustomButton(
                          label: AppConstString.continueWithGoogle,
                          type: CustomButtonType.outlined,
                          icon: Icons.g_mobiledata_rounded,
                          onTap: controller.continueWithGoogle,
                        ),
                        const Gap.v(16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(AppIcons.info, size: AppSize.iconS, color: p.textHint),
                            const Gap.h(8),
                            Expanded(
                              child: CustomText(
                                AppConstString.demoLoginNote,
                                fontSize: 12,
                                color: p.textHint,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
