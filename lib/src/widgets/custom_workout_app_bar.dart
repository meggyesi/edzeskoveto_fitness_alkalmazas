import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWorkoutAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Function(int elapsedTime) onTimeUpdated;
  const CustomWorkoutAppBar({Key? key, required this.onTimeUpdated})
      : super(key: key);

  @override
  _CustomWorkoutAppBarState createState() => _CustomWorkoutAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomWorkoutAppBarState extends State<CustomWorkoutAppBar> {
  final TextEditingController _controller =
      TextEditingController(text: 'Edzés neve.');
  late Stopwatch _stopwatch;
  late Stream<int> _stopwatchStream;
  Timer? _countdownTimer;
  int _remainingTime = 0;
  bool _isCountdownActive = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _stopwatchStream = Stream.periodic(const Duration(seconds: 1), (x) {
      if (!_stopwatch.isRunning) _stopwatch.start();
      widget.onTimeUpdated(_stopwatch.elapsed.inSeconds);
      return _stopwatch.elapsed.inSeconds;
    });
  }

  void showCountdownSelection(BuildContext context) {
    Duration selectedDuration = const Duration();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: 260,
          child: Column(
            children: [
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  onTimerDurationChanged: (Duration duration) {
                    selectedDuration = duration;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          bottomSheetContext); // Close the bottom sheet without starting the timer
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          bottomSheetContext); // Close the bottom sheet
                      startCountdown(selectedDuration.inSeconds);
                    },
                    child: const Text('Start Timer'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void startCountdown(int seconds) {
    setState(() {
      _remainingTime = seconds;
      _isCountdownActive = true;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isCountdownActive = false;
          timer.cancel();
          showTimerEndDialog(context); // Show dialog when timer ends
        }
      });
    });
  }

  void showTimerEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pihenőidő vége'),
          content: const Text('Lejárt a beállított pihenőidőd.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _isCountdownActive
          ? Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  formatTime(_remainingTime),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => showCountdownSelection(context),
              child: const Icon(Icons.timer, color: Colors.black),
            ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            hintText: 'Edzés neve.',
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<int>(
              stream: _stopwatchStream,
              builder: (context, snapshot) {
                final int seconds = snapshot.data ?? 0;
                final String formattedTime = formatTime(seconds);
                return Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
