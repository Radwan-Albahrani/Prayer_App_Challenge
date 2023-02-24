import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayer_app/models/prayer_times.dart';
import 'package:prayer_app/screens/widgets/prayer_row.dart';

class PrayerTimesWidget extends StatelessWidget {
  List<PrayerTimes> prayerTimes;
  int selected;
  PrayerTimesWidget(
      {super.key, required this.prayerTimes, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrayerRow(
          prayerTimes: prayerTimes,
          selected: selected,
          prayerName: "Fajr",
          color: Colors.orange.shade100,
        ),
        PrayerRow(
          prayerTimes: prayerTimes,
          selected: selected,
          prayerName: "Dhuhr",
          color: Colors.orange.shade300,
        ),
        PrayerRow(
          prayerTimes: prayerTimes,
          selected: selected,
          prayerName: "Asr",
          color: Colors.orange.shade500,
        ),
        PrayerRow(
          prayerTimes: prayerTimes,
          selected: selected,
          prayerName: "Maghrib",
          color: Colors.green.shade400,
        ),
        PrayerRow(
          prayerTimes: prayerTimes,
          selected: selected,
          prayerName: "Isha",
          color: Colors.green.shade100,
        ),
      ],
    );
  }
}
