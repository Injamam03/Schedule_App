/// Firestore / Storage paths used when Firebase is connected.
/// Nothing here is called yet; the Local* repositories are used instead.
class AppApiEndPoint {
  AppApiEndPoint._();

  static const String users = 'users';
  static const String schedules = 'schedules'; // users/{uid}/schedules
  static const String notes = 'notes'; // users/{uid}/notes
  static const String fcmTokens = 'fcmTokens'; // users/{uid}/fcmTokens
  static const String photosStorage = 'photos'; // Storage: photos/{uid}/...
}
