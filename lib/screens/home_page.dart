import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:prayer_app/API/api_manager.dart';
import 'package:prayer_app/API/firestore_manager.dart';
import 'package:prayer_app/models/prayer_times.dart';
import 'package:prayer_app/screens/widgets/prayer_calendar.dart';
import 'package:cron/cron.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, WidgetsBindingObserver {
  // =================== Build And Design ===================
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Ask for permission
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    getCalendar();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                                return timeFormatMethod(duration);
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
                              onComplete: () {
                                AwesomeNotifications().createNotification(
                                    content: NotificationContent(
                                        id: 10,
                                        channelKey: 'basic_channel',
                                        title: 'Prayer Time',
                                        body:
                                            '${timeUntilNextPrayer.key} is now. Please Head to the Mosque!',
                                        actionType: ActionType.Default));
                                getCalendar();
                              },
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

  // ===================== Helper Methods =====================
  // All necessary Variables
  var isLoading = false;
  final ScrollController _controller = ScrollController();
  late List<PrayerTimes> prayerTimes;
  late MapEntry<String, DateTime> timeUntilNextPrayer;
  late int differenceInSeconds;
  String? city;
  String? country;
  bool isFavorite = false;

  // Function to get the calendar
  void getCalendar() async {
    // Set it to loading
    setState(() {
      isLoading = true;
    });
    // Initialize the API Manager and get the city and country
    APIManager apiManager = APIManager();
    var cityAndCountry = await apiManager.getCityAndCountry();

    // Set the city and country
    setState(() {
      city = cityAndCountry[0];
      country = cityAndCountry[1];
    });

    // Get the prayer times and the next prayer
    prayerTimes = await apiManager.getPrayerTimesByCity(city, country);
    var nextPrayer = await apiManager.getNextPrayer(city, country);

    // Check if the city is a favorite
    var favoritesList = await FireStoreManager.getFavorites();
    for (Map element in favoritesList) {
      if (element['city'] == city && element['country'] == country) {
        setState(() {
          isFavorite = true;
        });
      }
    }

    // Set the loading to false and initialize all necessary variables and components
    setState(() {
      isLoading = false;
      var now = DateTime.now();
      var difference = nextPrayer.value.difference(now);
      differenceInSeconds = difference.inSeconds;
      timeUntilNextPrayer = nextPrayer;
    });

    // Scroll to the current day
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpTo(
          84.5 * (DateTime.now().day - 1),
        ));
  }

  // A method to format the time on the timer
  String timeFormatMethod(Duration duration) {
    // get the hours, minutes, seconds from duration
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    // format them and return
    if (hours > 0) {
      String hoursString = hours.toString().padLeft(2, '0');
      String minutesString = minutes.toString().padLeft(2, '0');
      String secondsString = seconds.toString().padLeft(2, '0');
      return '$hoursString:$minutesString:$secondsString';
    } else if (minutes > 0) {
      String minutesString = minutes.toString().padLeft(2, '0');
      String secondsString = seconds.toString().padLeft(2, '0');
      return '$minutesString:$secondsString';
    } else {
      String secondsString = seconds.toString().padLeft(2, '0');
      return secondsString;
    }
  }

  // Method to schedule a notification if the app is sent to the background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      // Get the difference in seconds till the next prayer
      var apiManager = APIManager();
      var nextPrayer = await apiManager.getNextPrayer(city, country);
      var differenceInSeconds =
          nextPrayer.value.difference(DateTime.now()).inSeconds;
      debugPrint(differenceInSeconds.toString());

      // Use Cron to schedule the notification
      Cron().schedule(Schedule.parse('$differenceInSeconds * * * * *'),
          () async {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Prayer Time',
                body:
                    '${timeUntilNextPrayer.key} is now. Please Head to the Mosque!'));
      });
    }
    debugPrint(state.toString());
  }
}
