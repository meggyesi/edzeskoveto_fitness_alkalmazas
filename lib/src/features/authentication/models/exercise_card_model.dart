class ExerciseData {
  final String exerciseName;
  final String userId;
  final Map<int, String> workoutSeries;

  ExerciseData({
    required this.exerciseName,
    required this.userId,
    required this.workoutSeries,
  });

  factory ExerciseData.fromDocument(Map<String, dynamic> document) {
    return ExerciseData(
      exerciseName: document['exerciseName'],
      userId: document['userId'],
      workoutSeries: Map<int, String>.from(document['workoutSeries']),
    );
  }

  static ExerciseData fromArrayDocument(
      String exerciseName, String userId, List<dynamic> array) {
    Map<int, String> workoutSeries = {};

    for (var i = 0; i < array.length; i++) {
      Map<String, dynamic> entry = array[i] as Map<String, dynamic>;
      workoutSeries[i] = entry.toString();
    }

    return ExerciseData(
      exerciseName: exerciseName,
      userId: userId,
      workoutSeries: workoutSeries,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'exerciseName': exerciseName,
      'userId': userId,
      'workoutSeries': workoutSeries,
    };
  }
}
