import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/prayer_times.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class APIManager {
  // API URL
  static const apiUrl = 'http://api.aladhan.com/v1/';
  static const calenderByCity = "$apiUrl/calendarByCity";

  // Get Prayer Times By City and Country
  Future<Map<String, dynamic>> getCalendarByCity(city, country) async {
    // Assume year and month are now
    final year = DateTime.now().year;
    final month = DateTime.now().month;

    // Get the response from the API
    final response = await http.get(Uri.parse(
        '$calenderByCity/$year/$month?city=$city&country=$country&method=8'));
    final data = json.decode(response.body);

    // Check if the response is valid
    if (response.statusCode == 200) {
      return data;
    } else {
      if (data['code'] == 400) {
        throw Exception('Invalid city or country');
      } else {
        throw Exception('Something went wrong');
      }
    }
  }

  // Get Prayer Times By City and Country and Date
  Future<Map<String, dynamic>> getCalendarByCityAndDate(
      city, country, year, month) async {
    // Get the response from the API
    final response = await http.get(Uri.parse(
        '$calenderByCity/$year/$month?city=$city&country=$country&method=8'));
    final data = json.decode(response.body);
    // Check if the response is valid
    if (response.statusCode == 200) {
      return data;
    } else {
      if (data['code'] == 400) {
        throw Exception('Invalid city or country');
      } else {
        throw Exception('Something went wrong');
      }
    }
  }

  // Get Prayer Times Object By City and Country
  Future<List<PrayerTimes>> getPrayerTimesByCity(city, country) async {
    // Get the response from the API
    var data = await getCalendarByCity(city, country);
    final List<PrayerTimes> prayerTimes = [];
    // Convert the response to a list of PrayerTimes objects
    for (var i = 0; i < data['data'].length; i++) {
      prayerTimes.add(PrayerTimes.fromJson(data['data'][i]));
    }
    return prayerTimes;
  }

  // Get Prayer Times Object By City and Country and Date
  Future<List<PrayerTimes>> getPrayerTimesByCityAndDate(
      city, country, year, month) async {
    // Get the response from the API
    var data = await getCalendarByCityAndDate(city, country, year, month);
    final List<PrayerTimes> prayerTimes = [];

    // Convert the response to a list of PrayerTimes objects
    for (var i = 0; i < data['data'].length; i++) {
      prayerTimes.add(PrayerTimes.fromJson(data['data'][i]));
    }
    return prayerTimes;
  }

  // Get the next prayer
  Future<MapEntry<String, DateTime>> getNextPrayer(city, country) async {
    // Get the prayer times
    var data = await getPrayerTimesByCity(city, country);

    // Get the current date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Loop through the data
    for (var i = 0; i < data.length; i++) {
      // Get the date of the current entry
      var dayMonthYear =
          DateFormat('dd-MM-yyyy').parse(data[i].date['gregorian']['date']);
      var finalFormatted =
          DateFormat('yyyy-MM-dd').parse(dayMonthYear.toString());
      final date = DateTime.parse(finalFormatted.toString());

      // Check if the date is today
      if (date == today) {
        // Get the timings
        final timings = data[i].timings;
        var timeFormat = DateFormat('HH:mm');
        var listOfTimes = <String, DateTime>{};

        // Convert all the timings to a DateTime object and add them to the list
        timings.forEach((key, value) {
          var time = timeFormat.parse(value);
          var finalTime = DateTime(date.year, date.month, date.day, time.hour,
              time.minute, time.second);
          listOfTimes.addEntries([MapEntry(key, finalTime)]);
        });
        var returnList = <String, DateTime>{};

        // Loop through the list and add the next prayer to the return list
        listOfTimes.forEach((key, value) {
          if (value.isAfter(now)) {
            var nextPrayer = key;
            var nextPrayerTime = value;
            returnList.addEntries([MapEntry(nextPrayer, nextPrayerTime)]);
          }
        });
        try {
          // Check if the next prayer is Fajr, Dhuhr, Asr, Maghrib or Isha
          var entry = returnList.entries.first;
          if (entry.key == "Firstthird" ||
              entry.key == "Lastthird" ||
              entry.key == "Midnight") {
            // if not, get the next prayer tomorrow
            entry = await _getNextPrayerTomorrow(city, country);
          }
          return entry;
        } catch (e) {
          return MapEntry("NONE", DateTime.now());
        }
      }
    }
    return MapEntry("NONE", DateTime.now());
  }

  // Get the next prayer tomorrow
  Future<MapEntry<String, DateTime>> _getNextPrayerTomorrow(
      city, country) async {
    var data = await getPrayerTimesByCity(city, country);
    final now = DateTime.now();

    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (tomorrow.month > now.month) {
      data = await getPrayerTimesByCityAndDate(
          city, country, now.year, now.month + 1);
    }
    for (var i = 0; i < data.length; i++) {
      var dayMonthYear =
          DateFormat('dd-MM-yyyy').parse(data[i].date['gregorian']['date']);
      var finalFormatted =
          DateFormat('yyyy-MM-dd').parse(dayMonthYear.toString());
      final date = DateTime.parse(finalFormatted.toString());
      if (date == tomorrow) {
        final timings = data[i].timings;
        var timeFormat = DateFormat('HH:mm');
        var listOfTimes = <String, DateTime>{};
        timings.forEach((key, value) {
          var time = timeFormat.parse(value);
          var finalTime = DateTime(date.year, date.month, date.day, time.hour,
              time.minute, time.second);
          listOfTimes.addEntries([MapEntry(key, finalTime)]);
        });
        var returnList = <String, DateTime>{};
        listOfTimes.forEach((key, value) {
          if (value.isAfter(now)) {
            var nextPrayer = key;
            var nextPrayerTime = value;
            returnList.addEntries([MapEntry(nextPrayer, nextPrayerTime)]);
          }
        });
        try {
          var entry = returnList.entries.first;
          return entry;
        } catch (e) {
          return MapEntry("NONE", DateTime.now());
        }
      }
    }
    return MapEntry("NONE", DateTime.now());
  }

  // Get the location of the device
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    // if denied, send an error
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Get city and country from the device location
  Future<List<String?>> getCityAndCountry() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String? city = placemark.locality;
    String? country = placemark.country;
    return [city, country];
  }

  // Get city and country from an address
  Future<List<String?>> getCityAndCountryByAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        locations[0].latitude, locations[0].longitude);
    Placemark placemark = placemarks[0];
    String? city = placemark.locality;
    String? country = placemark.country;
    return [city, country];
  }
}
