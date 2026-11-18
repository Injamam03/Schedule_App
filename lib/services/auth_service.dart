import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamal_flutter_app/model/app_user_data.dart';
import 'package:jamal_flutter_app/services/repository/auth_repository.dart';
import 'package:jamal_flutter_app/utils/app_files.dart';
import 'package:path/path.dart' as p;

class AuthService extends GetxService {
  AuthService(this._repo);

  static AuthService get to => Get.find();

  final AuthRepository _repo;
  final Rxn<AppUserData> user = Rxn<AppUserData>();

  bool get isLoggedIn => user.value != null;

  Future<AuthService> init() async {
    user.value = _repo.currentUser();
    return this;
  }

  Future<void> signIn({required String email, required String password}) async {
    user.value = await _repo.signIn(email: email, password: password);
  }

  Future<void> signOut() async {
    await _repo.signOut();
    user.value = null;
  }

  /// Updates the user's name and saves to persistent storage.
  Future<void> updateName(String newName) async {
    final current = user.value;
    if (current == null) return;
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    user.value = await _repo.updateUser(current.copyWith(name: trimmed));
  }

  /// Lets the user pick a profile picture from gallery or camera and stores it privately.
  Future<void> changeAvatar([ImageSource source = ImageSource.gallery]) async {
    final current = user.value;
    if (current == null) return;
    final picked = await ImagePicker()
        .pickImage(source: source, imageQuality: 85, maxWidth: 800);
    if (picked == null) return;

    final name =
        'avatar_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    await AppFiles.avatar(name).writeAsBytes(await picked.readAsBytes());

    final old = current.avatarFileName;
    user.value = await _repo.updateUser(current.copyWith(avatarFileName: name));
    if (old != null) await AppFiles.deleteQuietly(AppFiles.avatar(old));
  }
}
