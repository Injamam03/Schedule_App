import 'package:get/get.dart';
import 'package:jamal_flutter_app/screens/baseScreen/notificationScreen/controller/notificationController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/homeTap/controller/homeTapController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/mainScreen/controller/mainController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/profileTab/controller/profiletapController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/controller/scheduleTabController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/createSchedule/controller/createScheduleController.dart';
import 'package:jamal_flutter_app/screens/homeScreen/scheduleTab/scheduleDetails/controller/scheduleDetailsController.dart';
import 'package:jamal_flutter_app/screens/profileScreen/createNote/controller/createNoteController.dart';
import 'package:jamal_flutter_app/screens/profileScreen/notes/controller/notesController.dart';
import 'package:jamal_flutter_app/screens/profileScreen/savedPhotos/controller/savedPhotosController.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
    Get.put<HomeTabController>(HomeTabController());
    Get.put<ScheduleTabController>(ScheduleTabController());
    Get.put<ProfileTabController>(ProfileTabController());
  }
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<NotificationsController>(NotificationsController.new);
}

class CreateScheduleBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<CreateScheduleController>(CreateScheduleController.new);
}

class ScheduleDetailsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<ScheduleDetailsController>(ScheduleDetailsController.new);
}

class NotesBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<NotesController>(NotesController.new);
}

class CreateNoteBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<CreateNoteController>(CreateNoteController.new);
}

class SavedPhotosBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<SavedPhotosController>(SavedPhotosController.new);
}
