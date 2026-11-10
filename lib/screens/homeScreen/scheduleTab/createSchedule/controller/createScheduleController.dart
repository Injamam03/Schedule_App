import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/screens/homeScreen/mainScreen/controller/mainController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/controller/scheduleTabController.dart';
import 'package:jamal_flutter_app/services/notification_service.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';

/// Used for both "create" and "edit" (pass a ScheduleModel as arguments).
class CreateScheduleController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final RxBool isSaving = false.obs;

  ScheduleModel? editing;
  DateTime? _date;
  TimeOfDay? _time;

  bool get isEditing => editing != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ScheduleModel) {
      editing = args;
      titleController.text = args.title;
      descriptionController.text = args.description;
      _date = AppDateUtils.startOfDay(args.scheduledAt);
      _time = TimeOfDay.fromDateTime(args.scheduledAt);
      dateController.text = AppDateUtils.formatDate(args.scheduledAt);
      timeController.text = AppDateUtils.formatTime(args.scheduledAt);
    }
  }

  String? requiredValidator(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  Future<void> pickDate(BuildContext context) async {
    final today = AppDateUtils.startOfDay(DateTime.now());
    final initial = (_date != null && !_date!.isBefore(today)) ? _date! : today;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(today.year + 5, today.month, today.day),
    );
    if (picked == null) return;
    _date = picked;
    dateController.text = AppDateUtils.formatDate(picked);
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    _time = picked;
    timeController.text =
        AppDateUtils.formatTime(AppDateUtils.combine(DateTime.now(), picked));
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (_date == null || _time == null) return;

    final when = AppDateUtils.combine(_date!, _time!);
    if (!when.isAfter(DateTime.now())) {
      AppSnack.error(AppConstString.pastDateError);
      return;
    }

    isSaving.value = true;
    try {
      final notifications = NotificationService.to;
      final granted = await notifications.requestPermissions();
      await notifications.ensureExactAlarmAccess();

      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final service = ScheduleService.to;

      if (isEditing) {
        final current = service.byId(editing!.id);
        if (current == null || !current.canCancel(DateTime.now())) {
          AppSnack.error(AppConstString.editNotAllowed);
          return;
        }
        await service.updateDetails(
          current,
          title: title,
          description: description,
          scheduledAt: when,
        );
        Get.back();
        AppSnack.success(AppConstString.scheduleUpdated);
        return;
      }

      await service.create(title: title, description: description, scheduledAt: when);
      Get.back();
      if (Get.isRegistered<MainController>()) {
        MainController.to.goToSchedule(ScheduleFilter.upcoming);
      }
      if (granted) {
        AppSnack.success(AppConstString.scheduleCreated);
      } else {
        AppSnack.info(AppConstString.scheduleCreatedNoNotifications);
      }
    } catch (e) {
      AppLog.e('Saving schedule failed', e);
      AppSnack.error(AppConstString.somethingWentWrong);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }
}
