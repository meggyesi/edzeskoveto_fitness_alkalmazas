import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/exercise_card_controller.dart';
import '../features/authentication/models/exercise_card_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef OnVolumeChanged = void Function(int volume);

class ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final VoidCallback onDelete;
  final List<Map<String, dynamic>> sets;
  final ValueChanged<List<Map<String, dynamic>>> onSetsChange;
  final ValueChanged<int> onVolumeChanged;

  const ExerciseCard({
    Key? key,
    required this.exerciseName,
    required this.onDelete,
    required this.sets,
    required this.onSetsChange,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Map<String, dynamic>> sets;
  final ExerciseCardController exerciseCardController =
      Get.put(ExerciseCardController());
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  int volume = 0; // Introduce a variable to store the volume

  void calculateVolume() {
    int newVolume = 0;
    for (var set in sets) {
      int reps = int.tryParse(set['Ismétlés'].toString()) ?? 0;
      int weight = int.tryParse(set['KG'].toString()) ?? 0;
      newVolume += reps * weight;
    }
    setState(() {
      volume = newVolume;
    });
    widget.onVolumeChanged(volume); // Call the new callback
  }

  int currentSetIndex = 0; // Local index for each exercise card
  @override
  void initState() {
    super.initState();
    sets = List.from(widget.sets);
    calculateVolume();
  }

  void onSetsChange(List<Map<String, dynamic>> newSets) {
    Map<int, String> workoutSeries = {};
    for (Map<String, dynamic> set in newSets) {
      int setNumber = set['Széria'];
      int reps = set['Ismétlés'];
      int weight = set['KG'];
      workoutSeries[setNumber] = '${reps}X$weight';
    }

    ExerciseData data = ExerciseData(
      exerciseName: widget.exerciseName,
      userId: userId,
      workoutSeries: workoutSeries,
    );

    exerciseCardController.createOrUpdateExerciseData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Volume: $volume'),
                Text(widget.exerciseName),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(0.8),
              1: FlexColumnWidth(1.1),
              2: FlexColumnWidth(1.1),
              3: FlexColumnWidth(1.1),
              4: FlexColumnWidth(0.9),
            },
            children: [
              const TableRow(
                children: [
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(8.0), child: Text('Széria'))),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(8.0), child: Text('Előző'))),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Ismétlés'))),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(8.0), child: Text('KG'))),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(8.0), child: Text('Kész'))),
                ],
              ),
              ...sets.map((set) {
                return TableRow(
                  children: [
                    _createTextCell(set, 'Széria'),
                    _createTextCell(set, 'Előző'),
                    _createEditableTextCell(set, 'Ismétlés'),
                    _createEditableTextCell(set, 'KG'),
                    _createCheckboxCell(set, 'Kész'),
                  ],
                );
              }).toList(),
            ],
          ),
          ElevatedButton(
            child: const Text('Széria hozzáadása'),
            onPressed: () async {
              final User? currentUser = _auth.currentUser;
              if (currentUser != null) {
                String userId = currentUser.uid;
                ExerciseData? data = await exerciseCardController
                    .getExerciseDataByUserId(userId, widget.exerciseName);
                setState(() {
                  if (data != null) {
                    if (data.workoutSeries.entries.length > (sets.length + 1)) {
                      for (var entry in data.workoutSeries.entries) {
                        String repsXweight = entry.value;
                        List<String> parts = repsXweight.split(',');
                        try {
                          int reps = int.parse(parts[2].substring(10));
                          int weight = int.parse(parts[3].substring(5));
                          String elozo =
                              "${parts[2].substring(10)}X${parts[3].substring(5)}";
                          sets.add({
                            'Széria': sets.length + 1,
                            'Előző': elozo,
                            'Ismétlés': reps.toString(),
                            'KG': weight.toString(),
                            'Kész': false,
                          });
                        } catch (e) {}
                      }
                    } else {
                      sets.add({
                        'Széria': sets.length + 1,
                        'Előző': 0,
                        'Ismétlés': 0,
                        'KG': 0,
                        'Kész': false,
                      });
                    }
                  } else {
                    sets.add({
                      'Széria': sets.length + 1,
                      'Előző': 0,
                      'Ismétlés': 0,
                      'KG': 0,
                      'Kész': false,
                    });
                  }
                  widget.onSetsChange(sets);
                });
              }
              calculateVolume();
            },
          )
        ],
      ),
    );
  }

  Widget _createTextCell(Map<String, dynamic> set, String key) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        set[key].toString(),
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget _createEditableTextCell(Map<String, dynamic> set, String key) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: set[key].toString(),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            set[key] = int.tryParse(value) ?? 0;
            widget.onSetsChange(sets);
            calculateVolume();
          },
        ),
      ),
    );
  }

  Widget _createCheckboxCell(Map<String, dynamic> set, String key) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            height: 23.0, // Adjust the height as needed
            alignment: Alignment.center,
            child: Checkbox(
              value: set[key],
              onChanged: (bool? value) {
                setState(() {
                  set[key] = value;
                });
                widget.onSetsChange(sets);
              },
            ),
          ),
        ),
      ),
    );
  }
}
