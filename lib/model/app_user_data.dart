class AppUserData {
  const AppUserData({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarFileName,
  });

  final String uid;
  final String name;
  final String email;

  /// File name inside AppFiles.avatarDir (null => placeholder image).
  final String? avatarFileName;

  AppUserData copyWith({String? name, String? avatarFileName}) => AppUserData(
        uid: uid,
        name: name ?? this.name,
        email: email,
        avatarFileName: avatarFileName ?? this.avatarFileName,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'avatarFileName': avatarFileName,
      };

  factory AppUserData.fromJson(Map<String, dynamic> json) => AppUserData(
        uid: json['uid'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        avatarFileName: json['avatarFileName'] as String?,
      );
}
