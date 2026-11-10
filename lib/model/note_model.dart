class NoteModel {
  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel copyWith({String? title, String? content, DateTime? updatedAt}) =>
      NoteModel(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'] as int,
        title: (json['title'] ?? '') as String,
        content: (json['content'] ?? '') as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      );
}
