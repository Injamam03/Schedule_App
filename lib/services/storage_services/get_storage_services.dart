import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Thin wrapper over GetStorage so the backing store can be swapped later.
class GetStorageService extends GetxService {
  static Future<void> init() => GetStorage.init();

  final GetStorage _box = GetStorage();

  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write(String key, dynamic value) => _box.write(key, value);

  Future<void> remove(String key) => _box.remove(key);

  /// Reads a JSON list of maps (GetStorage returns List<dynamic> after restart).
  List<Map<String, dynamic>> readList(String key) {
    final raw = _box.read<dynamic>(key);
    if (raw is! List) return <Map<String, dynamic>>[];
    return raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: true);
  }

  /// Monotonic integer ids (also used as notification id seeds).
  Future<int> nextId(String counterKey) async {
    final next = (_box.read<int>(counterKey) ?? 0) + 1;
    await _box.write(counterKey, next);
    return next;
  }
}
