class PhotoModel {
  const PhotoModel({
    required this.id,
    required this.fileName,
    required this.createdAt,
  });

  final int id;
  final String fileName;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        id: json['id'] as int,
        fileName: json['fileName'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      );
}
