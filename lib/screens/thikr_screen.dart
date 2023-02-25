import 'package:flutter/material.dart';
import 'package:need_resume/need_resume.dart';

import '../API/firestore_manager.dart';
import 'counter_page.dart';

class DhikrPage extends StatefulWidget {
  const DhikrPage({super.key});

  @override
  State<DhikrPage> createState() => _DhikrPageState();
}

class _DhikrPageState extends ResumableState<DhikrPage> {
  // =================== Build And Design ===================
  @override
  void initState() {
    super.initState();
    getDhikr();
  }

  @override
  void onResume() {
    getDhikr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhikr'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: dhikrList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CounterScreen(
                                dhikr: dhikrList[index]["name"],
                                currentCount: dhikrList[index]["count"],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await FireStoreManager
                                              .updateDhikrFavorite(
                                                  dhikrList[index]["name"],
                                                  !dhikrList[index]
                                                      ["isFavorite"]);
                                          getDhikr();
                                        },
                                        icon: dhikrList[index]["isFavorite"]
                                            ? const Icon(Icons.favorite)
                                            : const Icon(Icons.favorite_border),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(20),
                                  alignment: Alignment.centerRight,
                                  child: Text(dhikrList[index]["name"]),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // =================== Helper Methods ===================
  var isLoading = false;

  var dhikrList = [];
  // Get all dhikr from firestore
  Future<void> getDhikr() async {
    setState(() {
      isLoading = true;
    });
    dhikrList = await FireStoreManager.getDhikrs();
    setState(() {
      isLoading = false;
    });
  }
}
