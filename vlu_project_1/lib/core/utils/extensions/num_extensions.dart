import 'package:flutter/material.dart';

extension DurationExt on num {
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  Duration get minutes =>
      Duration(seconds: (this * Duration.secondsPerMinute).round());

  Duration get hours =>
      Duration(minutes: (this * Duration.minutesPerHour).round());

  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());
}

extension IntExt on int {
  bool toBool() {
    return this == 1 ? true : false;
  }

  int? toNullIfZero() {
    if (this == 0) return null;
    return this;
  }

  List<T> genList<T>(T Function(int index) gen) {
    return List.generate(this, gen);
  }

  SizedBox get swb => SizedBox(width: toDouble());
  SizedBox get shb => SizedBox(height: toDouble());
}

extension DoubleExt on double {
  SizedBox get swb => SizedBox(width: toDouble());
  SizedBox get shb => SizedBox(height: toDouble());
}
