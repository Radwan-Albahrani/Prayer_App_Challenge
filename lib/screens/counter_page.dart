import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:prayer_app/API/firestore_manager.dart';

// Counter Screen, taking dhikr and current count as a parameter
class CounterScreen extends StatefulWidget {
  final String dhikr;
  final int currentCount;
  const CounterScreen({
    super.key,
    required this.dhikr,
    required this.currentCount,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // counter variable
  int counter = 0;

  // Get the current count from the parameters and set it to the counter variable
  @override
  void initState() {
    super.initState();
    setState(() {
      counter = widget.currentCount;
    });
  }

  // =================== Build And Design ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await FireStoreManager.updateDhikrCount(widget.dhikr, counter);
          return true;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.dhikr,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedFlipCounter(
              value: counter,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              textStyle: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    shape: MaterialStateProperty.all(
                      const CircleBorder(),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      counter++;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    shape: MaterialStateProperty.all(
                      const CircleBorder(),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      counter = 0;
                    });
                  },
                  child: const Icon(Icons.restore),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
