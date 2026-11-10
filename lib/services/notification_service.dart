import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_config.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/model/schedule_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/auth_service.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Local scheduled notifications.
///
/// Every schedule owns 3 notification ids (id*3 + slot):
///   0 = reminder (before), 1 = start (exact time), 2 = missed.
///
/// TODO(firebase): add FcmService (firebase_messaging) next to this class for
/// push notifications; it can reuse [reminderLeadMinutes] and the payload.
class NotificationService extends GetxService {
  NotificationService(this._storage);

  static NotificationService get to => Get.find();

  final GetStorageService _storage;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  String? _launchPayload;

  static const int _slotReminder = 0;
  static const int _slotStart = 1;
  static const int _slotMissed = 2;

  int get reminderLeadMinutes =>
      _storage.read<int>(AppStorageKey.reminderLeadMinutes) ??
      AppConfig.reminderLeadMinutes;

  Future<void> setReminderLeadMinutes(int minutes) =>
      _storage.write(AppStorageKey.reminderLeadMinutes, minutes);

  int _id(int scheduleId, int slot) => scheduleId * 3 + slot;

  Future<NotificationService> init() async {
    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      // Scheduling uses absolute instants, so UTC fallback stays correct.
      AppLog.e('Could not resolve local timezone, using UTC', e);
      tz.setLocalLocation(tz.UTC);
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onResponse,
    );

    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _launchPayload = launch?.notificationResponse?.payload;
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        AppConfig.notificationChannelId,
        AppConstString.notifChannelName,
        description: AppConstString.notifChannelDescription,
        importance: Importance.high,
      ),
    );
    return this;
  }

  /// Payload of the notification that cold-started the app (consumed once).
  String? takeLaunchPayload() {
    final p = _launchPayload;
    _launchPayload = null;
    return p;
  }

  void _onResponse(NotificationResponse response) =>
      openFromPayload(response.payload);

  /// Opens the schedule details screen for a notification payload.
  static void openFromPayload(String? payload) {
    final id = int.tryParse(payload ?? '');
    if (id == null) return;
    if (!Get.isRegistered<AuthService>() || !AuthService.to.isLoggedIn) return;
    Get.toNamed(AppRoutes.scheduleDetails, arguments: id);
  }

  /// Asks for the notification permission. Returns whether it was granted.
  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    var granted = true;
    try {
      if (android != null) {
        granted = await android.requestNotificationsPermission() ?? false;
      }
      if (ios != null) {
        granted = await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (e) {
      AppLog.e('Notification permission request failed', e);
    }
    return granted;
  }

  /// Android 12+ gates exact alarms. Asks (once) so reminders fire on time;
  /// without it we silently fall back to inexact alarms.
  Future<void> ensureExactAlarmAccess() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      final can = await android.canScheduleExactNotifications() ?? true;
      final asked = _storage.read<bool>(AppStorageKey.exactAlarmAsked) ?? false;
      if (!can && !asked) {
        await _storage.write(AppStorageKey.exactAlarmAsked, true);
        await android.requestExactAlarmsPermission();
      }
    } catch (e) {
      AppLog.e('Exact alarm permission request failed', e);
    }
  }

  Future<bool> _canUseExact() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    try {
      return await android.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// (Re)creates all notifications of one schedule. Safe to call repeatedly:
  /// used on create, edit and at app start.
  Future<void> scheduleFor(ScheduleModel s) async {
    await cancelFor(s.id);
    if (s.status != ScheduleStatus.upcoming) return;

    final now = DateTime.now();
    final exact = await _canUseExact();
    final payload = s.id.toString();

    final reminderAt =
        s.scheduledAt.subtract(Duration(minutes: reminderLeadMinutes));
    if (reminderAt.isAfter(now)) {
      await _schedule(
        id: _id(s.id, _slotReminder),
        when: reminderAt,
        title: AppConstString.notifReminderTitle,
        body: AppConstString.notifReminderBody(s.title, reminderLeadMinutes),
        payload: payload,
        exact: exact,
      );
    }
    if (s.scheduledAt.isAfter(now)) {
      await _schedule(
        id: _id(s.id, _slotStart),
        when: s.scheduledAt,
        title: AppConstString.notifStartTitle,
        body: AppConstString.notifStartBody(s.title),
        payload: payload,
        exact: exact,
      );
    }
    final missedAt = s.deadline.add(AppConfig.missedNotificationDelay);
    if (missedAt.isAfter(now)) {
      await _schedule(
        id: _id(s.id, _slotMissed),
        when: missedAt,
        title: AppConstString.notifMissedTitle,
        body: AppConstString.notifMissedBody(s.title),
        payload: payload,
        exact: exact,
      );
    }
  }

  Future<void> cancelFor(int scheduleId) async {
    for (final slot in [_slotReminder, _slotStart, _slotMissed]) {
      try {
        await _plugin.cancel(id: _id(scheduleId, slot));
      } catch (e) {
        AppLog.e('Cancel notification failed', e);
      }
    }
  }

  Future<void> rescheduleAll(Iterable<ScheduleModel> schedules) async {
    for (final s in schedules) {
      if (s.status == ScheduleStatus.upcoming) await scheduleFor(s);
    }
  }

  Future<void> _schedule({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required String payload,
    required bool exact,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        AppConfig.notificationChannelId,
        AppConstString.notifChannelName,
        channelDescription: AppConstString.notifChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    try {
      await _plugin.zonedSchedule(
        id: id,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: details,
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        payload: payload,
      );
    } catch (e) {
      AppLog.e('Scheduling notification $id failed', e);
    }
  }
}
