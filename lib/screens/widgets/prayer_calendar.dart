import 'package:flutter/material.dart';
import 'package:prayer_app/API/firestore_manager.dart';
import 'package:prayer_app/screens/widgets/prayer_times.dart';

import '../../models/prayer_times.dart';

class PrayerCalendar extends StatefulWidget {
  final List<PrayerTimes> prayerTimes;
  final ScrollController? controller;
  final String? city;
  final String? country;
  final bool isFavorite;
  const PrayerCalendar(
      {super.key,
      required this.prayerTimes,
      this.controller,
      this.city,
      this.country,
      this.isFavorite = false});

  @override
  State<PrayerCalendar> createState() => _PrayerCalendarState();
}

class _PrayerCalendarState extends State<PrayerCalendar> {
  var selected = DateTime.now().day - 1;
  bool isFavorite = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.city != null && widget.country != null
            ? Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (isFavorite) {
                          await FireStoreManager.removeFavorite(
                              widget.city.toString(),
                              widget.country.toString());
                        } else {
                          await FireStoreManager.addFavorite(
                              widget.city!, widget.country!);
                        }

                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border),
                    ),
                    // Favorite button
                    Text(
                      "${widget.city}, ${widget.country}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.controller,
            child: Row(
              children: List.generate(
                widget.prayerTimes.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8),
                    width: index == selected ? 100 : 75,
                    height: index == selected ? 120 : 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: index == selected
                          ? Colors.indigo.shade400
                          : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.prayerTimes[index].date["readable"]
                              .toString()
                              .substring(0, 6),
                          style: TextStyle(
                            color:
                                index == selected ? Colors.white : Colors.black,
                            fontSize: index == selected ? 24 : 18,
                            fontWeight: index == selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          widget.prayerTimes[index]
                              .date["gregorian"]["weekday"]["en"]
                              .toString()
                              .substring(0, 3),
                          style: TextStyle(
                            color: index == selected
                                ? Colors.grey.shade400
                                : Colors.black,
                            fontSize: index == selected ? 18 : 10,
                            fontWeight: index == selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        PrayerTimesWidget(prayerTimes: widget.prayerTimes, selected: selected),
      ],
    );
  }
}
