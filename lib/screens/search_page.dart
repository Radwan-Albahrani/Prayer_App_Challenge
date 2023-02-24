import 'package:flutter/material.dart';
import 'package:prayer_app/API/api_manager.dart';
import 'package:prayer_app/API/firestore_manager.dart';
import 'package:prayer_app/models/prayer_times.dart';
import 'package:prayer_app/screens/widgets/prayer_calendar.dart';

class SearchPage extends StatefulWidget {
  final String address;
  const SearchPage({super.key, this.address = ""});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var isLoading = false;
  var searchCompleted = false;
  bool isFavorite = false;
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
    if (widget.address.isEmpty) {
      FocusScope.of(context).unfocus();
    }
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
      searchCompleted = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpTo(
          85 * (DateTime.now().day - 1),
        ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.address.isNotEmpty) {
      addressForm.text = widget.address;
      getCalendarByAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.address.isEmpty
            ? const Text('Search',
                style: TextStyle(color: Colors.white, fontSize: 20))
            : const Text("Favorites",
                style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
        children: [
          widget.address.isEmpty
              ? Padding(
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
                )
              : !isLoading
                  ? const Center()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 20),
                        CircularProgressIndicator(),
                      ],
                    ),
          searchCompleted
              ? Expanded(
                  child: SingleChildScrollView(
                    child: PrayerCalendar(
                      prayerTimes: prayerTimes,
                      controller: _controller,
                      city: city,
                      country: country,
                      isFavorite: isFavorite,
                    ),
                  ),
                )
              : const Center()
        ],
      ),
    );
  }
}
