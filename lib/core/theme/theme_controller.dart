import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';

class ThemeController extends GetxController {
  ThemeController(this._storage) {
    mode.value = _decode(_storage.read<String>(AppStorageKey.themeMode));
  }

  static ThemeController get to => Get.find();

  final GetStorageService _storage;
  final Rx<ThemeMode> mode = ThemeMode.system.obs;

  Future<void> setMode(ThemeMode value) async {
    mode.value = value;
    Get.changeThemeMode(value);
    await _storage.write(AppStorageKey.themeMode, value.name);
  }

  ThemeMode _decode(String? raw) => ThemeMode.values.firstWhere(
        (m) => m.name == raw,
        orElse: () => ThemeMode.system,
      );
}
