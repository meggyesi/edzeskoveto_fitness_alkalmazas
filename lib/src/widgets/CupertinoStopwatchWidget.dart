import 'dart:async';
import 'package:flutter/cupertino.dart';

class CupertinoStopwatchWidget extends StatefulWidget {
  final int initialSeconds;

  CupertinoStopwatchWidget({Key? key, required this.initialSeconds}) : super(key: key);

  @override
  _CupertinoStopwatchWidgetState createState() => _CupertinoStopwatchWidgetState();
}

class _CupertinoStopwatchWidgetState extends State<CupertinoStopwatchWidget> {
  late int _counter;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _counter = widget.initialSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Perform action when clicked, if needed
      },
      child: Text(
        "\$_counter",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
