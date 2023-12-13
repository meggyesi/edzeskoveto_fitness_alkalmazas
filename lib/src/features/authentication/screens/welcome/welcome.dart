import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:wtracker/src/widgets/custom_app_bar.dart';
import 'package:wtracker/src/widgets/custom_bottom_navigation_bar.dart';
import '../../../../repository/user_repository/user_repository.dart';
import '../../models/user_model.dart';
import '../tracker/workout_tracker_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final UserRepository _userRepository = Get.find<UserRepository>();

  List<DateTime> _loggedInDays = [];

  @override
  void initState() {
    super.initState();
    loadLoggedInDays();
  }

  void loadLoggedInDays() async {
    // Get the current user ID
    String userId = _userRepository.currentUser?.uid ?? '';

    // Fetch the user data from the repository
    UserModel user = await _userRepository.getUser(userId);

    setState(() {
      _loggedInDays = user.loggedInDays;
    });
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day) ||
                    _loggedInDays.contains(day);
              },

              onDaySelected: null, // Disable the ability to select dates
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (_loggedInDays
                      .any((loggedInDay) => isSameDate(loggedInDay, date))) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  // Return null if there is nomarker for the date
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(top: 50), // Set top margin
              width: 250, // Set width of the button
              height: 50, // Set height of the button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutTrackerScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle:
                      const TextStyle(fontSize: 18), // Optionally set text size
                ),
                child: const Text('Új edzés megkezdése'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
