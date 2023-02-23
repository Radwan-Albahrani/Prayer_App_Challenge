import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prayer_app/screens/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var myIndex = 0;
  List<Widget> myPages = const [
    HomePage(),
    Text('Search', style: TextStyle(fontSize: 40)),
    Text('Favorite', style: TextStyle(fontSize: 40)),
    Text('Dhikr', style: TextStyle(fontSize: 40)),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPages[myIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          duration: const Duration(milliseconds: 300),
          tabBackgroundColor: Colors.indigo.shade400,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.bookmark,
              text: 'Favorite',
            ),
            GButton(
              icon: Icons.menu_book_outlined,
              text: 'Dhikr',
            ),
          ],
          selectedIndex: myIndex,
          onTabChange: (index) {
            setState(() {
              myIndex = index;
            });
          },
        ),
      ),
    );
  }
}
