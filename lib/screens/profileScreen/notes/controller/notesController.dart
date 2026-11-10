import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/note_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/note_service.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';
import 'package:jamal_flutter_app/widgers/confirmDialog/confirmDialog.dart';

class NotesController extends GetxController {
  final NoteService _service = NoteService.to;

  List<NoteModel> get notes => _service.notes;

  void create() => Get.toNamed(AppRoutes.createNote);
  void edit(NoteModel note) => Get.toNamed(AppRoutes.createNote, arguments: note);

  Future<void> delete(NoteModel note) async {
    final ok = await ConfirmDialog.show(
      title: AppConstString.deleteNoteTitle,
      message: AppConstString.deleteNoteMessage,
      confirmLabel: AppConstString.delete,
      isDestructive: true,
    );
    if (!ok) return;
    await _service.delete(note.id);
    AppSnack.success(AppConstString.noteDeleted);
  }
}
