import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_config.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/services/notification_service.dart';
import 'package:jamal_flutter_app/services/repository/schedule_repository.dart';
import 'package:jamal_flutter_app/services/retention_policy.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';

/// Owns all schedule state + status transitions + notification sync.
/// Controllers only observe [schedules] / [now] and call the methods below.
class ScheduleService extends GetxService with WidgetsBindingObserver {
  ScheduleService(this._repo, this._notifications);

  static ScheduleService get to => Get.find();

  final ScheduleRepository _repo;
  final NotificationService _notifications;

  final RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;

  /// Ticks while the app is open so "currently working" / "missed" are live.
  final Rx<DateTime> now = DateTime.now().obs;

  Timer? _timer;
  bool _syncing = false;

  Future<ScheduleService> init() async {
    schedules.assignAll(await _repo.getAll());
    await sync();
    await _notifications.rescheduleAll(schedules);
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(AppConfig.tickInterval, (_) => sync());
    return this;
  }

  @override
  void onClose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) sync();
  }

  // ---------------------------------------------------------------- queries

  ScheduleModel? byId(int id) {
    for (final s in schedules) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// The task whose time has arrived and is still running today.
  ScheduleModel? get activeSchedule {
    final t = now.value;
    final active = schedules.where((s) => s.isActive(t)).toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return active.isEmpty ? null : active.first;
  }

  ScheduleModel? get nextSchedule {
    final t = now.value;
    final next = schedules
        .where((s) =>
            s.status == ScheduleStatus.upcoming && s.scheduledAt.isAfter(t))
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return next.isEmpty ? null : next.first;
  }

  ScheduleModel? get recentlyCompleted {
    final done = schedules
        .where((s) => s.status == ScheduleStatus.completed)
        .toList()
      ..sort((a, b) => (b.completedAt ?? b.scheduledAt)
          .compareTo(a.completedAt ?? a.scheduledAt));
    return done.isEmpty ? null : done.first;
  }

  // -------------------------------------------------------------- mutations

  Future<ScheduleModel> create({
    required String title,
    required String description,
    required DateTime scheduledAt,
  }) async {
    final stamp = DateTime.now();
    final schedule = ScheduleModel(
      id: await _repo.nextId(),
      title: title,
      description: description,
      scheduledAt: scheduledAt,
      status: ScheduleStatus.upcoming,
      createdAt: stamp,
      updatedAt: stamp,
    );
    await _repo.upsert(schedule);
    schedules.add(schedule);
    await _notifications.scheduleFor(schedule);
    return schedule;
  }

  Future<void> updateDetails(
    ScheduleModel schedule, {
    required String title,
    required String description,
    required DateTime scheduledAt,
  }) async {
    final updated = schedule.copyWith(
      title: title,
      description: description,
      scheduledAt: scheduledAt,
      updatedAt: DateTime.now(),
    );
    await _replace(updated);
    await _notifications.scheduleFor(updated);
  }

  Future<void> markCompleted(int id) async {
    final s = byId(id);
    if (s == null || !s.canComplete) return;
    await _replace(
      s.copyWith(status: ScheduleStatus.completed, completedAt: DateTime.now()),
    );
    await _notifications.cancelFor(id);
  }

  /// Returns false when cancelling is no longer allowed (time has passed).
  Future<bool> cancel(int id) async {
    final s = byId(id);
    final t = DateTime.now();
    if (s == null || !s.canCancel(t)) return false;
    await _replace(
      s.copyWith(status: ScheduleStatus.cancelled, cancelledAt: t),
    );
    await _notifications.cancelFor(id);
    return true;
  }

  // ------------------------------------------------------------------- sync

  /// Refreshes the clock, flips overdue schedules to missed and purges
  /// records past the retention window.
  Future<void> sync() async {
    now.value = DateTime.now();
    if (_syncing) return;
    _syncing = true;
    try {
      await _markMissed();
      await _purgeExpired();
    } catch (e) {
      AppLog.e('Schedule sync failed', e);
    } finally {
      _syncing = false;
    }
  }

  Future<void> _markMissed() async {
    final t = now.value;
    final overdue = schedules
        .where((s) =>
            s.status == ScheduleStatus.upcoming && !t.isBefore(s.deadline))
        .toList();
    for (final s in overdue) {
      // The "missed" notification was already scheduled in advance.
      await _replace(
        s.copyWith(status: ScheduleStatus.missed, missedAt: s.deadline),
      );
    }
  }

  Future<void> _purgeExpired() async {
    final t = now.value;
    final expired = schedules.where((s) => RetentionPolicy.isExpired(s, t)).toList();
    if (expired.isEmpty) return;
    final ids = expired.map((s) => s.id).toList();
    for (final id in ids) {
      await _notifications.cancelFor(id);
    }
    await _repo.deleteMany(ids);
    schedules.removeWhere((s) => ids.contains(s.id));
    AppLog.d('Retention: removed ${ids.length} expired schedule(s)');
  }

  Future<void> _replace(ScheduleModel updated) async {
    await _repo.upsert(updated);
    final index = schedules.indexWhere((s) => s.id == updated.id);
    if (index >= 0) {
      schedules[index] = updated;
    } else {
      schedules.add(updated);
    }
  }
}
