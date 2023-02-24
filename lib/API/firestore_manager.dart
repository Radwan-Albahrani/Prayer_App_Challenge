import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreManager {
  static Future<void> addDevice() async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      debugPrint('Device already exists');
    } else {
      debugPrint('Device does not exist');
      await firestore.collection('devices').doc(androidId).set(
        {
          'deviceID': androidId,
          'platform': Platform.operatingSystem,
          'version': Platform.operatingSystemVersion,
          'Favorites': [],
          'Dhikrs': [
            {
              'name': 'مَا يَقُولُ وَيَفْعَلُ مَنْ أَذْنَبَ ذَنْباً',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'دُعَاءُ مَنِ اسْتَصْعَبَ عَلَيْهِ أَمْرٌ',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'دُعَـــاءُ الذَّهَابِ إِلَى الْـمَسْـــجِدِ',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'فضل التسبيح والتهليل والتكبير',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'الاستغفار والتوبة',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'ما يقول لرد كيد مردة الشياطين',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'ما يقوله المسلم إذا فزع أو خاف',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'من خشي أن يصب شيئاً بعينه',
              'count': 0,
              "isFavorite": false,
            },
            {
              'name': 'ما يقول من أحس وجعاً في جسده',
              'count': 0,
              "isFavorite": false,
            }
          ]
        },
      );
    }
  }

  static Future<void> addFavorite(String city, String country) async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      var favoritesList = doc.data()!['Favorites'];
      debugPrint(favoritesList.toString());
      for (Map element in favoritesList) {
        if (element['city'] == city && element['country'] == country) {
          debugPrint('Favorite already exists');
          return;
        }
      }
      debugPrint('Favorite does not exist');
      await firestore.collection('devices').doc(androidId).update({
        'Favorites': FieldValue.arrayUnion([
          {
            'city': city,
            'country': country,
          }
        ])
      });
    }
  }

  static Future<void> removeFavorite(String city, String country) async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      var favoritesList = doc.data()!['Favorites'];
      debugPrint(favoritesList.toString());
      for (Map element in favoritesList) {
        if (element['city'] == city && element['country'] == country) {
          debugPrint('Favorite exists');
          await firestore.collection('devices').doc(androidId).update({
            'Favorites': FieldValue.arrayRemove([
              {
                'city': city,
                'country': country,
              }
            ])
          });
          return;
        }
      }
      debugPrint('Favorite does not exist');
    }
  }

  static Future<List<dynamic>> getFavorites() async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      var favoritesList = doc.data()!['Favorites'];
      debugPrint(favoritesList.toString());
      return favoritesList;
    }
    return [];
  }

  static Future<List<dynamic>> getDhikrs() async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      var dhikrsList = doc.data()!['Dhikrs'];
      debugPrint(dhikrsList.toString());
      return dhikrsList;
    }
    return [];
  }

  static Future<void> updateDhikrCount(String dhikr, int count) async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      var dhikrsList = doc.data()!['Dhikrs'];
      debugPrint(dhikrsList.toString());
      for (Map element in dhikrsList) {
        if (element['name'] == dhikr) {
          debugPrint('Dhikr exists');
          element['count'] = count;
          await firestore.collection('devices').doc(androidId).update({
            'Dhikrs': dhikrsList,
          });
          return;
        }
      }
      debugPrint('Dhikr does not exist');
    }
  }

  static Future<void> updateDhikrFavorite(String dhikr, bool isFavorite) async {
    var firestore = FirebaseFirestore.instance;
    // get deviceID
    const androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var doc = await firestore.collection('devices').doc(androidId).get();

    if (doc.exists) {
      var dhikrsList = doc.data()!['Dhikrs'];
      debugPrint(dhikrsList.toString());
      for (Map element in dhikrsList) {
        if (element['name'] == dhikr) {
          debugPrint('Dhikr exists');
          element['isFavorite'] = isFavorite;
          // sort dhikrsList
          dhikrsList.sort((a, b) {
            if (a['isFavorite'] == true) {
              return -1;
            } else {
              return 1;
            }
          });
          await firestore.collection('devices').doc(androidId).update({
            'Dhikrs': dhikrsList,
          });
          return;
        }
      }
      debugPrint('Dhikr does not exist');
    }
  }
}
