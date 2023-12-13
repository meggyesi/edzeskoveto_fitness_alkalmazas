import 'package:flutter/material.dart';
import 'package:wtracker/src/widgets/custom_app_bar.dart';
import 'package:wtracker/src/widgets/custom_bottom_navigation_bar.dart';
import '../welcome/welcome.dart';

class AfterWorkoutScreen extends StatefulWidget {
  final int totalVolume;
  final int elapsedTime;

  const AfterWorkoutScreen(
      {Key? key, required this.totalVolume, required this.elapsedTime})
      : super(key: key); // Added totalVolume as a required parameter

  @override
  _AfterWorkoutScreenState createState() => _AfterWorkoutScreenState();
}

class _AfterWorkoutScreenState extends State<AfterWorkoutScreen> {
  String getFormattedTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m ${remainingSeconds}s";
    }

    return "${minutes}m ${remainingSeconds}s";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edzés Elemzése'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Text(
                      'Edzés hossza: ${getFormattedTime(widget.elapsedTime)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Megmozgatott súly: ${widget.totalVolume}  KG',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Welcome(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Befejezés'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
