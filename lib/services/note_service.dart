import 'package:get/get.dart';
import 'package:jamal_flutter_app/model/note_model.dart';
import 'package:jamal_flutter_app/services/repository/note_repository.dart';

class NoteService extends GetxService {
  NoteService(this._repo);

  static NoteService get to => Get.find();

  final NoteRepository _repo;
  final RxList<NoteModel> notes = <NoteModel>[].obs;

  Future<NoteService> init() async {
    final all = await _repo.getAll();
    all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notes.assignAll(all);
    return this;
  }

  Future<void> save({NoteModel? existing, required String title, required String content}) async {
    final stamp = DateTime.now();
    final note = existing == null
        ? NoteModel(
            id: await _repo.nextId(),
            title: title,
            content: content,
            createdAt: stamp,
            updatedAt: stamp,
          )
        : existing.copyWith(title: title, content: content, updatedAt: stamp);
    await _repo.upsert(note);
    notes.removeWhere((n) => n.id == note.id);
    notes.insert(0, note);
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    notes.removeWhere((n) => n.id == id);
  }
}
