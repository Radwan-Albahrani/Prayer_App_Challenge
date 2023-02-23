// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_times.freezed.dart';
part 'prayer_times.g.dart';

@freezed
class PrayerTimes with _$PrayerTimes {
  factory PrayerTimes({
    @JsonKey(name: 'date') required Map<String, dynamic> date,
    @JsonKey(name: 'timings') required Map<String, dynamic> timings,
  }) = _PrayerTimes;

  factory PrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesFromJson(json);
}
