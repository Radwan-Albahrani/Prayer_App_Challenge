import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/prayer_times.dart';

class APIManager {
  static const apiUrl = 'http://api.aladhan.com/v1/';
  static const calenderByCity = "$apiUrl/calendarByCity";

  Future<Map<String, dynamic>> getCalendarByCity(city, country) async {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final response = await http.get(Uri.parse(
        '$calenderByCity/$year/$month?city=$city&country=$country&method=8'));
    final data = json.decode(response.body);
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

  Future<Map<String, dynamic>> getCalendarByCityAndDate(
      city, country, year, month) async {
    final response = await http.get(Uri.parse(
        '$calenderByCity/$year/$month?city=$city&country=$country&method=8'));
    final data = json.decode(response.body);
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

  Future<List<PrayerTimes>> getPrayerTimesByCity(city, country) async {
    var data = await getCalendarByCity(city, country);
    final List<PrayerTimes> prayerTimes = [];
    for (var i = 0; i < data['data'].length; i++) {
      prayerTimes.add(PrayerTimes.fromJson(data['data'][i]));
    }
    return prayerTimes;
  }

  Future<List<PrayerTimes>> getPrayerTimesByCityAndDate(
      city, country, year, month) async {
    var data = await getCalendarByCityAndDate(city, country, year, month);
    final List<PrayerTimes> prayerTimes = [];
    for (var i = 0; i < data['data'].length; i++) {
      prayerTimes.add(PrayerTimes.fromJson(data['data'][i]));
    }
    return prayerTimes;
  }

  Future<MapEntry<String, DateTime>> getNextPrayer(city, country) async {
    var data = await getPrayerTimesByCity(city, country);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < data.length; i++) {
      var dayMonthYear =
          DateFormat('dd-MM-yyyy').parse(data[i].date['gregorian']['date']);
      var finalFormatted =
          DateFormat('yyyy-MM-dd').parse(dayMonthYear.toString());
      final date = DateTime.parse(finalFormatted.toString());
      if (date == today) {
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

  Future<MapEntry<String, DateTime>> getNextPrayerTomorrow(
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
}
