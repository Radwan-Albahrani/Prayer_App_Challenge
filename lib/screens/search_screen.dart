import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_app/API/api_manager.dart';
import 'package:prayer_app/models/prayer_times.dart';
import 'package:prayer_app/screens/widgets/prayer_calendar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var isLoading = false;
  var searchCompleted = false;
  final ScrollController _controller = ScrollController();
  late List<PrayerTimes> prayerTimes;
  TextEditingController addressForm = TextEditingController();

  String? city;
  String? country;

  void showsnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1, milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getCalendarByAddress() async {
    var address = addressForm.text;
    if (address.isEmpty) {
      showsnackbar(context, "Please enter an address");
      return;
    }
    // empty the text field
    addressForm.clear();
    // hide the keyboard
    FocusScope.of(context).unfocus();
    setState(() {
      searchCompleted = false;
      isLoading = true;
    });
    APIManager apiManager = APIManager();
    var cityAndCountry = await apiManager.getCityAndCountryByAddress(address);
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
    setState(() {
      isLoading = false;
      searchCompleted = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpTo(
          85 * (DateTime.now().day - 1),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Search for a City/Country',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  controller: addressForm,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    getCalendarByAddress();
                  },
                  child: const Text('Search'),
                ),
                !isLoading
                    ? const Center()
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
          searchCompleted
              ? Expanded(
                  child: SingleChildScrollView(
                    child: PrayerCalendar(
                      prayerTimes: prayerTimes,
                      controller: _controller,
                      city: city,
                      country: country,
                    ),
                  ),
                )
              : const Center()
        ],
      ),
    );
  }
}
