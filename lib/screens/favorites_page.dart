import 'package:flutter/material.dart';
import 'package:prayer_app/screens/search_page.dart';

import '../API/firestore_manager.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  var isLoading = false;
  var favoritesList = [];

  Future getFavorites() async {
    setState(() {
      isLoading = true;
    });
    favoritesList = await FireStoreManager.getFavorites();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: favoritesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchPage(
                        address:
                            "${favoritesList[index]['city']}, ${favoritesList[index]['country']}",
                      );
                    }));
                  },
                  child: ListTile(
                    title: Text(favoritesList[index]['city']),
                    subtitle: Text(favoritesList[index]['country']),
                    trailing: IconButton(
                      onPressed: () async {
                        await FireStoreManager.removeFavorite(
                            favoritesList[index]['city'],
                            favoritesList[index]['country']);
                        getFavorites();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
