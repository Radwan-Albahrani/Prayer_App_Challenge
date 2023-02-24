import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/prayer_times.dart';

class PrayerRow extends StatelessWidget {
  List<PrayerTimes> prayerTimes;
  int selected;
  String prayerName;
  Color color;
  PrayerRow(
      {super.key,
      required this.prayerTimes,
      required this.selected,
      required this.prayerName,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 30),
            child: Text(
              prayerName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: Text(
                DateFormat("hh:mm a").format(
                  DateFormat("hh:mm").parse(
                    prayerTimes[selected]
                        .timings[prayerName]
                        .toString()
                        .substring(0, 5),
                  ),
                ),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
