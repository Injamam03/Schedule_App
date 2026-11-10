import 'package:get/get.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/routes/appBindings.dart';
import 'package:jamal_flutter_app/routes/authBindings.dart';
import 'package:jamal_flutter_app/screens/baseScreen/authScreen/sign_in/sign_in_screen.dart';
import 'package:jamal_flutter_app/screens/baseScreen/notificationScreen/notificationScreen.dart';
import 'package:jamal_flutter_app/screens/homeScreen/mainScreen/mainScreen.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/createSchedule/createScheduleScreen.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/scheduleDetails/scheduleDetailsScreen.dart';
import 'package:jamal_flutter_app/screens/profileScreen/createNote/createNoteScreen.dart';
import 'package:jamal_flutter_app/screens/profileScreen/notes/notesScreen.dart';
import 'package:jamal_flutter_app/screens/profileScreen/savedPhotos/photoViewerScreen.dart';
import 'package:jamal_flutter_app/screens/profileScreen/savedPhotos/savedPhotosScreen.dart';

class AppRoutesFile {
  AppRoutesFile._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.createSchedule,
      page: () => const CreateScheduleScreen(),
      binding: CreateScheduleBinding(),
    ),
    GetPage(
      name: AppRoutes.scheduleDetails,
      page: () => const ScheduleDetailsScreen(),
      binding: ScheduleDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.notes,
      page: () => const NotesScreen(),
      binding: NotesBinding(),
    ),
    GetPage(
      name: AppRoutes.createNote,
      page: () => const CreateNoteScreen(),
      binding: CreateNoteBinding(),
    ),
    GetPage(
      name: AppRoutes.savedPhotos,
      page: () => const SavedPhotosScreen(),
      binding: SavedPhotosBinding(),
    ),
    GetPage(
      name: AppRoutes.photoViewer,
      page: () => const PhotoViewerScreen(),
    ),
  ];
}
