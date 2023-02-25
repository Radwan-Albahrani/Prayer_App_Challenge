import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prayer_app/screens/favorites_page.dart';
import 'package:prayer_app/screens/home_page.dart';
import 'package:prayer_app/screens/search_page.dart';
import 'package:prayer_app/screens/thikr_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // =================== Build And Design ===================
  var myIndex = 0;
  late PageController _pageController;

  // List of all pages accessible through the navbar
  List<Widget> myPages = const [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    DhikrPage()
  ];

  // Initialize the page controller
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: myIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            myIndex = index;
          });
        },
        children: myPages,
      ),
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
              _pageController.animateToPage(myIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            });
          },
        ),
      ),
    );
  }
}
