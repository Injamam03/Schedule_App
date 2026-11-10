import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime startOfNextDay(DateTime d) =>
      DateTime(d.year, d.month, d.day + 1);

  /// Weeks run Monday -> Sunday.
  static DateTime startOfWeek(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - 1));
  static DateTime startOfNextWeek(DateTime d) {
    final s = startOfWeek(d);
    return DateTime(s.year, s.month, s.day + 7);
  }

  static DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month);
  static DateTime startOfNextMonth(DateTime d) => DateTime(d.year, d.month + 1);

  static DateTime combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  static String formatDate(DateTime d) => DateFormat('EEE, d MMM yyyy').format(d);
  static String formatShortDate(DateTime d) => DateFormat('d MMM').format(d);
  static String formatTime(DateTime d) => DateFormat('h:mm a').format(d);
  static String formatDateTime(DateTime d) =>
      '${formatShortDate(d)}, ${formatTime(d)}';

  /// "2d 3h", "1h 20m", "45m", "<1m"
  static String formatDuration(Duration d) {
    final totalMinutes = d.inMinutes.abs();
    if (totalMinutes < 1) return '<1${AppConstString.unitMinute}';
    final days = totalMinutes ~/ 1440;
    final hours = (totalMinutes % 1440) ~/ 60;
    final minutes = totalMinutes % 60;
    if (days > 0) {
      return '$days${AppConstString.unitDay} $hours${AppConstString.unitHour}';
    }
    if (hours > 0) {
      return '$hours${AppConstString.unitHour} $minutes${AppConstString.unitMinute}';
    }
    return '$minutes${AppConstString.unitMinute}';
  }

  /// "5m ago" for recent times, otherwise a short date + time.
  static String relative(DateTime t, DateTime now) {
    final diff = now.difference(t);
    if (diff.inHours < 24 && !diff.isNegative) {
      return AppConstString.ago(formatDuration(diff));
    }
    return formatDateTime(t);
  }
}
