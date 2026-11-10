import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/model/note_model.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';

abstract class NoteRepository {
  Future<List<NoteModel>> getAll();
  Future<int> nextId();
  Future<void> upsert(NoteModel note);
  Future<void> delete(int id);
}

class LocalNoteRepository implements NoteRepository {
  LocalNoteRepository(this._storage);

  final GetStorageService _storage;

  @override
  Future<List<NoteModel>> getAll() async =>
      _storage.readList(AppStorageKey.notes).map(NoteModel.fromJson).toList();

  @override
  Future<int> nextId() => _storage.nextId(AppStorageKey.idCounter);

  @override
  Future<void> upsert(NoteModel note) async {
    final list = _storage.readList(AppStorageKey.notes);
    final index = list.indexWhere((e) => e['id'] == note.id);
    if (index >= 0) {
      list[index] = note.toJson();
    } else {
      list.add(note.toJson());
    }
    await _storage.write(AppStorageKey.notes, list);
  }

  @override
  Future<void> delete(int id) async {
    final list = _storage.readList(AppStorageKey.notes)
      ..removeWhere((e) => e['id'] == id);
    await _storage.write(AppStorageKey.notes, list);
  }
}
