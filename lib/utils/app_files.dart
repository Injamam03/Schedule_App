import 'dart:io';

import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves files that live inside the app's private storage.
/// Only file *names* are persisted, so the app-container path can change
/// (iOS does this between updates) without breaking saved data.
class AppFiles {
  AppFiles._();

  static late Directory _root;

  static Future<void> init() async {
    _root = await getApplicationDocumentsDirectory();
    await photosDir.create(recursive: true);
    await avatarDir.create(recursive: true);
  }

  static Directory get photosDir =>
      Directory(p.join(_root.path, AppStorageKey.photosFolder));
  static Directory get avatarDir =>
      Directory(p.join(_root.path, AppStorageKey.avatarFolder));

  static File photo(String fileName) => File(p.join(photosDir.path, fileName));
  static File avatar(String fileName) => File(p.join(avatarDir.path, fileName));

  static Future<void> deleteQuietly(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
