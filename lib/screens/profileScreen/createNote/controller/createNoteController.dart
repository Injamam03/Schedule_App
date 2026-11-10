import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/note_model.dart';
import 'package:jamal_flutter_app/services/note_service.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';
import 'package:jamal_flutter_app/widgers/confirmDialog/confirmDialog.dart';

/// Create a note, or edit one when a NoteModel is passed as arguments.
class CreateNoteController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final RxBool isSaving = false.obs;

  NoteModel? editing;
  bool get isEditing => editing != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is NoteModel) {
      editing = args;
      titleController.text = args.title;
      contentController.text = args.content;
    }
  }

  String? validateContent(String? value) =>
      (value == null || value.trim().isEmpty) ? AppConstString.noteContentRequired : null;

  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    isSaving.value = true;
    try {
      await NoteService.to.save(
        existing: editing,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
      );
      Get.back();
      AppSnack.success(AppConstString.noteSaved);
    } catch (e) {
      AppLog.e('Saving note failed', e);
      AppSnack.error(AppConstString.somethingWentWrong);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> delete() async {
    final note = editing;
    if (note == null) return;
    final ok = await ConfirmDialog.show(
      title: AppConstString.deleteNoteTitle,
      message: AppConstString.deleteNoteMessage,
      confirmLabel: AppConstString.delete,
      isDestructive: true,
    );
    if (!ok) return;
    await NoteService.to.delete(note.id);
    Get.back();
    AppSnack.success(AppConstString.noteDeleted);
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
