import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';

/// Data-access contract. Implement [FirestoreScheduleRepository] later and
/// register it in AppDependencies instead of [LocalScheduleRepository].
abstract class ScheduleRepository {
  Future<List<ScheduleModel>> getAll();
  Future<int> nextId();
  Future<void> upsert(ScheduleModel schedule);
  Future<void> deleteMany(Iterable<int> ids);
}

class LocalScheduleRepository implements ScheduleRepository {
  LocalScheduleRepository(this._storage);

  final GetStorageService _storage;

  @override
  Future<List<ScheduleModel>> getAll() async => _storage
      .readList(AppStorageKey.schedules)
      .map(ScheduleModel.fromJson)
      .toList();

  @override
  Future<int> nextId() => _storage.nextId(AppStorageKey.idCounter);

  @override
  Future<void> upsert(ScheduleModel schedule) async {
    final list = _storage.readList(AppStorageKey.schedules);
    final index = list.indexWhere((e) => e['id'] == schedule.id);
    if (index >= 0) {
      list[index] = schedule.toJson();
    } else {
      list.add(schedule.toJson());
    }
    await _storage.write(AppStorageKey.schedules, list);
  }

  @override
  Future<void> deleteMany(Iterable<int> ids) async {
    final remove = ids.toSet();
    final list = _storage.readList(AppStorageKey.schedules)
      ..removeWhere((e) => remove.contains(e['id']));
    await _storage.write(AppStorageKey.schedules, list);
  }
}

// TODO(firebase): class FirestoreScheduleRepository implements ScheduleRepository
//   -> users/{uid}/schedules/{id}, using AppApiEndPoint paths.
