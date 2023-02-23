import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:prayer_app/API/api_manager.dart';
import 'package:prayer_app/models/prayer_times.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  final ScrollController _controller = ScrollController();
  late final List<PrayerTimes> prayerTimes;
  var selected = DateTime.now().day - 1;
  late MapEntry<String, DateTime> timeUntilNextPrayer;
  late int differenceInSeconds;

  void getCalendar() async {
    setState(() {
      isLoading = true;
    });
    APIManager apiManager = APIManager();
    prayerTimes = await apiManager.getPrayerTimesByCity('Saihat', 'Saudi');
    var nextPrayer = await apiManager.getNextPrayer("Saihat", "Saudi");
    if (nextPrayer.key == "Firstthird" ||
        nextPrayer.key == "Lastthird" ||
        nextPrayer.key == "Midnight") {
      nextPrayer = await apiManager.getNextPrayerTomorrow("Saihat", "Saudi");
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
                                String hours =
                                    duration.inHours.toString().padLeft(2, '0');
                                String minutes = duration.inMinutes
                                    .remainder(60)
                                    .toString()
                                    .padLeft(2, '0');
                                String seconds = duration.inSeconds
                                    .remainder(60)
                                    .toString()
                                    .padLeft(2, '0');
                                return '$hours:$minutes:$seconds';
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    child: Row(
                      children: List.generate(
                        prayerTimes.length,
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
                                  prayerTimes[index]
                                      .date["readable"]
                                      .toString()
                                      .substring(0, 6),
                                  style: TextStyle(
                                    color: index == selected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: index == selected ? 24 : 18,
                                    fontWeight: index == selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  prayerTimes[index]
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
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('Fajr'),
                        subtitle: Text(
                          prayerTimes[selected]
                              .timings["Fajr"]
                              .toString()
                              .substring(0, 5),
                        ),
                      ),
                      ListTile(
                        title: const Text('Dhuhr'),
                        subtitle: Text(
                          prayerTimes[selected]
                              .timings["Dhuhr"]
                              .toString()
                              .substring(0, 5),
                        ),
                      ),
                      ListTile(
                        title: const Text('Asr'),
                        subtitle: Text(
                          prayerTimes[selected]
                              .timings["Asr"]
                              .toString()
                              .substring(0, 5),
                        ),
                      ),
                      ListTile(
                        title: const Text('Maghrib'),
                        subtitle: Text(
                          prayerTimes[selected]
                              .timings["Maghrib"]
                              .toString()
                              .substring(0, 5),
                        ),
                      ),
                      ListTile(
                        title: const Text('Isha'),
                        subtitle: Text(
                          prayerTimes[selected]
                              .timings["Isha"]
                              .toString()
                              .substring(0, 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
