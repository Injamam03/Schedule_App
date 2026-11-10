import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/photo_model.dart';
import 'package:jamal_flutter_app/routes/app_routes.dart';
import 'package:jamal_flutter_app/services/photo_service.dart';
import 'package:jamal_flutter_app/utils/app_log.dart';
import 'package:jamal_flutter_app/utils/app_snackbar.dart';
import 'package:jamal_flutter_app/widgers/confirmDialog/confirmDialog.dart';

class SavedPhotosController extends GetxController {
  final PhotoService _service = PhotoService.to;
  final RxBool isBusy = false.obs;

  List<PhotoModel> get photos => _service.photos;

  Future<void> addPhotos() async {
    isBusy.value = true;
    try {
      final count = await _service.addFromGallery();
      if (count > 0) AppSnack.success(AppConstString.photosSaved(count));
    } catch (e) {
      AppLog.e('Saving photos failed', e);
      AppSnack.error(AppConstString.somethingWentWrong);
    } finally {
      isBusy.value = false;
    }
  }

  void open(int index) => Get.toNamed(AppRoutes.photoViewer, arguments: index);

  /// Returns true when the photo was deleted.
  Future<bool> delete(PhotoModel photo) async {
    final ok = await ConfirmDialog.show(
      title: AppConstString.deletePhotoTitle,
      message: AppConstString.deletePhotoMessage,
      confirmLabel: AppConstString.delete,
      isDestructive: true,
    );
    if (!ok) return false;
    await _service.delete(photo);
    AppSnack.success(AppConstString.photoDeleted);
    return true;
  }
}
