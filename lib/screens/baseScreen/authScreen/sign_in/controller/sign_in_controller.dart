import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_config.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/auth_service.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  static final RegExp _emailRegex = RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$');

  String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppConstString.emailRequired;
    if (!_emailRegex.hasMatch(v)) return AppConstString.emailInvalid;
    return null;
  }

  String? validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AppConstString.passwordRequired;
    if (v.length < AppConfig.minPasswordLength) return AppConstString.passwordTooShort;
    return null;
  }

  Future<void> signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      await AuthService.to.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      AppLog.e('Sign in failed', e);
      AppSnack.error(AppConstString.signInFailed);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
