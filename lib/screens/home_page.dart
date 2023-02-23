import 'package:flutter/material.dart';
import 'package:prayer_app/API/api_manager.dart';
import 'package:prayer_app/models/prayer_times.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  final ScrollController _controller = ScrollController();
  late final List<PrayerTimes> prayerTimes;
  var selected = DateTime.now().day - 1;

  void getCalendar() async {
    setState(() {
      isLoading = true;
    });
    APIManager apiManager = APIManager();
    prayerTimes = await apiManager.getPrayerTimesByCity('cairo', 'egypt');
    setState(() {
      isLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpTo(
          84.5 * (DateTime.now().day - 1),
        ));
  }

  @override
  void initState() {
    getCalendar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prayer Times', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.indigo.shade400,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              child: Row(
                children: List.generate(
                  prayerTimes.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(8),
                      width: index == selected ? 100 : 75,
                      height: index == selected ? 120 : 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index == selected
                            ? Colors.indigo.shade400
                            : Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            prayerTimes[index]
                                .date["readable"]
                                .toString()
                                .substring(0, 6),
                          ),
                          Text(
                            prayerTimes[index]
                                .date["gregorian"]["weekday"]["en"]
                                .toString()
                                .substring(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
