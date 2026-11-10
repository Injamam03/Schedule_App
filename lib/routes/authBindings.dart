import 'package:get/get.dart';
import 'package:jamal_flutter_app/screens/baseScreen/authScreen/sign_in/controller/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(SignInController.new);
  }
}
