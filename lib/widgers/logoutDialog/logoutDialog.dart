import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/widgers/confirmDialog/confirmDialog.dart';

class LogoutDialog {
  LogoutDialog._();

  static Future<bool> show() => ConfirmDialog.show(
        title: AppConstString.logoutTitle,
        message: AppConstString.logoutMessage,
        confirmLabel: AppConstString.logout,
        isDestructive: true,
      );
}
