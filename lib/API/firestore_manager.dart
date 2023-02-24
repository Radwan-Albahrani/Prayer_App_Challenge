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
      await firestore.collection('devices').doc(androidId).set({
        'deviceID': androidId,
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
        'Favorites': [],
      });
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
}
