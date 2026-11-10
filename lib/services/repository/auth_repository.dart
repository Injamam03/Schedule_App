import 'package:jamal_flutter_app/constant/app_storage_key.dart';
import 'package:jamal_flutter_app/model/app_user_data.dart';
import 'package:jamal_flutter_app/services/storage_services/get_storage_services.dart';

/// Authentication contract. A FirebaseAuthRepository can replace
/// [LocalAuthRepository] without touching any screen or controller.
abstract class AuthRepository {
  AppUserData? currentUser();
  Future<AppUserData> signIn({required String email, required String password});
  Future<void> signOut();
  Future<AppUserData> updateUser(AppUserData user);
}

/// Offline stand-in: any valid email/password creates a local session.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._storage);

  final GetStorageService _storage;
  static const _remembered = 'remembered_profile';

  @override
  AppUserData? currentUser() {
    final raw = _storage.read<Map>(AppStorageKey.currentUser);
    if (raw == null) return null;
    return AppUserData.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<AppUserData> signIn({
    required String email,
    required String password,
  }) async {
    // TODO(firebase): FirebaseAuth.instance.signInWithEmailAndPassword(...)
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final normalized = email.trim().toLowerCase();

    // Re-use the previous profile (name/avatar) if the same email returns.
    final old = _storage.read<Map>(_remembered);
    AppUserData user;
    if (old != null && old['email'] == normalized) {
      user = AppUserData.fromJson(Map<String, dynamic>.from(old));
    } else {
      final local = normalized.split('@').first;
      final name = local.isEmpty
          ? normalized
          : '${local[0].toUpperCase()}${local.substring(1)}';
      user = AppUserData(
        uid: normalized,
        name: name,
        email: normalized,
      );
    }
    await _storage.write(AppStorageKey.currentUser, user.toJson());
    return user;
  }

  @override
  Future<void> signOut() async {
    // TODO(firebase): FirebaseAuth.instance.signOut()
    final current = _storage.read<Map>(AppStorageKey.currentUser);
    if (current != null) await _storage.write(_remembered, current);
    await _storage.remove(AppStorageKey.currentUser);
  }

  @override
  Future<AppUserData> updateUser(AppUserData user) async {
    await _storage.write(AppStorageKey.currentUser, user.toJson());
    return user;
  }
}
