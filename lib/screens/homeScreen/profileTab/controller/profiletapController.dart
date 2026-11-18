import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/core/theme/theme_controller.dart';
import 'package:jamal_flutter_app/model/app_user_data.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/widget/editProfileSheet.dart';
import 'package:jamal_flutter_app/services/auth_service.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';
import 'package:jamal_flutter_app/widgers/logoutDialog/logoutDialog.dart';

enum StatsPeriod { week, month }

extension StatsPeriodX on StatsPeriod {
  String get label => this == StatsPeriod.week
      ? AppConstString.thisWeek
      : AppConstString.thisMonth;
}

class ProfileTabController extends GetxController {
  final ScheduleService _schedules = ScheduleService.to;
  final Rx<StatsPeriod> period = StatsPeriod.week.obs;

  AppUserData? get user => AuthService.to.user.value;

  void selectPeriod(StatsPeriod? value) {
    if (value != null) period.value = value;
  }

  /// Schedules whose scheduled time falls inside the selected period.
  List<ScheduleModel> get _inPeriod {
    final t = _schedules.now.value;
    final DateTime start;
    final DateTime end;
    if (period.value == StatsPeriod.week) {
      start = AppDateUtils.startOfWeek(t);
      end = AppDateUtils.startOfNextWeek(t);
    } else {
      start = AppDateUtils.startOfMonth(t);
      end = AppDateUtils.startOfNextMonth(t);
    }
    return _schedules.schedules
        .where((s) => !s.scheduledAt.isBefore(start) && s.scheduledAt.isBefore(end))
        .toList();
  }

  int get totalCount => _inPeriod.length;
  int get completedCount =>
      _inPeriod.where((s) => s.status == ScheduleStatus.completed).length;
  int get missedCount =>
      _inPeriod.where((s) => s.status == ScheduleStatus.missed).length;

  void showEditProfileOptions() => EditProfileSheet.show(this);
  void showPhotoSourcePicker() => PhotoSourceSheet.show(this);

  Future<void> updateName(String name) async {
    try {
      await AuthService.to.updateName(name);
      AppSnack.success(AppConstString.nameUpdated);
    } catch (e) {
      AppLog.e('Updating name failed', e);
      AppSnack.error(AppConstString.somethingWentWrong);
    }
  }

  Future<void> changeAvatar([ImageSource source = ImageSource.gallery]) async {
    try {
      await AuthService.to.changeAvatar(source);
    } catch (e) {
      AppLog.e('Changing avatar failed', e);
      AppSnack.error(AppConstString.somethingWentWrong);
    }
  }

  void openNotes() => Get.toNamed(AppRoutes.notes);
  void openPhotos() => Get.toNamed(AppRoutes.savedPhotos);

  ThemeMode get themeMode => ThemeController.to.mode.value;

  String get themeLabel => switch (themeMode) {
        ThemeMode.light => AppConstString.themeLight,
        ThemeMode.dark => AppConstString.themeDark,
        ThemeMode.system => AppConstString.themeSystem,
      };

  Future<void> setTheme(ThemeMode mode) async {
    await ThemeController.to.setMode(mode);
    Get.back();
  }

  Future<void> logout() async {
    final confirmed = await LogoutDialog.show();
    if (!confirmed) return;
    await AuthService.to.signOut();
    Get.offAllNamed(AppRoutes.signIn);
  }
}
