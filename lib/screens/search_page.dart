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
  // =================== Build And Design ===================
  @override
  void initState() {
    super.initState();
    // If address given in initialization, start searching immediately
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

  // =================== Helper Methods ===================
  var isLoading = false;
  var searchCompleted = false;
  bool isFavorite = false;
  final ScrollController _controller = ScrollController();
  late List<PrayerTimes> prayerTimes;
  TextEditingController addressForm = TextEditingController();

  String? city;
  String? country;

  // Function to show snackbar if address is empty
  void showsnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1, milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getCalendarByAddress() async {
    // check if the address is empty
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

    // Start loading
    setState(() {
      searchCompleted = false;
      isLoading = true;
    });

    // get the city and country
    APIManager apiManager = APIManager();
    var cityAndCountry = await apiManager.getCityAndCountryByAddress(address);

    // Set them into the state
    setState(() {
      city = cityAndCountry[0];
      country = cityAndCountry[1];
    });

    // Get the prayer times
    try {
      prayerTimes = await apiManager.getPrayerTimesByCity(city, country);
    } catch (e) {
      Future.delayed(const Duration(seconds: 1), () {
        showsnackbar(
            context, "API limit reached, Try again in a couple of Minutes");
      });
      setState(() {
        isLoading = false;
      });
      return;
    }
    // Check if the city is in the favorites list
    var favoritesList = await FireStoreManager.getFavorites();
    for (Map element in favoritesList) {
      if (element['city'] == city && element['country'] == country) {
        setState(() {
          isFavorite = true;
        });
      }
    }

    // Finish loading
    setState(() {
      isLoading = false;
      searchCompleted = true;
    });

    // Scroll to today
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpTo(
          85 * (DateTime.now().day - 1),
        ));
  }
}
