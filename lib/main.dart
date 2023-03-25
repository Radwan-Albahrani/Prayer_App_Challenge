import 'package:flutter/material.dart';
import 'package:prayer_app/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'API/firestore_manager.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';

// this is the main function. It will initialize firebase as well as notification handler
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoading = true;
  var displayPopup = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermissions();
  }

  Future checkPermissions() async {
    await FireStoreManager.addDevice();
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          displayPopup = true;
          isLoading = false;
        });
        return;
      }
    }
    // if denied, send an error
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        displayPopup = true;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = false;
    });

    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Ask for permission
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : displayPopup
              ? const Scaffold(
                  body: Center(child: Text("Please enable location services")),
                )
              : const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
