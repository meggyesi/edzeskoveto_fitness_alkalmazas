import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../features/authentication/models/exercise_card_model.dart'; // Replace with the actual path to your ExerciseData model

class ExerciseCardController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Making it private to control the access
  final _exerciseData = Rx<ExerciseData?>(null);

  // Provide a public method to access it if required
  ExerciseData? get exerciseData => _exerciseData.value;

  // New version of getExerciseDataByUserId
  Future<ExerciseData?> getExerciseDataByUserId(
      String userId, String exerciseName) async {
    try {
      // Get the document from Firestore
      DocumentSnapshot doc =
          await _db.collection('exerciseCard').doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

        // Null-safety check
        if (docData != null && docData.containsKey(exerciseName)) {
          List<dynamic>? exerciseDataList = docData[exerciseName];

          // If the exercise data exists
          if (exerciseDataList != null) {
            ExerciseData data = ExerciseData.fromArrayDocument(
                exerciseName, userId, exerciseDataList); // Using new method
            _exerciseData.value = data;
            return data;
          }
        }
      }
      return null;
    } catch (e) {
    }
    return null;
  }

  // Your existing methods remain unchanged
  Future<void> createOrUpdateExerciseData(ExerciseData data) async {
    try {
      await _db
          .collection('exerciseCard')
          .doc('${data.userId}-${data.exerciseName}')
          .set(data.toDocument());
    } catch (e) {
    }
  }

  Future<void> endWorkoutAndUploadData(String userId, List<String> exercises,
      List<List<Map<String, dynamic>>> exerciseSets) async {
    try {
      DocumentReference userDoc = _db.collection('exerciseCard').doc(userId);
      DocumentSnapshot existingDoc = await userDoc.get();
      Map<String, List<Map<String, dynamic>>> updateData = {};

      for (int i = 0; i < exercises.length; i++) {
        String exercise = exercises[i];
        updateData[exercise] = exerciseSets[i];
      }

      if (existingDoc.exists) {
        // Update existing document
        await userDoc.update(updateData);
      } else {
        // Create new document
        await userDoc.set({'userId': userId, 'exercises': updateData});
      }
    } catch (e) {
      print("Error ending workout and uploading data: $e");
    }
  }
}
