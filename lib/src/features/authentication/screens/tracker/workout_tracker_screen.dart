import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../constants/exercise_list.dart';
import '../../../../widgets/ExerciseCard.dart';
import '../../../../widgets/custom_workout_app_bar.dart';
import '../../../../repository/exercise_card_controller.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import 'after_workout_screen.dart';
import '../../../../repository/user_repository/user_repository.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';

class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({Key? key}) : super(key: key);

  @override
  _WorkoutTrackerScreenState createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ExerciseCardController exerciseCardController =
      Get.put(ExerciseCardController());
  int elapsedTime = 0;

  List<String> exercises = [];
  List<List<Map<String, dynamic>>> exerciseSets = [];
  List<int> exerciseVolumes = [];

  static const double paddingValue = 8.0;

  void updateTime(int newElapsedTime) {
    setState(() {
      elapsedTime = newElapsedTime;
    });
  }

  void handleVolumeChange(int index, int newVolume) {
    exerciseVolumes[index] = newVolume;
  }

  int calculateTotalVolume() {
    return exerciseVolumes.fold(0, (sum, current) => sum + current);
  }

  Widget _buildExerciseCard(int index) {
    return ExerciseCard(
      key: ValueKey(exercises[index] + index.toString()),
      exerciseName: exercises[index],
      sets: exerciseSets[index],
      onDelete: () => setState(() {
        exercises.removeAt(index);
        exerciseSets.removeAt(index);
        exerciseVolumes.removeAt(index);
      }),
      onSetsChange: (sets) => setState(() => exerciseSets[index] = sets),
      onVolumeChanged: (newVolume) => handleVolumeChange(index, newVolume),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingValue),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text('Gyakorlat hozzáadása'),
        items: exerciseList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              exercises.add(newValue);
              exerciseSets.add([]);
              exerciseVolumes.add(0); // Initialize volume for the new exercise
            });
          }
        },
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(paddingValue),
      child: ElevatedButton(
        onPressed: () async {
          final User? currentUser = _auth.currentUser;
          String? userId = AuthenticationRepository.instance.currentUser?.uid;
          if (currentUser != null) {
            final String userId = currentUser.uid;
            await exerciseCardController.endWorkoutAndUploadData(
              userId,
              exercises,
              exerciseSets,
            );
            final int totalVolume = calculateTotalVolume();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AfterWorkoutScreen(
                    totalVolume: totalVolume, elapsedTime: elapsedTime),
              ),
            );
          }
          if (userId != null) {
            UserModel currentUser =
                await UserRepository.instance.getUser(userId);
            List<DateTime> loggedInDays = currentUser.loggedInDays;
            DateTime currentDate = DateTime.now();

            bool isAlreadyLoggedIn =
                loggedInDays.any((date) => isSameDate(date, currentDate));

            if (!isAlreadyLoggedIn) {
              loggedInDays.add(currentDate);
              await UserRepository.instance
                  .updateLoggedInDays(userId, loggedInDays);
            }
          }
        },
        child: const Text('Edzés befejezése'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWorkoutAppBar(onTimeUpdated: updateTime),
      body: ListView.builder(
        itemCount: exercises.length + 2,
        itemBuilder: (context, index) {
          if (index < exercises.length) {
            return _buildExerciseCard(index);
          } else if (index == exercises.length) {
            return _buildDropdown();
          } else {
            return _buildSubmitButton();
          }
        },
      ),
    );
  }
}
