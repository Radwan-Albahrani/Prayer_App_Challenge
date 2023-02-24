import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:prayer_app/API/api_manager.dart';
import 'package:prayer_app/API/firestore_manager.dart';
import 'package:prayer_app/models/prayer_times.dart';
import 'package:prayer_app/screens/widgets/prayer_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  final ScrollController _controller = ScrollController();
  late final List<PrayerTimes> prayerTimes;
  late MapEntry<String, DateTime> timeUntilNextPrayer;
  late int differenceInSeconds;
  String? city;
  String? country;
  bool isFavorite = false;

  void getCalendar() async {
    setState(() {
      isLoading = true;
    });
    APIManager apiManager = APIManager();
    var cityAndCountry = await apiManager.getCityAndCountry();
    setState(() {
      city = cityAndCountry[0];
      country = cityAndCountry[1];
    });
    prayerTimes = await apiManager.getPrayerTimesByCity(city, country);
    var nextPrayer = await apiManager.getNextPrayer(city, country);
    if (nextPrayer.key == "Firstthird" ||
        nextPrayer.key == "Lastthird" ||
        nextPrayer.key == "Midnight") {
      nextPrayer = await apiManager.getNextPrayerTomorrow(city, country);
    }

    var favoritesList = await FireStoreManager.getFavorites();
    for (Map element in favoritesList) {
      if (element['city'] == city && element['country'] == country) {
        setState(() {
          isFavorite = true;
        });
      }
    }
    setState(() {
      isLoading = false;
      var now = DateTime.now();
      var difference = nextPrayer.value.difference(now);
      differenceInSeconds = difference.inSeconds;
      timeUntilNextPrayer = nextPrayer;
    });

    // find time between now and next prayer
    // var now = DateTime.now()
    // var difference = nextPrayerTime.difference(now);
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpTo(
          84.5 * (DateTime.now().day - 1),
        ));
  }

  @override
  void initState() {
    getCalendar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prayer Times', style: TextStyle(fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isLoading
                  ? [
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ]
                  : [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Text(
                              "Time Until ${timeUntilNextPrayer.key}",
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: CircularCountDownTimer(
                              duration: differenceInSeconds,
                              timeFormatterFunction: (time, duration) {
                                // get the hours, minutes, seconds from duration
                                int hours = duration.inHours;
                                int minutes = duration.inMinutes.remainder(60);
                                int seconds = duration.inSeconds.remainder(60);

                                if (hours > 0) {
                                  String hoursString =
                                      hours.toString().padLeft(2, '0');
                                  String minutesString =
                                      minutes.toString().padLeft(2, '0');
                                  String secondsString =
                                      seconds.toString().padLeft(2, '0');
                                  return '$hoursString:$minutesString:$secondsString';
                                } else if (minutes > 0) {
                                  String minutesString =
                                      minutes.toString().padLeft(2, '0');
                                  String secondsString =
                                      seconds.toString().padLeft(2, '0');
                                  return '$minutesString:$secondsString';
                                } else {
                                  String secondsString =
                                      seconds.toString().padLeft(2, '0');
                                  return secondsString;
                                }
                              },
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.width / 4,
                              ringColor: Colors.grey.shade300,
                              ringGradient: LinearGradient(colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                              ]),
                              fillColor: Colors.indigo,
                              fillGradient: null,
                              backgroundColor: Colors.grey.shade800,
                              backgroundGradient: null,
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textFormat: CountdownTextFormat.S,
                              isReverse: true,
                              isReverseAnimation: false,
                              isTimerTextShown: true,
                              autoStart: true,
                            ),
                          ),
                        ],
                      ),
                    ],
            ),
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(100),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : city != null && country != null
              ? SingleChildScrollView(
                  child: PrayerCalendar(
                    prayerTimes: prayerTimes,
                    controller: _controller,
                    city: city,
                    country: country,
                    isFavorite: isFavorite,
                  ),
                )
              : PrayerCalendar(
                  prayerTimes: prayerTimes,
                  controller: _controller,
                  isFavorite: isFavorite,
                ),
    );
  }
}
