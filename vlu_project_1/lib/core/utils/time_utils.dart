import 'package:flutter/material.dart';

DateTime get now => DateTime.now();

class TimeUtils {
  static double secondsToMinutes(int seconds) {
    return seconds / 60;
  }

  static double secondsToHours(int seconds) {
    return seconds / 3600;
  }

  static TimeOfDay? tryParseTime(String? time) {
    try {
      final parts = time!.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return null;
    }
  }

  // Return days of month in [date]
  static int daysOfMonths(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
