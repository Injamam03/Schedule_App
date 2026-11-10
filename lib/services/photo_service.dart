import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/model/photo_model.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';
import 'package:jamal_flutter_app/utils/app_files.dart';
import 'package:path/path.dart' as p;

/// Photos are copied into app-private storage; only metadata is persisted.
class PhotoService extends GetxService {
  PhotoService(this._storage);

  static PhotoService get to => Get.find();

  final GetStorageService _storage;
  final RxList<PhotoModel> photos = <PhotoModel>[].obs;

  Future<PhotoService> init() async {
    final all = _storage.readList(AppStorageKey.photos).map(PhotoModel.fromJson).toList();
    // Drop records whose file vanished (e.g. cleared by the OS).
    final valid = <PhotoModel>[];
    for (final photo in all) {
      if (await AppFiles.photo(photo.fileName).exists()) valid.add(photo);
    }
    valid.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    photos.assignAll(valid);
    if (valid.length != all.length) await _persist();
    return this;
  }

  /// Opens the gallery (multi-select) and saves the picks. Returns the count.
  Future<int> addFromGallery() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 90);
    if (picked.isEmpty) return 0;

    var added = 0;
    for (final file in picked) {
      final id = await _storage.nextId(AppStorageKey.idCounter);
      final name = 'photo_$id${p.extension(file.path).toLowerCase()}';
      await AppFiles.photo(name).writeAsBytes(await file.readAsBytes());
      photos.insert(
        0,
        PhotoModel(id: id, fileName: name, createdAt: DateTime.now()),
      );
      added++;
    }
    await _persist();
    return added;
  }

  Future<void> delete(PhotoModel photo) async {
    await AppFiles.deleteQuietly(AppFiles.photo(photo.fileName));
    photos.removeWhere((p) => p.id == photo.id);
    await _persist();
  }

  Future<void> _persist() => _storage.write(
        AppStorageKey.photos,
        photos.map((p) => p.toJson()).toList(),
      );
}
