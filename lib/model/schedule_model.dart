import 'package:jamal_flutter_app/utils/app_date_utils.dart';

enum ScheduleStatus { upcoming, completed, missed, cancelled }

class ScheduleModel {
  const ScheduleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    this.missedAt,
  });

  final int id;
  final String title;
  final String description;
  final DateTime scheduledAt;
  final ScheduleStatus status;
  final DateTime createdAt;

  /// Bumped only when title/description/time are edited, NOT on status
  /// changes (the notification feed relies on this).
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? missedAt;

  /// The moment the scheduled day is over. Still-upcoming schedules become
  /// "missed" at this point.
  DateTime get deadline => AppDateUtils.startOfNextDay(scheduledAt);

  bool canCancel(DateTime now) =>
      status == ScheduleStatus.upcoming && now.isBefore(scheduledAt);

  bool get canComplete =>
      status == ScheduleStatus.upcoming || status == ScheduleStatus.missed;

  /// Time has arrived, the day is not over, it hasn't been completed,
  /// and no subsequent schedule has become active.
  bool isActive(DateTime now, [Iterable<ScheduleModel>? allSchedules]) {
    if (status != ScheduleStatus.upcoming) return false;
    if (now.isBefore(scheduledAt) || !now.isBefore(deadline)) return false;
    if (allSchedules != null) {
      final hasLaterActive = allSchedules.any((s2) =>
          s2.id != id &&
          s2.status != ScheduleStatus.cancelled &&
          s2.scheduledAt.compareTo(scheduledAt) > 0 &&
          !now.isBefore(s2.scheduledAt));
      if (hasLaterActive) return false;
    }
    return true;
  }

  ScheduleModel copyWith({
    String? title,
    String? description,
    DateTime? scheduledAt,
    ScheduleStatus? status,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? missedAt,
  }) =>
      ScheduleModel(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        completedAt: completedAt ?? this.completedAt,
        cancelledAt: cancelledAt ?? this.cancelledAt,
        missedAt: missedAt ?? this.missedAt,
      );

  // Epoch-millis ints keep the map Firestore-friendly (swap for Timestamp
  // in the Firestore repository later).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'scheduledAt': scheduledAt.millisecondsSinceEpoch,
        'status': status.name,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
        'completedAt': completedAt?.millisecondsSinceEpoch,
        'cancelledAt': cancelledAt?.millisecondsSinceEpoch,
        'missedAt': missedAt?.millisecondsSinceEpoch,
      };

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    DateTime? ms(dynamic v) =>
        v == null ? null : DateTime.fromMillisecondsSinceEpoch(v as int);
    return ScheduleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: (json['description'] ?? '') as String,
      scheduledAt: DateTime.fromMillisecondsSinceEpoch(json['scheduledAt'] as int),
      status: ScheduleStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ScheduleStatus.upcoming,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      completedAt: ms(json['completedAt']),
      cancelledAt: ms(json['cancelledAt']),
      missedAt: ms(json['missedAt']),
    );
  }
}
