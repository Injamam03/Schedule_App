import 'package:get/get.dart';
import 'package:jamal_flutter_app/core/theme/theme_controller.dart';
import 'package:jamal_flutter_app/services/auth_service.dart';
import 'package:jamal_flutter_app/services/note_service.dart';
import 'package:jamal_flutter_app/services/notification_feed_service.dart';
import 'package:jamal_flutter_app/services/notification_service.dart';
import 'package:jamal_flutter_app/services/photo_service.dart';
import 'package:jamal_flutter_app/services/repository/auth_repository.dart';
import 'package:jamal_flutter_app/services/repository/note_repository.dart';
import 'package:jamal_flutter_app/services/repository/schedule_repository.dart';
import 'package:jamal_flutter_app/services/schedule_service.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';

/// Registers every long-lived service once at start-up.
///
/// FIREBASE SWITCH-OVER: replace the three Local*Repository registrations
/// below with Firebase-backed implementations; nothing else changes.
class AppDependencies {
  AppDependencies._();

  static Future<void> init() async {
    final storage = Get.put(GetStorageService(), permanent: true);
    Get.put(ThemeController(storage), permanent: true);

    final notifications = await Get.putAsync<NotificationService>(
      () => NotificationService(storage).init(),
      permanent: true,
    );

    final AuthRepository authRepo = LocalAuthRepository(storage);
    final ScheduleRepository scheduleRepo = LocalScheduleRepository(storage);
    final NoteRepository noteRepo = LocalNoteRepository(storage);

    await Get.putAsync<AuthService>(() => AuthService(authRepo).init(), permanent: true);

    final schedules = await Get.putAsync<ScheduleService>(
      () => ScheduleService(scheduleRepo, notifications).init(),
      permanent: true,
    );
    await Get.putAsync<NoteService>(() => NoteService(noteRepo).init(), permanent: true);
    await Get.putAsync<PhotoService>(() => PhotoService(storage).init(), permanent: true);
    await Get.putAsync<NotificationFeedService>(
      () => NotificationFeedService(schedules, notifications, storage).init(),
      permanent: true,
    );
  }
}
